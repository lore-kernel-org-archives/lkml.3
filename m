Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab3JQMPC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 08:15:02 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:46052 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638Ab3JQMO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 08:14:58 -0400
Date: Thu, 17 Oct 2013 08:14:54 -0400
From: Matt Porter <matt.porter@linaro.org>
To: Christian Daudt <bcm@fixthebug.org>
Cc: Tim Kryger <tim.kryger@linaro.org>, Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Wolfram Sang <wsa@the-dreams.de>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        linux-i2c@vger.kernel.org, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RESEND PATCH 3/4] ARM: dts: bcm281xx: Add i2c busses
Message-ID: <20131017121454.GZ2721@beef>
References: <1381960909-1735-1-git-send-email-tim.kryger@linaro.org>
 <1381960909-1735-4-git-send-email-tim.kryger@linaro.org>
 <CAEPRUYqqxLevwM6dRpGUnfCgF2qZ_NVTDYTzKoFg+zbOPggfMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEPRUYqqxLevwM6dRpGUnfCgF2qZ_NVTDYTzKoFg+zbOPggfMQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 09:32:51PM -0700, Christian Daudt wrote:
> Hi Tim,
>  This patch does not work as it relies on the yet-unmerged clock code
> for bcm11351. This patch does not apply to -rc, and when tweaked it
> does not compile as it references  non-existent bsc_clks.
>  Has the clk patches been submitted yet ? Applying this will have to
> wait until those have been accepted.

Hi Christian, Tim mentioned the dependencies in the cover letter.
Sebastian's series, for which the pull request is already sent, and then
Tim's own fixed clock series that is pending some review.

-Matt

> On Wed, Oct 16, 2013 at 3:01 PM, Tim Kryger <tim.kryger@linaro.org> wrote:
> > Add the DTS nodes for all the i2c busses in the SoC.
> >
> > Signed-off-by: Tim Kryger <tim.kryger@linaro.org>
> > Reviewed-by: Christian Daudt <csd@broadcom.com>
> > Reviewed-by: Matt Porter <matt.porter@linaro.org>
> > Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
> > ---
> >  arch/arm/boot/dts/bcm11351.dtsi | 40 ++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 40 insertions(+)
> >
> > diff --git a/arch/arm/boot/dts/bcm11351.dtsi b/arch/arm/boot/dts/bcm11351.dtsi
> > index 1246885..4bfd7e3 100644
> > --- a/arch/arm/boot/dts/bcm11351.dtsi
> > +++ b/arch/arm/boot/dts/bcm11351.dtsi
> > @@ -146,6 +146,46 @@
> >                 status = "disabled";
> >         };
> >
> > +       i2c@3e016000 {
> > +               compatible = "brcm,bcm11351-i2c", "brcm,kona-i2c";
> > +               reg = <0x3e016000 0x80>;
> > +               interrupts = <GIC_SPI 103 IRQ_TYPE_LEVEL_HIGH>;
> > +               #address-cells = <1>;
> > +               #size-cells = <0>;
> > +               clocks = <&bsc1_clk>;
> > +               status = "disabled";
> > +       };
> > +
> > +       i2c@3e017000 {
> > +               compatible = "brcm,bcm11351-i2c", "brcm,kona-i2c";
> > +               reg = <0x3e017000 0x80>;
> > +               interrupts = <GIC_SPI 102 IRQ_TYPE_LEVEL_HIGH>;
> > +               #address-cells = <1>;
> > +               #size-cells = <0>;
> > +               clocks = <&bsc2_clk>;
> > +               status = "disabled";
> > +       };
> > +
> > +       i2c@3e018000 {
> > +               compatible = "brcm,bcm11351-i2c", "brcm,kona-i2c";
> > +               reg = <0x3e018000 0x80>;
> > +               interrupts = <GIC_SPI 169 IRQ_TYPE_LEVEL_HIGH>;
> > +               #address-cells = <1>;
> > +               #size-cells = <0>;
> > +               clocks = <&bsc3_clk>;
> > +               status = "disabled";
> > +       };
> > +
> > +       i2c@3500d000 {
> > +               compatible = "brcm,bcm11351-i2c", "brcm,kona-i2c";
> > +               reg = <0x3500d000 0x80>;
> > +               interrupts = <GIC_SPI 14 IRQ_TYPE_LEVEL_HIGH>;
> > +               #address-cells = <1>;
> > +               #size-cells = <0>;
> > +               clocks = <&pmu_bsc_clk>;
> > +               status = "disabled";
> > +       };
> > +
> >         clocks {
> >                 bsc1_clk: bsc1 {
> >                         compatible = "fixed-clock";
> > --
> > 1.8.0.1
> >
> >
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
