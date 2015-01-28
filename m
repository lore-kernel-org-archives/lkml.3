Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbbA1Uyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:54:54 -0500
Received: from mail-qg0-f50.google.com ([209.85.192.50]:64167 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbbA1Uyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:54:50 -0500
Date: Wed, 28 Jan 2015 07:58:35 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, sboyd@codeaurora.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 4/4] clk: dt: st: Introduce clock domain documentation
Message-ID: <20150128075835.GF4567@x1>
References: <1422270840-3039-1-git-send-email-lee.jones@linaro.org>
 <1422270840-3039-5-git-send-email-lee.jones@linaro.org>
 <20150128011902.22722.85007@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20150128011902.22722.85007@quantum>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2015, Mike Turquette wrote:

> Quoting Lee Jones (2015-01-26 03:14:00)
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  .../devicetree/bindings/clock/st/st,clk-domain.txt | 34 ++++++++++++++++++++++
> >  1 file changed, 34 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/clock/st/st,clk-domain.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/clock/st/st,clk-domain.txt b/Documentation/devicetree/bindings/clock/st/st,clk-domain.txt
> > new file mode 100644
> > index 0000000..7309937
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/clock/st/st,clk-domain.txt
> > @@ -0,0 +1,34 @@
> > +STMicroelectronics Clock Domain
> > +
> > +ST hardware have a bunch of clocks which must not be turned off.
> > +If drivers a) fail to obtain a reference to any of these or b) give
> > +up a previously obtained reference during suspend, the common clk
> > +framework will attempt to turn them off and the hardware will
> > +subsequently die.  The only way to recover from this failure is to
> > +restart.
> > +
> > +To avoid either of these two scenarios from catastrophically
> > +disabling the running system we have implemented a clock domain
> > +where clocks are consumed and references are taken, thus preventing
> > +them from being shut down by the framework.
> > +
> > +We use the generic clock bindings found in:
> > +  Documentation/devicetree/bindings/clock/clock-bindings.txt
> > +
> > +Required properties:
> > +- compatible : Must be "st,clk-domain"
> 
> Seems like a useful feature for any clock provider, not just ST's. Have
> you thought about making this solution generic for DT-based clock
> providers?
> 
> We could amend the common clock binding to include a special "always on"
> clock group that is automagically prepared and enabled when the clock
> provider/driver is registered, using a common function.

OMG, I'm actually going to strangle you!

This is what I've been proposing to you (privately) for weeks.

Does this ring any bells?

  "Just FYI, I am not going to add any method to the kernel that
  permanently enables a clock via some new api. At the worst case your
  clock driver can simply call clk_prepare_enable in its probe
  function (there are some examples of this)."

I will be more than happy to make this a generic driver, if thats what
you want (now). ;)

> > +Example:
> > +
> > +clk-domain {
> > +       compatible = "st,clk-domain";
> > +       clocks = <&clk_s_c0_flexgen CLK_EXT2F_A9>,
> > +                <&clk_s_c0_flexgen CLK_COMPO_DVP>,
> > +                <&clk_s_c0_flexgen CLK_MMC_1>,
> > +                <&clk_s_c0_flexgen CLK_ICN_SBC>,
> > +                <&clk_s_c0_flexgen CLK_ICN_LMI>,
> > +                <&clk_s_c0_flexgen CLK_ICN_CPU>,
> > +                <&clk_s_c0_flexgen CLK_TX_ICN_DMU>,
> > +                <&clk_s_a0_flexgen CLK_IC_LMI0>,
> > +                <&clk_m_a9>;
> > +};

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
