Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464AbaCLNqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 09:46:42 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:53326 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753722AbaCLNqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 09:46:40 -0400
Date: Wed, 12 Mar 2014 09:46:34 -0400
From: Matt Porter <mporter@linaro.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Christian Daudt <bcm@fixthebug.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 1/5] mfd: add bcm590xx pmu DT binding
Message-ID: <20140312134634.GR25092@beef>
References: <1394580837-8331-1-git-send-email-mporter@linaro.org>
 <1394580837-8331-2-git-send-email-mporter@linaro.org>
 <20140312133339.GC17461@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140312133339.GC17461@e106331-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 01:33:39PM +0000, Mark Rutland wrote:
> On Tue, Mar 11, 2014 at 11:33:53PM +0000, Matt Porter wrote:
> > Add a DT binding for the BCM590xx PMUs. The binding inherits from
> > the generic regulator bindings.
> > 
> > Signed-off-by: Matt Porter <mporter@linaro.org>
> > Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
> > Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
> > ---
> >  Documentation/devicetree/bindings/mfd/bcm590xx.txt | 41 ++++++++++++++++++++++
> >  1 file changed, 41 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/mfd/bcm590xx.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/mfd/bcm590xx.txt b/Documentation/devicetree/bindings/mfd/bcm590xx.txt
> > new file mode 100644
> > index 0000000..2300246
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/mfd/bcm590xx.txt
> > @@ -0,0 +1,41 @@
> > +-------------------------------
> > +BCM590xx Power Management Units
> > +-------------------------------
> > +
> > +Required properties:
> > +- compatible: "brcm,bcm59056"
> > +- reg: I2C slave address
> > +- interrupts: interrupt for the PMU. Generic interrupt client node bindings
> > +  are described in interrupt-controller/interrupts.txt
> 
> This all looks sane.
> 
> > +
> > +------------------
> > +Voltage Regulators
> > +------------------
> > +
> > +Optional properties:
> > +- regulators: This is the list of child nodes that specify the regulator
> > +  initialization data for defined regulators.  Generic regulator bindings
> > +  are described in regulator/regulator.txt.
> 
> This is a subnode, not a property. How about:
> 
> Optional child nodes:
> 
> - regulators: container node for regulators follwoing the generic
>   regulator binding in regulator/regulator.txt.

Agreed, I'll reword like that...makes more sense like that.

> > +
> > +  The valid regulator nodes for BCM59056 are:
> 
> s/nodes/node names/

Ok

> > +  	rfldo, camldo1, camldo2, simldo1, simldo2, sdldo, sdxldo,
> > +	mmcldo1, mmcldo2, audldo, micldo, usbldo, vibldo,
> > +	csr, iosr1, iosr2, msr, sdsr1, sdsr2, vsr
> > +
> > +Example:
> > +	pmu: bcm59056@8 {
> > +		compatible = "brcm,bcm59056";
> > +		reg = <0x08>;
> > +		interrupts = <GIC_SPI 215 IRQ_TYPE_LEVEL_HIGH>;
> > +		regulators {
> > +			#address-cells = <1>;
> > +			#size-cells = <0>;
> > +
> > +			rfldo_reg: rfldo {
> > +				regulator-min-microvolt = <1200000>;
> > +				regulator-max-microvolt = <3300000>;
> 
> Are any specific properties required on these children?

None. The only requirement is that when regulator node exists, the
node names must match those listed.

I'll send out another version with rewording suggested above.

Thanks,
Matt
