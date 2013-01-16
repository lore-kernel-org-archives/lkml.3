Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572Ab3APHt0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 02:49:26 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:44350 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758221Ab3APHtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 02:49:24 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        kgene.kim@samsung.com, grant.likely@secretlab.ca,
        dianders@chromium.org, jg1.han@samsung.com
Subject: Re: [PATCH v4 3/4] ARM: Exynos5250: Add clock information for dwc3-exynos
Date: Wed, 16 Jan 2013 08:49:23 +0100
Message-ID: <3963234.Gb249i4a6U@flatron>
User-Agent: KMail/4.9.5 (Linux/3.7.2-gentoo; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1358257112-19595-4-git-send-email-gautam.vivek@samsung.com>
References: <1358257112-19595-1-git-send-email-gautam.vivek@samsung.com> <1358257112-19595-4-git-send-email-gautam.vivek@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

Don't you need also some clkdev lookup entry to make the clock available 
in the driver?

Best regards,
Tomasz

On Tuesday 15 of January 2013 19:08:31 Vivek Gautam wrote:
> Adding necessary device clock to exynos5 needed for
> the DWC3 controller.
> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
>  arch/arm/mach-exynos/clock-exynos5.c |   24 ++++++++++++++++++++++++
>  1 files changed, 24 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-exynos/clock-exynos5.c
> b/arch/arm/mach-exynos/clock-exynos5.c index 0208c3a..13af020 100644
> --- a/arch/arm/mach-exynos/clock-exynos5.c
> +++ b/arch/arm/mach-exynos/clock-exynos5.c
> @@ -757,6 +757,11 @@ static struct clk exynos5_init_clocks_off[] = {
>  		.enable		= exynos5_clk_ip_fsys_ctrl ,
>  		.ctrlbit	= (1 << 18),
>  	}, {
> +		.name		= "usbdrd30",
> +		.parent		= &exynos5_clk_aclk_200.clk,
> +		.enable		= exynos5_clk_ip_fsys_ctrl,
> +		.ctrlbit	= (1 << 19),
> +	}, {
>  		.name		= "usbotg",
>  		.enable		= exynos5_clk_ip_fsys_ctrl,
>  		.ctrlbit	= (1 << 7),
> @@ -1035,6 +1040,16 @@ static struct clksrc_sources exynos5_clkset_group
> = { .nr_sources	= ARRAY_SIZE(exynos5_clkset_group_list),
>  };
> 
> +struct clk *exynos5_clkset_usbdrd30_list[] = {
> +	[0] = &exynos5_clk_mout_mpll.clk,
> +	[1] = &exynos5_clk_mout_cpll.clk,
> +};
> +
> +struct clksrc_sources exynos5_clkset_usbdrd30 = {
> +	.sources        = exynos5_clkset_usbdrd30_list,
> +	.nr_sources     = ARRAY_SIZE(exynos5_clkset_usbdrd30_list),
> +};
> +
>  /* Possible clock sources for aclk_266_gscl_sub Mux */
>  static struct clk *clk_src_gscl_266_list[] = {
>  	[0] = &clk_ext_xtal_mux,
> @@ -1329,6 +1344,15 @@ static struct clksrc_clk exynos5_clksrcs[] = {
>  			.parent		= &exynos5_clk_mout_cpll.clk,
>  		},
>  		.reg_div = { .reg = EXYNOS5_CLKDIV_GEN, .shift = 4, .size = 3 
},
> +	}, {
> +		.clk    = {
> +			.name           = "sclk_usbdrd30",
> +			.enable         = exynos5_clksrc_mask_fsys_ctrl,
> +			.ctrlbit        = (1 << 28),
> +		},
> +		.sources = &exynos5_clkset_usbdrd30,
> +		.reg_src = { .reg = EXYNOS5_CLKSRC_FSYS, .shift = 28, .size = 
1 },
> +		.reg_div = { .reg = EXYNOS5_CLKDIV_FSYS0, .shift = 24, .size = 
4 },
>  	},
>  };
