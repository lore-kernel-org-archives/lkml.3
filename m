Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758742Ab3DDJdi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 05:33:38 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38879 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758701Ab3DDJdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 05:33:37 -0400
Message-ID: <515D48E5.1060700@ti.com>
Date: Thu, 4 Apr 2013 15:03:25 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Prabhakar lad <prabhakar.csengg@gmail.com>
CC: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 1/2] ARM: davinci: dm365: add support for v4l2 video
 display
References: <1364903681-13914-1-git-send-email-prabhakar.csengg@gmail.com> <1364903681-13914-2-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1364903681-13914-2-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/2/2013 5:24 PM, Prabhakar lad wrote:
> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> 
> Create platform devices for various video modules like venc,osd,
> vpbe and v4l2 driver for dm365.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Minor nits below:

> diff --git a/arch/arm/mach-davinci/dm365.c b/arch/arm/mach-davinci/dm365.c
> index c61dd94..786c860 100644
> --- a/arch/arm/mach-davinci/dm365.c
> +++ b/arch/arm/mach-davinci/dm365.c
> @@ -40,10 +40,14 @@
>  
>  #define DM365_REF_FREQ		24000000	/* 24 MHz on the DM365 EVM */
>  
> +#define DM365_RTC_BASE			0x01c69000
> +
>  /* Base of key scan register bank */
>  #define DM365_KEYSCAN_BASE		0x01c69400
>  
> -#define DM365_RTC_BASE			0x01c69000
> +#define DM365_OSD_BASE			0x01c71c00
> +
> +#define DM365_VENC_BASE			0x01c71e00
>  
>  #define DAVINCI_DM365_VC_BASE		0x01d0c000

No need of empty lines between these definitions. While at it you can
also remove the useless comment "/* Base of key scan register bank */"

> +static int dm365_vpbe_setup_pinmux(enum v4l2_mbus_pixelcode if_type,
> +			    int field)
> +{
> +	switch (if_type) {
> +	case V4L2_MBUS_FMT_SGRBG8_1X8:
> +		davinci_cfg_reg(DM365_VOUT_FIELD_G81);
> +		davinci_cfg_reg(DM365_VOUT_COUTL_EN);
> +		davinci_cfg_reg(DM365_VOUT_COUTH_EN);
> +		break;
> +

No need of these empty lines after 'break'. Here and other places below.

The patch looks good overall though so you can fix the nits and add:

Acked-by: Sekhar Nori <nsekhar@ti.com>

Thanks,
Sekhar
