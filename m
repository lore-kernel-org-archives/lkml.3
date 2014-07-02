Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344AbaGBLYN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 07:24:13 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33588 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaGBLYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 07:24:12 -0400
Message-ID: <53B3EBD6.1090709@ti.com>
Date: Wed, 2 Jul 2014 14:24:06 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: <paul@pwsan.com>, <rnayak@ti.com>
CC: <tony@atomide.com>, <nm@ti.com>, <kishon@ti.com>, <george.cherian@ti.com>,
        <balbi@ti.com>, <balajitk@ti.com>, <nsekhar@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ARM: DRA7: hwmod: Fixup SATA hwmod
References: <1403093816-10960-1-git-send-email-rogerq@ti.com> <1403093816-10960-3-git-send-email-rogerq@ti.com>
In-Reply-To: <1403093816-10960-3-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rajendra,

On 06/18/2014 03:16 PM, Roger Quadros wrote:
> Get rid of optional clock as that is now managed by the
> AHCI platform driver.
> 
> Correct .mpu_rt_idx to 1 as the module register space (SYSCONFIG..)
> is passed as the second memory resource in the device tree.
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> Tested-by: Roger Quadros <rogerq@ti.com>

Need your Ack for this one as well. Thanks.

cheers,
-roger

> ---
>  arch/arm/mach-omap2/omap_hwmod_7xx_data.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
> index cedef6b..bc42eab 100644
> --- a/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
> +++ b/arch/arm/mach-omap2/omap_hwmod_7xx_data.c
> @@ -1292,9 +1292,6 @@ static struct omap_hwmod_class dra7xx_sata_hwmod_class = {
>  };
>  
>  /* sata */
> -static struct omap_hwmod_opt_clk sata_opt_clks[] = {
> -	{ .role = "ref_clk", .clk = "sata_ref_clk" },
> -};
>  
>  static struct omap_hwmod dra7xx_sata_hwmod = {
>  	.name		= "sata",
> @@ -1302,6 +1299,7 @@ static struct omap_hwmod dra7xx_sata_hwmod = {
>  	.clkdm_name	= "l3init_clkdm",
>  	.flags		= HWMOD_SWSUP_SIDLE | HWMOD_SWSUP_MSTANDBY,
>  	.main_clk	= "func_48m_fclk",
> +	.mpu_rt_idx	= 1,
>  	.prcm = {
>  		.omap4 = {
>  			.clkctrl_offs = DRA7XX_CM_L3INIT_SATA_CLKCTRL_OFFSET,
> @@ -1309,8 +1307,6 @@ static struct omap_hwmod dra7xx_sata_hwmod = {
>  			.modulemode   = MODULEMODE_SWCTRL,
>  		},
>  	},
> -	.opt_clks	= sata_opt_clks,
> -	.opt_clks_cnt	= ARRAY_SIZE(sata_opt_clks),
>  };
>  
>  /*
> 

