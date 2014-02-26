Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbaBZU4a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 15:56:30 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:42827 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbaBZU42 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 15:56:28 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Roger Quadros <rogerq@ti.com>, tony@atomide.com, bcousson@baylibre.com,
        lee.jones@linaro.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <530C6323.90205@ti.com>
Cc: balbi@ti.com, nm@ti.com, khilman@linaro.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-usb@vger.kernel.org,
        "Tero Kristo" <t-kristo@ti.com>
References: <1392896409-5101-1-git-send-email-rogerq@ti.com>
 <1392896409-5101-7-git-send-email-rogerq@ti.com>
 <20140225084327.22529.86075@quantum> <530C6323.90205@ti.com>
Message-ID: <20140226205624.12081.67770@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v8 06/14] CLK: TI: OMAP3: Get rid of unused USB Host dummy clocks
Date: Wed, 26 Feb 2014 12:56:24 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Roger Quadros (2014-02-25 01:32:19)
> Hi Mike,
> 
> On 02/25/2014 10:43 AM, Mike Turquette wrote:
> > Quoting Roger Quadros (2014-02-20 03:40:01)
> >> The OMAP USB Host MFD driver no longer expects these non-existing
> >> clocks from the OMAP3 platform, so get rid of them.
> > 
> > Looks good to me.
> 
> Is it OK if I squash this patch with [1] and take it through the MFD tree?
> Keeping them separate could break functionality if both don't go in together.

Acked-by: Mike Turquette <mturquette@linaro.org>

> 
> [1] - http://article.gmane.org/gmane.linux.ports.arm.kernel/303266
> 
> cheers,
> -roger
> 
> > 
> >>
> >> CC: Tero Kristo <t-kristo@ti.com>
> >> CC: Mike Turquette <mturquette@linaro.org>
> >> Signed-off-by: Roger Quadros <rogerq@ti.com>
> >> ---
> >>  arch/arm/mach-omap2/cclock3xxx_data.c | 4 ----
> >>  drivers/clk/ti/clk-3xxx.c             | 4 ----
> >>  2 files changed, 8 deletions(-)
> >>
> >> diff --git a/arch/arm/mach-omap2/cclock3xxx_data.c b/arch/arm/mach-omap2/cclock3xxx_data.c
> >> index 3b05aea..4299a55 100644
> >> --- a/arch/arm/mach-omap2/cclock3xxx_data.c
> >> +++ b/arch/arm/mach-omap2/cclock3xxx_data.c
> >> @@ -3495,10 +3495,6 @@ static struct omap_clk omap3xxx_clks[] = {
> >>         CLK(NULL,       "dss_tv_fck",   &dss_tv_fck),
> >>         CLK(NULL,       "dss_96m_fck",  &dss_96m_fck),
> >>         CLK(NULL,       "dss2_alwon_fck",       &dss2_alwon_fck),
> >> -       CLK(NULL,       "utmi_p1_gfclk",        &dummy_ck),
> >> -       CLK(NULL,       "utmi_p2_gfclk",        &dummy_ck),
> >> -       CLK(NULL,       "xclk60mhsp1_ck",       &dummy_ck),
> >> -       CLK(NULL,       "xclk60mhsp2_ck",       &dummy_ck),
> >>         CLK(NULL,       "init_60m_fclk",        &dummy_ck),
> >>         CLK(NULL,       "gpt1_fck",     &gpt1_fck),
> >>         CLK(NULL,       "aes2_ick",     &aes2_ick),
> >> diff --git a/drivers/clk/ti/clk-3xxx.c b/drivers/clk/ti/clk-3xxx.c
> >> index d323023..0d1750a 100644
> >> --- a/drivers/clk/ti/clk-3xxx.c
> >> +++ b/drivers/clk/ti/clk-3xxx.c
> >> @@ -130,10 +130,6 @@ static struct ti_dt_clk omap3xxx_clks[] = {
> >>         DT_CLK(NULL, "dss_tv_fck", "dss_tv_fck"),
> >>         DT_CLK(NULL, "dss_96m_fck", "dss_96m_fck"),
> >>         DT_CLK(NULL, "dss2_alwon_fck", "dss2_alwon_fck"),
> >> -       DT_CLK(NULL, "utmi_p1_gfclk", "dummy_ck"),
> >> -       DT_CLK(NULL, "utmi_p2_gfclk", "dummy_ck"),
> >> -       DT_CLK(NULL, "xclk60mhsp1_ck", "dummy_ck"),
> >> -       DT_CLK(NULL, "xclk60mhsp2_ck", "dummy_ck"),
> >>         DT_CLK(NULL, "init_60m_fclk", "dummy_ck"),
> >>         DT_CLK(NULL, "gpt1_fck", "gpt1_fck"),
> >>         DT_CLK(NULL, "aes2_ick", "aes2_ick"),
> >> -- 
> >> 1.8.3.2
> >>
> 
