Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbaJFQWE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 12:22:04 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:41858 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289AbaJFQWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 12:22:01 -0400
Date: Mon, 6 Oct 2014 11:21:51 -0500
From: Nishanth Menon <nm@ti.com>
To: Masanari Iida <standby24x7@gmail.com>
CC: <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] ARM: OMAP2: Remove unnecessary KERN_* in
 omap_phy_internal.c
Message-ID: <20141006162151.GA21908@kahuna>
References: <1412612181-23774-1-git-send-email-standby24x7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1412612181-23774-1-git-send-email-standby24x7@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01:16-20141007, Masanari Iida wrote:
> This patch remove unnecessary KERN_INFO and KERN_ERR from omap_phy_internal.c.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  arch/arm/mach-omap2/omap_phy_internal.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/omap_phy_internal.c b/arch/arm/mach-omap2/omap_phy_internal.c
> index 50640b3..f4d942a 100644
> --- a/arch/arm/mach-omap2/omap_phy_internal.c
> +++ b/arch/arm/mach-omap2/omap_phy_internal.c

With the cleanups, maybe add a
#define pr_fmt(fmt) "%s: " fmt, __func__
at the start to make the log info a little more relevant?

> @@ -97,13 +97,13 @@ void am35x_musb_phy_power(u8 on)
>  
>  		omap_ctrl_writel(devconf2, AM35XX_CONTROL_DEVCONF2);
>  
> -		pr_info(KERN_INFO "Waiting for PHY clock good...\n");
> +		pr_info("Waiting for PHY clock good...\n");
>  		while (!(omap_ctrl_readl(AM35XX_CONTROL_DEVCONF2)
>  				& CONF2_PHYCLKGD)) {
>  			cpu_relax();
>  
>  			if (time_after(jiffies, timeout)) {
> -				pr_err(KERN_ERR "musb PHY clock good timed out\n");
> +				pr_err("musb PHY clock good timed out\n");
>  				break;
>  			}
>  		}
> @@ -145,7 +145,7 @@ void am35x_set_mode(u8 musb_mode)
>  		devconf2 |= CONF2_NO_OVERRIDE;
>  		break;
>  	default:
> -		pr_info(KERN_INFO "Unsupported mode %u\n", musb_mode);
> +		pr_info("Unsupported mode %u\n", musb_mode);
>  	}
>  
>  	omap_ctrl_writel(devconf2, AM35XX_CONTROL_DEVCONF2);
> -- 
> 2.1.1.273.g97b8860
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Regards,
Nishanth Menon
