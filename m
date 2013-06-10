Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab3FJKQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 06:16:35 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:38866 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834Ab3FJKQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 06:16:33 -0400
From: "J, KEERTHY" <j-keerthy@ti.com>
To: Lee Jones <lee.jones@linaro.org>
CC: "Cousson, Benoit" <b-cousson@ti.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ldewangan@nvidia.com" <ldewangan@nvidia.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>
Subject: RE: [PATCH v2 2/2] ARM: dts: OMAP5: add palmas node and omap
 specific palmas regulator properties
Thread-Topic: [PATCH v2 2/2] ARM: dts: OMAP5: add palmas node and omap
 specific palmas regulator properties
Thread-Index: AQHOZbmzE+cagM526UGEdcQsLXChsJkuMo8AgACH2PA=
Date: Mon, 10 Jun 2013 10:16:07 +0000
Message-ID: <DC88CAD03C0052499C1907B327FC63229EABA5@DBDE04.ent.ti.com>
References: <1370855059-5342-1-git-send-email-j-keerthy@ti.com>
 <1370855059-5342-3-git-send-email-j-keerthy@ti.com>
 <20130610100540.GI20297@gmail.com>
In-Reply-To: <20130610100540.GI20297@gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5AAHEJF003264

Hello Lee jones,

