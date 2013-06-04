Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab3FDF2u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 01:28:50 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33497 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117Ab3FDF2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 01:28:47 -0400
From: "J, KEERTHY" <j-keerthy@ti.com>
To: Lee Jones <lee.jones@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "wim@iguana.be" <wim@iguana.be>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "Kristo, Tero" <t-kristo@ti.com>, Ian Lartey <ian@slimlogic.co.uk>
Subject: RE: [PATCH] mfd: DT bindings for the palmas family MFD
Thread-Topic: [PATCH] mfd: DT bindings for the palmas family MFD
Thread-Index: AQHOYFQdmRK78L3sG0+rK4Xnj9z9npkjg8WAgAF20vA=
Date: Tue, 4 Jun 2013 05:28:08 +0000
Message-ID: <DC88CAD03C0052499C1907B327FC63229E8A6D@DBDE04.ent.ti.com>
References: <1370261333-5121-1-git-send-email-j-keerthy@ti.com>
 <20130603141851.GG3370@gmail.com>
In-Reply-To: <20130603141851.GG3370@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r545Sva3013479

Hello Lee Jones,

Thanks for the quick review.

> -----Original Message-----
> From: Lee Jones [mailto:lee.jones@linaro.org]
> Sent: Monday, June 03, 2013 7:49 PM
> To: J, KEERTHY
> Cc: linux-kernel@vger.kernel.org; linux-doc@vger.kernel.org;
> devicetree-discuss@lists.ozlabs.org; swarren@wwwdotorg.org;
> broonie@opensource.wolfsonmicro.com; rob.herring@calxeda.com;
> rob@landley.net; mturquette@linaro.org; sameo@linux.intel.com;
> wim@iguana.be; lgirdwood@gmail.com; gg@slimlogic.co.uk; Kristo, Tero;
> Ian Lartey
> Subject: Re: [PATCH] mfd: DT bindings for the palmas family MFD
> 
> On Mon, 03 Jun 2013, J Keerthy wrote:
> 
> > From: Graeme Gregory <gg@slimlogic.co.uk>
> >
> > Add the various binding files for the palmas family of chips. There
> is
> > a top level MFD binding then a seperate binding for regulators IP
> blocks on chips.
> >
> > Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
> > Signed-off-by: J Keerthy <j-keerthy@ti.com>
> > Signed-off-by: Ian Lartey <ian@slimlogic.co.uk>
> > ---
> >  Documentation/devicetree/bindings/mfd/palmas.txt   |   49 ++++++
> >  .../devicetree/bindings/regulator/palmas-pmic.txt  |  165
> > ++++++++++++++++++++
> >  2 files changed, 214 insertions(+), 0 deletions(-)  create mode
> > 100644 Documentation/devicetree/bindings/mfd/palmas.txt
> >  create mode 100644
> > Documentation/devicetree/bindings/regulator/palmas-pmic.txt
> >
> > diff --git a/Documentation/devicetree/bindings/mfd/palmas.txt
> > b/Documentation/devicetree/bindings/mfd/palmas.txt
> > new file mode 100644
> > index 0000000..c6c5e78
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/mfd/palmas.txt
> > @@ -0,0 +1,49 @@
> > +* palmas device tree bindings
> > +
> > +The TI palmas family current members :-
> > +twl6035 (palmas)
> > +twl6037 (palmas)
> > +tps65913 (palmas)
> > +tps65914 (palmas)
> > +
> > +Required properties:
> > +- compatible : Should be from the list
> > +  ti,twl6035
> > +  ti,twl6036
> > +  ti,twl6037
> > +  ti,tps65913
> > +  ti,tps65914
> > +  ti,tps80036
> > +and also the generic series names
> > +  ti,palmas
> > +- interrupt-controller : palmas has its own internal IRQs
> > +- #interrupt-cells : should be set to 2 for IRQ number and flags
> > +  The first cell is the IRQ number.
> > +  The second cell is the flags, encoded as the trigger masks from
> > +  Documentation/devicetree/bindings/interrupts.txt
> > +- interrupt-parent : The parent interrupt controller.
> > +
> > +Optional properties:
> > +  ti,mux_padX : set the pad register X (1-2) to the correct muxing
> for the
> > +  		hardware, if not set will use muxing in OTP.
> > +
> > +Example:
> > +
> > +palmas {
> 
> Should this be 'palmas@48 {', as it has an address?
> 
> > +	compatible = "ti,twl6035", "ti,palmas";
> > +	reg = <0x48>
> > +	interrupt-parent = <&intc>;
> > +	interrupt-controller;
> > +	#interrupt-cells = <2>;
> > +
> > +	ti,mux-pad1 = <0>;
> > +	ti,mux-pad2 = <0>;
> > +
> > +	#address-cells = <1>;
> > +	#size-cells = <0>;
> > +
> > +	pmic {
> > +		compatible = "ti,twl6035-pmic", "ti,palmas-pmic";
> > +		....
> > +	};
> > +}
> > diff --git
> > a/Documentation/devicetree/bindings/regulator/palmas-pmic.txt
> > b/Documentation/devicetree/bindings/regulator/palmas-pmic.txt
> > new file mode 100644
> > index 0000000..f7bbc3e
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/regulator/palmas-pmic.txt
> > @@ -0,0 +1,165 @@
> > +* palmas regulator IP block devicetree bindings
> > +
> > +Required properties:
> > +- compatible : Should be from the list
> > +  ti,twl6035-pmic
> > +  ti,twl6036-pmic
> > +  ti,twl6037-pmic
> > +  ti,tps65913-pmic
> > +  ti,tps65914-pmic
> > +and also the generic series names
> > +  ti,palmas-pmic
> > +
> > +Optional properties:
> > +- ti,ldo6-vibrator : ldo6 is in vibrator mode
> > +
> > +Optional nodes:
> > +- regulators : should contain the constrains and init information
> for the
> > +	       regulators. It should contain a subnode per regulator from
> the
> > +	       list.
> > +	       For ti,palmas-pmic - smps12, smps123, smps3 depending on
> OTP,
> > +	       smps45, smps457, smps7 depending on varient, smps6,
> smps[8-10],
> > +	       ldo[1-9], ldoln, ldousb
> > +
> > +	       optional chip specific regulator fields :-
> > +	       ti,warm-reset - maintain voltage during warm
> reset(boolean)
> 
> Pushing the boat out a bit here, but is it possible to reuse
> 'regulator-always-on' for this?

