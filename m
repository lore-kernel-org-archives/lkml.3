Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284AbaDIHLN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 03:11:13 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:65296 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbaDIHLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 03:11:10 -0400
Date: Wed, 9 Apr 2014 00:11:05 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, linux-mtd@lists.infradead.org, angus.clark@st.com,
        Christophe Kerello <christophe.kerello@st.com>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 14/15] mtd: st_spi_fsm: Provide mask to obtain correct
 boot device pins
Message-ID: <20140409071105.GE3131@norris-Latitude-E6410>
References: <1395851969-13520-1-git-send-email-lee.jones@linaro.org>
 <1395851969-13520-15-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395851969-13520-15-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ DT list

On Wed, Mar 26, 2014 at 04:39:28PM +0000, Lee Jones wrote:
> From: Christophe Kerello <christophe.kerello@st.com>
> 
> This patch adds a mask to be able to get the right boot device selection.
> 
> For example:
>     for STiH415, value = SYSTEM_STATUS398[4:0]
>     for STiH416, value = SYSTEM_STATUS2598[4:0]
>     for STiH407, value = SYSTEM_STATUS5561[6:2]
> 
> Signed-off-by: Christophe Kerello <christophe.kerello@st.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mtd/devices/st_spi_fsm.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
> index 9e00173..3ab27c8 100644
> --- a/drivers/mtd/devices/st_spi_fsm.c
> +++ b/drivers/mtd/devices/st_spi_fsm.c
> @@ -2159,6 +2159,7 @@ static void stfsm_fetch_platform_configs(struct platform_device *pdev)
>  	struct regmap *regmap;
>  	uint32_t boot_device_reg;
>  	uint32_t boot_device_spi;
> +	uint32_t boot_device_msk;
>  	uint32_t boot_device;     /* Value we read from *boot_device_reg */
>  	int ret;
>  
> @@ -2183,10 +2184,17 @@ static void stfsm_fetch_platform_configs(struct platform_device *pdev)
>  	if (ret)
>  		goto boot_device_fail;
>  
> +	/* Mask to apply on boot_device_reg */
> +	ret = of_property_read_u32(np, "st,boot-device-msk", &boot_device_msk);

You need to document this binding in Documentation/devicetree/bindings/,
and CC the devicetree list.

> +	if (ret)
> +		goto boot_device_fail;
> +
>  	ret = regmap_read(regmap, boot_device_reg, &boot_device);
>  	if (ret)
>  		goto boot_device_fail;
>  
> +	boot_device &= boot_device_msk;
> +
>  	if (boot_device != boot_device_spi)
>  		fsm->booted_from_spi = false;
>  

Brian