> -----Original Message-----
> From: Lee Jones [mailto:lee.jones@linaro.org]
> Sent: Monday, June 10, 2013 3:36 PM
> To: J, KEERTHY
> Cc: Cousson, Benoit; devicetree-discuss@lists.ozlabs.org; linux-
> omap@vger.kernel.org; linux-kernel@vger.kernel.org;
> ldewangan@nvidia.com; grant.likely@secretlab.ca; swarren@wwwdotorg.org;
> swarren@nvidia.com; sameo@linux.intel.com; gg@slimlogic.co.uk
> Subject: Re: [PATCH v2 2/2] ARM: dts: OMAP5: add palmas node and omap
> specific palmas regulator properties
> 
> On Mon, 10 Jun 2013, J Keerthy wrote:
> 
> > Add palmas node and omap specific palmas regulator properties.
> >
> > Signed-off-by: J Keerthy <j-keerthy@ti.com>
> > ---
> >  arch/arm/boot/dts/omap5-uevm.dts |  147
> > ++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 147 insertions(+), 0 deletions(-)
> >
> > diff --git a/arch/arm/boot/dts/omap5-uevm.dts
> > b/arch/arm/boot/dts/omap5-uevm.dts
> > index 927db1e..ffbcc3f 100644
> > --- a/arch/arm/boot/dts/omap5-uevm.dts
> > +++ b/arch/arm/boot/dts/omap5-uevm.dts
> > @@ -8,6 +8,8 @@
> >  /dts-v1/;
> >
> >  #include "omap5.dtsi"
> > +#include <dt-bindings/interrupt-controller/irq.h>
> > +#include <dt-bindings/interrupt-controller/arm-gic.h>
> >
> >  / {
> >  	model = "TI OMAP5 uEVM board";
> > @@ -254,6 +256,151 @@
> >  	pinctrl-0 = <&i2c1_pins>;
> >
> >  	clock-frequency = <400000>;
> > +
> > +	palmas: palmas@48 {
> > +		reg = <0x48>;
> > +		/* SPI = 0, IRQ# = 7, active high level-sensitive */
> 
> I still think this is superfluous, especially now you're using the
> defines which basically say the same thing.

I retained the whole comment as it was needed to specify IRQ# as 7
And thought it completely described the below interrupt property.

I can knock it off if it is totally unnecessary.

If there are no further comments. Can I add a Reviewed-by?

> 
> > +		interrupts = <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>; /* IRQ_SYS_1N
> */
> > +		interrupt-parent = <&gic>;
> > +	};
> > +
> > +};
> > +
> > +#include "palmas.dtsi"
> > +
> > +&palmas {
> > +	palmas_pmic {
> > +		ti,ldo6-vibrator;
> > +
> > +		regulators {
> > +			smps123_reg: smps123 {
> > +				regulator-min-microvolt = < 600000>;
> > +				regulator-max-microvolt = <1500000>;
> > +				regulator-always-on;
> > +				regulator-boot-on;
> > +			};
> > +
> > +			smps45_reg: smps45 {
> > +				regulator-min-microvolt = < 600000>;
> > +				regulator-max-microvolt = <1310000>;
> > +				regulator-always-on;
> > +				regulator-boot-on;
> > +			};
> > +
> > +			smps6_reg: smps6 {
> > +				regulator-min-microvolt = <1200000>;
> > +				regulator-max-microvolt = <1200000>;
> > +				regulator-always-on;
> > +				regulator-boot-on;
> > +			};
> > +
> > +			smps7_reg: smps7 {
> > +				regulator-min-microvolt = <1800000>;
> > +				regulator-max-microvolt = <1800000>;
> > +				regulator-always-on;
> > +				regulator-boot-on;
> > +			};
> > +
> > +			smps8_reg: smps8 {
> > +				regulator-min-microvolt = < 600000>;
> > +				regulator-max-microvolt = <1310000>;
> > +				regulator-always-on;
> > +				regulator-boot-on;
> > +			};
> > +
> > +			smps9_reg: smps9 {
> > +				regulator-min-microvolt = <2100000>;
> > +				regulator-max-microvolt = <2100000>;
> > +				regulator-always-on;
> > +				regulator-boot-on;
> > +				ti,smps-range = <0x80>;
> > +			};
> > +
> > +			smps10_reg: smps10 {
> > +				regulator-min-microvolt = <5000000>;
> > +				regulator-max-microvolt = <5000000>;
> > +				regulator-always-on;
> > +				regulator-boot-on;
> > +			};
> > +
> > +			ldo1_reg: ldo1 {
> > +				regulator-min-microvolt = <2800000>;
> > +				regulator-max-microvolt = <2800000>;
> > +				regulator-always-on;
> > +				regulator-boot-on;
> > +			};
> > +
> > +			ldo2_reg: ldo2 {
> > +				regulator-min-microvolt = <2900000>;
> > +				regulator-max-microvolt = <2900000>;
> > +				regulator-always-on;
> > +				regulator-boot-on;
> > +			};
> > +
> > +			ldo3_reg: ldo3 {
> > +				regulator-min-microvolt = <3000000>;
> > +				regulator-max-microvolt = <3000000>;
> > +				regulator-always-on;
> > +				regulator-boot-on;
> > +			};
> > +
> > +			ldo4_reg: ldo4 {
> > +				regulator-min-microvolt = <2200000>;
> > +				regulator-max-microvolt = <2200000>;
> > +				regulator-always-on;
> > +				regulator-boot-on;
> > +			};
> > +
> > +			ldo5_reg: ldo5 {
> > +				regulator-min-microvolt = <1800000>;
> > +				regulator-max-microvolt = <1800000>;
> > +				regulator-always-on;
> > +				regulator-boot-on;
> > +			};
> > +
> > +			ldo6_reg: ldo6 {
> > +				regulator-min-microvolt = <1500000>;
> > +				regulator-max-microvolt = <1500000>;
> > +				regulator-always-on;
> > +				regulator-boot-on;
> > +			};
> > +
> > +			ldo7_reg: ldo7 {
> > +				regulator-min-microvolt = <1500000>;
> > +				regulator-max-microvolt = <1500000>;
> > +				regulator-always-on;
> > +				regulator-boot-on;
> > +			};
> > +
> > +			ldo8_reg: ldo8 {
> > +				regulator-min-microvolt = <1500000>;
> > +				regulator-max-microvolt = <1500000>;
> > +				regulator-always-on;
> > +				regulator-boot-on;
> > +			};
> > +
> > +			ldo9_reg: ldo9 {
> > +				regulator-min-microvolt = <1800000>;
> > +				regulator-max-microvolt = <3300000>;
> > +				regulator-always-on;
> > +				regulator-boot-on;
> > +			};
> > +
> > +			ldoln_reg: ldoln {
> > +				regulator-min-microvolt = <1800000>;
> > +				regulator-max-microvolt = <1800000>;
> > +				regulator-always-on;
> > +				regulator-boot-on;
> > +			};
> > +
> > +			ldousb_reg: ldousb {
> > +				regulator-min-microvolt = <3250000>;
> > +				regulator-max-microvolt = <3250000>;
> > +				regulator-always-on;
> > +				regulator-boot-on;
> > +			};
> > +		};
> > +	};
> >  };
> >
> >  &i2c5 {
> 
> --
> Lee Jones
> Linaro ST-Ericsson Landing Team Lead
> Linaro.org â”‚ Open source software for ARM SoCs Follow Linaro: Facebook
> | Twitter | Blog

Regards,
Keerthy
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
