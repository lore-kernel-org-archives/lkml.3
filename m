Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbaCGQz0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 11:55:26 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:38158 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751840AbaCGQzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 11:55:23 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19FJRdEPLj6q2NRVH1tHKX0
Date: Fri, 7 Mar 2014 08:55:14 -0800
From: Tony Lindgren <tony@atomide.com>
To: Tero Kristo <t-kristo@ti.com>
Cc: Roger Quadros <rogerq@ti.com>, balbi@ti.com, kishon@ti.com,
        george.cherian@ti.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-usb@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH 1/8] CLK: ti: dra7: Initialize USB_DPLL
Message-ID: <20140307165513.GD3789@atomide.com>
References: <1394197751-28984-1-git-send-email-rogerq@ti.com>
 <1394197751-28984-2-git-send-email-rogerq@ti.com>
 <5319CCF2.8090902@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5319CCF2.8090902@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tero Kristo <t-kristo@ti.com> [140307 05:46]:
> On 03/07/2014 03:09 PM, Roger Quadros wrote:
> >USB_DPLL must be initialized and locked at boot so that
> >USB modules can work.
> >
> >Also program USB_DLL_M2 output to half rate.
> >
> >CC: Mike Turquette <mturquette@linaro.org>
> >CC: Tero Kristo <t-kristo@ti.com>
> >Signed-off-by: Roger Quadros <rogerq@ti.com>
> >---
> >  drivers/clk/ti/clk-7xx.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> >
> >diff --git a/drivers/clk/ti/clk-7xx.c b/drivers/clk/ti/clk-7xx.c
> >index 9977653..f89f3c2 100644
> >--- a/drivers/clk/ti/clk-7xx.c
> >+++ b/drivers/clk/ti/clk-7xx.c
> >@@ -18,6 +18,7 @@
> >
> >  #define DRA7_DPLL_ABE_DEFFREQ				361267200
> >  #define DRA7_DPLL_GMAC_DEFFREQ				1000000000
> >+#define DRA7_DPLL_USB_DEFFREQ				960000000
> >
> >
> >  static struct ti_dt_clk dra7xx_clks[] = {
> >@@ -328,5 +329,15 @@ int __init dra7xx_dt_clk_init(void)
> >  	if (rc)
> >  		pr_err("%s: failed to configure GMAC DPLL!\n", __func__);
> >
> >+	dpll_ck = clk_get_sys(NULL, "dpll_usb_ck");
> >+	rc = clk_set_rate(dpll_ck, DRA7_DPLL_USB_DEFFREQ);
> >+	if (rc)
> >+		pr_err("%s: failed to configure USB DPLL!\n", __func__);
> >+
> >+	dpll_ck = clk_get_sys(NULL, "dpll_usb_m2_ck");
> >+	rc = clk_set_rate(dpll_ck, DRA7_DPLL_USB_DEFFREQ/2);
> >+	if (rc)
> >+		pr_err("%s: failed to set USB_DPLL M2 OUT\n", __func__);
> >+
> 
> I would rather see this done using the default-rate mechanism provided here:
> 
> https://www.mail-archive.com/linux-omap@vger.kernel.org/msg101300.html
> 
> However, this remains to be commented by Mike whether the patch is
> okay or not.

Yes let's wait for that and not add hacks for new features.

Regards,

Tony