It is getting used below.

> 
> > +	       ti,roof-floor - control voltage selection by pin(boolean)
> 
> Is this the same as a GPIO regulator?

This is not a GPIO Regulator.

> 
> If so, you might not need to add superfluous vendor specific
> properties.
> 
> See: Documentation/devicetree/bindings/regulator/gpio-regulator.txt
> 
> > +	       ti,sleep-mode - mode to adopt in pmic sleep 0 - off, 1 -
> auto,
> > +	       2 - eco, 3 - forced pwm
> 
> I've seen lots of sleep-mode properties, can't we define a generic one?

HW specific modes.

> 
> > +	       ti,tstep - slope control 0 - Jump, 1 10mV/us, 2 5mV/us, 3
> 2.5mV/us
> > +	       ti,smps-range - OTP has the wrong range set for the
> hardware so override
> > +	       0 - low range, 1 - high range
> > +
> > +Example:
> > +
> > +pmic@0 {
> 
> May as well drop the '@0' here unless it's meaningful.

Ok.

> 
> > +	compatible = "ti,twl6035-pmic", "ti,palmas-pmic";
> > +	interrupt-parent = <&palmas>;
> > +	interrupts = <14 0>;
> 
> Use the defines found in:
> 
> arch/arm/boot/dts/include/dt-bindings/interrupt-controller/irq.h

Ok. I will use the defines in the irq.h file.

> 
> > +	interrupt-name = "short-irq";
> > +
> > +	ti,ldo6_vibrator;
> 
> DT doesn't like '_'s, use a '-'s instead.
> 

Oops my bad.. I will change this.

> > +	regulators {
> > +		smps12_reg : smps12 {
> > +			regulator-name = "smps12";
> > +			regulator-min-microvolt = < 600000>;
> > +			regulator-max-microvolt = <1500000>;
> > +			regulator-always-on;
> > +			regulator-boot-on;
> > +			ti,warm-reset;
> 
> Hmm.. I see you're using 'regulator-always-on' and 'ti,warm-reset'
> here. Is there every a case where there is one without the other?

I am not sure of a case. I see that "warm-reset" property is used
Inside the regulator driver. This property is again HW specific
And it represents the warm reset sensitivity. If this 1 then voltage
Values during warm-reset are maintained if not then default OTP values
Are re-loaded during warm-reset.

> 
> > +			ti,roof-floor;
> > +			ti,mode-sleep = <0>;
> > +			ti,tstep = <0>;
> > +			ti,smps-range = <1>;
> > +		};
> > +
> > +		smps3_reg: smps3 {
> > +			regulator-name = "smps3";
> > +			regulator-min-microvolt = < 600000>;
> > +			regulator-max-microvolt = <1310000>;
> > +		};
> 
> Wow, this is a big example.
> 
> I don't think you need to provide more than 1 or 2 of these _reg nodes.

Ok. The intent here was to expose one example with a set of all the regulators
And their operating range of voltages.

Couple of files already have such examples:

Documentation/devicetree/bindings/regulator/tps65090.txt
Documentation/devicetree/bindings/regulator/tps65217.txt

I can knock off all of them and retain couple of them
if this is not needed.

> 
> > +		smps45_reg: smps45 {
> > +			regulator-name = "smps45";
> > +			regulator-min-microvolt = < 600000>;
> > +			regulator-max-microvolt = <1310000>;
> > +		};
> > +
> > +		smps6_reg: smps6 {
> > +			regulator-name = "smps6";
> > +			regulator-min-microvolt = <1200000>;
> > +			regulator-max-microvolt = <1200000>;
> > +		};
> > +
> > +		smps7_reg: smps7 {
> > +			regulator-name = "smps7";
> > +			regulator-min-microvolt = <1800000>;
> > +			regulator-max-microvolt = <1800000>;
> > +		};
> > +
> > +		smps8_reg: smps8 {
> > +			regulator-name = "smps8";
> > +			regulator-min-microvolt = < 600000>;
> > +			regulator-max-microvolt = <1310000>;
> > +		};
> > +
> > +		smps9_reg: smps9 {
> > +			regulator-name = "smps9";
> > +			regulator-min-microvolt = <2100000>;
> > +			regulator-max-microvolt = <2100000>;
> > +		};
> > +
> > +		smps10_reg: smps10 {
> > +			regulator-name = "smps10";
> > +			regulator-min-microvolt = <5000000>;
> > +			regulator-max-microvolt = <5000000>;
> > +		};
> > +
> > +		ldo1_reg: ldo1 {
> > +			regulator-name = "ldo1";
> > +			regulator-min-microvolt = <2800000>;
> > +			regulator-max-microvolt = <2800000>;
> > +		};
> > +
> > +		ldo2_reg: ldo2 {
> > +			regulator-name = "ldo2";
> > +			regulator-min-microvolt = <2900000>;
> > +			regulator-max-microvolt = <2900000>;
> > +		};
> > +
> > +		ldo3_reg: ldo3 {
> > +			regulator-name = "ldo3";
> > +			regulator-min-microvolt = <3000000>;
> > +			regulator-max-microvolt = <3000000>;
> > +		};
> > +
> > +		ldo4_reg: ldo4 {
> > +			regulator-name = "ldo4";
> > +			regulator-min-microvolt = <2200000>;
> > +			regulator-max-microvolt = <2200000>;
> > +		};
> > +
> > +		ldo5_reg: ldo5 {
> > +			regulator-name = "ldo5";
> > +			regulator-min-microvolt = <1800000>;
> > +			regulator-max-microvolt = <1800000>;
> > +		};
> > +
> > +		ldo6_reg: ldo6 {
> > +			regulator-name = "ldo6";
> > +			regulator-min-microvolt = <1500000>;
> > +			regulator-max-microvolt = <1500000>;
> > +		};
> > +
> > +		ldo7_reg: ldo7 {
> > +			regulator-name = "ldo7";
> > +			regulator-min-microvolt = <1500000>;
> > +			regulator-max-microvolt = <1500000>;
> > +		};
> > +
> > +		ldo8_reg: ldo8 {
> > +			regulator-name = "ldo8";
> > +			regulator-min-microvolt = <1500000>;
> > +			regulator-max-microvolt = <1500000>;
> > +		};
> > +
> > +		ldo9_reg: ldo9 {
> > +			regulator-name = "ldo9";
> > +			regulator-min-microvolt = <1800000>;
> > +			regulator-max-microvolt = <1800000>;
> > +		};
> > +
> > +		ldoln_reg: ldoln {
> > +			regulator-name = "ldoln";
> > +			regulator-min-microvolt = <1800000>;
> > +			regulator-max-microvolt = <1800000>;
> > +		};
> > +
> > +		ldousb_reg: ldousb {
> > +			regulator-name = "ldousb";
> > +			regulator-min-microvolt = <3250000>;
> > +			regulator-max-microvolt = <3250000>;
> > +		};
> > +	};
> > +};
> 
> --
> Lee Jones
> Linaro ST-Ericsson Landing Team Lead
> Linaro.org â”‚ Open source software for ARM SoCs Follow Linaro: Facebook
> | Twitter | Blog

Regards,
Keerthy
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
