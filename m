Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab3JZNCc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 09:02:32 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:50718 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab3JZNCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 09:02:30 -0400
Date: Sat, 26 Oct 2013 09:02:25 -0400
From: Matt Porter <matt.porter@linaro.org>
To: Grant Likely <grant.likely@linaro.org>
Cc: Xiubo Li <Li.Xiubo@freescale.com>, r65073@freescale.com,
        thierry.reding@gmail.com, mark.rutland@arm.com,
        linux-pwm@vger.kernel.org, linux@arm.linux.org.uk,
        ian.campbell@citrix.com, pawel.moll@arm.com, swarren@wwwdotorg.org,
        s.hauer@pengutronix.de, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        devicetree@vger.kernel.org, rob@landley.net, t.figa@samsung.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv5 4/4] Documentation: Add device tree bindings for
 Freescale FTM PWM.
Message-ID: <20131026130225.GJ29341@beef>
References: <1380521611-2764-1-git-send-email-Li.Xiubo@freescale.com>
 <1380521611-2764-5-git-send-email-Li.Xiubo@freescale.com>
 <20131025201211.7936EC405D3@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131025201211.7936EC405D3@trevor.secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 09:12:11PM +0100, Grant Likely wrote:
> On Mon, 30 Sep 2013 14:13:31 +0800, Xiubo Li <Li.Xiubo@freescale.com> wrote:
> > This adds the Document for Freescale FTM PWM driver under
> > Documentation/devicetree/bindings/pwm/.
> > 
> > Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> > ---
> >  .../devicetree/bindings/pwm/pwm-fsl-ftm.txt        | 33 ++++++++++++++++++++++
> >  1 file changed, 33 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt b/Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt
> > new file mode 100644
> > index 0000000..2c6969a
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/pwm/pwm-fsl-ftm.txt
> > @@ -0,0 +1,33 @@
> > +Freescale FTM PWM controller
> > +
> > +Required properties:
> > +- compatible: Should be "fsl,vf610-ftm-pwm"
> > +- reg: Physical base address and length of the controller's registers
> > +- #pwm-cells: Should be 3. See pwm.txt in this directory for a description of
> > +  the cells format.
> > +- clock-names : Includes the following module clock source entries:
> > +    "ftm0" (system clock),
> > +    "ftm0_fix_sel" (fixed frequency clock),
> > +    "ftm0_ext_sel" (external clock)
> > +- clocks : Must contain a clock specifier for each entry in clock-names.
> > +- fsl,pwm-counter-clk: The FTM PWM counter clock source, should be one of the
> > +  entries in clock-names.
> > +- pinctrl-names: must contain a "default" entry.
> > +- pinctrl-NNN: One property must exist for each entry in pinctrl-names.
> > +  See ../pinctrl/pinctrl-bindings.txt for details of the property values.
> 
> Looks okay to me.

For consistency, shouldn't it also have:

"See ../clock/clock-bindings.txt for details of the property values"

where appropriate like is done under the pwm/pinctrl uses?

IMHO, referencing parent bindings all of the time should be a documented
best practice / requirement.

-Matt

> > +
> > +
> > +Example:
> > +
> > +pwm0: pwm@40038000 {
> > +		compatible = "fsl,vf610-ftm-pwm";
> > +		reg = <0x40038000 0x1000>;
> > +		#pwm-cells = <3>;
> > +		clock-names = "ftm0", "ftm0_fix_sel", "ftm0_ext_sel";
> > +		clocks = <&clks VF610_CLK_FTM0>,
> > +			<&clks VF610_CLK_FTM0_FIX_SEL>,
> > +			<&clks VF610_CLK_FTM0_EXT_SEL>;
> > +		pinctrl-names = "default";
> > +		pinctrl-0 = <&pinctrl_pwm0_1>;
> > +		fsl,pwm-counter-clk = "ftm0_ext_sel";
> > +};
> > -- 
> > 1.8.0
> > 
> > 
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
