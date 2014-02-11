Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065AbaBKR3d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 12:29:33 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:53362 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbaBKR3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 12:29:30 -0500
Date: Tue, 11 Feb 2014 17:29:18 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 08/12] mfd: vexpress-sysreg: Add syscon labels as
 platform data
Message-ID: <20140211172918.GH15081@lee--X1>
References: <1392138636-29240-1-git-send-email-pawel.moll@arm.com>
 <1392138636-29240-9-git-send-email-pawel.moll@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392138636-29240-9-git-send-email-pawel.moll@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch adds label names for syscon registers as platform
> data for the relevant MFD cells.

Okay, I see.

Hmm... not sure I like this at all. It seems awfully as though you're
bending current infrastructure to suit your needs. There must be better
ways of passing a name than through pdata, and if there isn't I'd
suggest setting up a sysconf pdata struct that others can use in case
they wish to expand the functionality further in some other
unfathomable way. :)

> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> ---
>  drivers/mfd/vexpress-sysreg.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/mfd/vexpress-sysreg.c b/drivers/mfd/vexpress-sysreg.c
> index ece5ac8..57c21a0 100644
> --- a/drivers/mfd/vexpress-sysreg.c
> +++ b/drivers/mfd/vexpress-sysreg.c
> @@ -132,6 +132,8 @@ void __init vexpress_sysreg_early_init(void __iomem *base)
>  
>  /* The sysreg block is just a random collection of various functions... */
>  
> +static const char vexpress_sysreg_sys_id_pdata[] = "sys_id";
> +
>  static struct bgpio_pdata vexpress_sysreg_sys_led_pdata = {
>  	.label = "sys_led",
>  	.base = -1,
> @@ -150,6 +152,10 @@ static struct bgpio_pdata vexpress_sysreg_sys_flash_pdata = {
>  	.ngpio = 1,
>  };
>  
> +static const char vexpress_sysreg_sys_misc_pdata[] = "sys_misc";
> +
> +static const char vexpress_sysreg_sys_procid_pdata[] = "sys_procid";
> +
>  static struct mfd_cell vexpress_sysreg_cells[] = {
>  	{
>  		.name = "syscon",
> @@ -157,6 +163,8 @@ static struct mfd_cell vexpress_sysreg_cells[] = {
>  		.resources = (struct resource []) {
>  			DEFINE_RES_MEM(SYS_ID, 0x4),
>  		},
> +		.platform_data = &vexpress_sysreg_sys_id_pdata,
> +		.pdata_size = sizeof(vexpress_sysreg_sys_id_pdata),
>  	}, {
>  		.name = "basic-mmio-gpio",
>  		.of_compatible = "arm,vexpress-sysreg,sys_led",
> @@ -190,12 +198,16 @@ static struct mfd_cell vexpress_sysreg_cells[] = {
>  		.resources = (struct resource []) {
>  			DEFINE_RES_MEM(SYS_MISC, 0x4),
>  		},
> +		.platform_data = &vexpress_sysreg_sys_misc_pdata,
> +		.pdata_size = sizeof(vexpress_sysreg_sys_misc_pdata),
>  	}, {
>  		.name = "syscon",
>  		.num_resources = 1,
>  		.resources = (struct resource []) {
>  			DEFINE_RES_MEM(SYS_PROCID0, 0x8),
>  		},
> +		.platform_data = &vexpress_sysreg_sys_procid_pdata,
> +		.pdata_size = sizeof(vexpress_sysreg_sys_procid_pdata),
>  	}, {
>  		.name = "vexpress-syscfg",
>  		.num_resources = 1,

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
