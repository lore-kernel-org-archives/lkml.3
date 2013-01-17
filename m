Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513Ab3AQRDh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 12:03:37 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:10541 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752708Ab3AQRDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 12:03:36 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+8w6AzVf27pafHOgQq6IfJ
Date: Thu, 17 Jan 2013 09:03:22 -0800
From: Tony Lindgren <tony@atomide.com>
To: Roger Quadros <rogerq@ti.com>
Cc: balbi@ti.com, sameo@linux.intel.com, kishon@ti.com, sshtylyov@mvista.com,
        bjorn@mork.no, linux@arm.linux.org.uk, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Paul Walmsley <paul@pwsan.com>, Rajendra Nayak <rnayak@ti.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Mike Turquette <mturquette@linaro.com>
Subject: Re: [PATCH v7 19/22] ARM: OMAP3: clock data: get rid of unused USB
 host clock aliases and dummies
Message-ID: <20130117170321.GJ14149@atomide.com>
References: <1358422231-24736-1-git-send-email-rogerq@ti.com>
 <1358422231-24736-20-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358422231-24736-20-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Roger Quadros <rogerq@ti.com> [130117 03:34]:
> We don't need multiple aliases for the OMAP USB host clocks and neither
> the dummy clocks so remove them.

It's best that Paul queues this and the next patch as these clock alias
clean-up patches can be done separately. That way the dependency between
arch/arm/*omap* code is cut away as these files should be moved to live
under drivers/clk/omap.

Regards,

Tony
 
> CC: Paul Walmsley <paul@pwsan.com>
> CC: Rajendra Nayak <rnayak@ti.com>
> CC: Benoit Cousson <b-cousson@ti.com>
> CC: Mike Turquette <mturquette@linaro.com>
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> Acked-by: Paul Walmsley <paul@pwsan.com>
> ---
>  arch/arm/mach-omap2/cclock3xxx_data.c |   11 -----------
>  1 files changed, 0 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/cclock3xxx_data.c b/arch/arm/mach-omap2/cclock3xxx_data.c
> index 6ef8758..b58ec96 100644
> --- a/arch/arm/mach-omap2/cclock3xxx_data.c
> +++ b/arch/arm/mach-omap2/cclock3xxx_data.c
> @@ -3291,8 +3291,6 @@ static struct omap_clk omap3xxx_clks[] = {
>  	CLK(NULL,	"cpefuse_fck",	&cpefuse_fck,	CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
>  	CLK(NULL,	"ts_fck",	&ts_fck,	CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
>  	CLK(NULL,	"usbtll_fck",	&usbtll_fck,	CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
> -	CLK("usbhs_omap",	"usbtll_fck",	&usbtll_fck,	CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
> -	CLK("usbhs_tll",	"usbtll_fck",	&usbtll_fck,	CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
>  	CLK(NULL,	"core_96m_fck",	&core_96m_fck,	CK_3XXX),
>  	CLK(NULL,	"mmchs3_fck",	&mmchs3_fck,	CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
>  	CLK(NULL,	"mmchs2_fck",	&mmchs2_fck,	CK_3XXX),
> @@ -3329,8 +3327,6 @@ static struct omap_clk omap3xxx_clks[] = {
>  	CLK(NULL,	"pka_ick",	&pka_ick,	CK_34XX | CK_36XX),
>  	CLK(NULL,	"core_l4_ick",	&core_l4_ick,	CK_3XXX),
>  	CLK(NULL,	"usbtll_ick",	&usbtll_ick,	CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
> -	CLK("usbhs_omap",	"usbtll_ick",	&usbtll_ick,	CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
> -	CLK("usbhs_tll",	"usbtll_ick",	&usbtll_ick,	CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
>  	CLK("omap_hsmmc.2",	"ick",	&mmchs3_ick,	CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
>  	CLK(NULL,	"mmchs3_ick",	&mmchs3_ick,	CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
>  	CLK(NULL,	"icr_ick",	&icr_ick,	CK_34XX | CK_36XX),
> @@ -3393,17 +3389,10 @@ static struct omap_clk omap3xxx_clks[] = {
>  	CLK(NULL,	"usbhost_120m_fck", &usbhost_120m_fck, CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
>  	CLK(NULL,	"usbhost_48m_fck", &usbhost_48m_fck, CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
>  	CLK(NULL,	"usbhost_ick",	&usbhost_ick,	CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
> -	CLK("usbhs_omap",	"usbhost_ick",	&usbhost_ick,	CK_3430ES2PLUS | CK_AM35XX | CK_36XX),
>  	CLK(NULL,	"utmi_p1_gfclk",	&dummy_ck,	CK_3XXX),
>  	CLK(NULL,	"utmi_p2_gfclk",	&dummy_ck,	CK_3XXX),
>  	CLK(NULL,	"xclk60mhsp1_ck",	&dummy_ck,	CK_3XXX),
>  	CLK(NULL,	"xclk60mhsp2_ck",	&dummy_ck,	CK_3XXX),
> -	CLK(NULL,	"usb_host_hs_utmi_p1_clk",	&dummy_ck,	CK_3XXX),
> -	CLK(NULL,	"usb_host_hs_utmi_p2_clk",	&dummy_ck,	CK_3XXX),
> -	CLK("usbhs_omap",	"usb_tll_hs_usb_ch0_clk",	&dummy_ck,	CK_3XXX),
> -	CLK("usbhs_omap",	"usb_tll_hs_usb_ch1_clk",	&dummy_ck,	CK_3XXX),
> -	CLK("usbhs_tll",	"usb_tll_hs_usb_ch0_clk",	&dummy_ck,	CK_3XXX),
> -	CLK("usbhs_tll",	"usb_tll_hs_usb_ch1_clk",	&dummy_ck,	CK_3XXX),
>  	CLK(NULL,	"init_60m_fclk",	&dummy_ck,	CK_3XXX),
>  	CLK(NULL,	"usim_fck",	&usim_fck,	CK_3430ES2PLUS | CK_36XX),
>  	CLK(NULL,	"gpt1_fck",	&gpt1_fck,	CK_3XXX),
> -- 
> 1.7.4.1
> 
