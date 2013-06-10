Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490Ab3FJITh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 04:19:37 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46774 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256Ab3FJITf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 04:19:35 -0400
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
Subject: RE: [PATCH 2/2] ARM: dts: OMAP5: add palmas node and omap specific
 palmas regulator properties
Thread-Topic: [PATCH 2/2] ARM: dts: OMAP5: add palmas node and omap specific
 palmas regulator properties
Thread-Index: AQHOZaNQ/jQDmqQPGkS1w2i8rju8v5kuEwMAgACHdNA=
Date: Mon, 10 Jun 2013 08:19:09 +0000
Message-ID: <DC88CAD03C0052499C1907B327FC63229EAAC8@DBDE04.ent.ti.com>
References: <1370845335-14926-1-git-send-email-j-keerthy@ti.com>
 <1370845335-14926-3-git-send-email-j-keerthy@ti.com>
 <20130610081208.GD24958@gmail.com>
In-Reply-To: <20130610081208.GD24958@gmail.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5A8JwV7002380

Hello Lee Jones,

> -----Original Message-----
> From: Lee Jones [mailto:lee.jones@linaro.org]
> Sent: Monday, June 10, 2013 1:42 PM
> To: J, KEERTHY
> Cc: Cousson, Benoit; devicetree-discuss@lists.ozlabs.org; linux-
> omap@vger.kernel.org; linux-kernel@vger.kernel.org;
> ldewangan@nvidia.com; grant.likely@secretlab.ca; swarren@wwwdotorg.org;
> swarren@nvidia.com; sameo@linux.intel.com; gg@slimlogic.co.uk
> Subject: Re: [PATCH 2/2] ARM: dts: OMAP5: add palmas node and omap
> specific palmas regulator properties
> 
> > Add palmas node and omap specific palmas regulator properties.
> >
> > This patch is based on:
> >
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/bcousson/linux-
> omap-dt.git
> > 	for_3.11/dts
> 
> There's no need for this to be in the commit message.
> 

Ok. I will remove this.

> > Boot tested on omap5-uevm board.
> >
> > Signed-off-by: J Keerthy <j-keerthy@ti.com>
> > ---
> >  arch/arm/boot/dts/omap5-uevm.dts |  145
> > ++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 145 insertions(+), 0 deletions(-)
> >
> > diff --git a/arch/arm/boot/dts/omap5-uevm.dts
> > b/arch/arm/boot/dts/omap5-uevm.dts
> > index 927db1e..88172db 100644
> > --- a/arch/arm/boot/dts/omap5-uevm.dts
> > +++ b/arch/arm/boot/dts/omap5-uevm.dts
> > @@ -254,6 +254,151 @@
> >  	pinctrl-0 = <&i2c1_pins>;
> >
> >  	clock-frequency = <400000>;
> > +
> > +	palmas: palmas@48 {
> > +		reg = <0x48>;
> > +		/* SPI = 0, IRQ# = 7, 4 = active high level-sensitive */
> 
> The interrupt property is fairly ubiqutous. There's not really any need
> to document it in this manor.
> 
> > +		interrupts = <0 7 4>; /* IRQ_SYS_1N cascaded to gic */
> 
> Use the IRQ includes in dt-bindings.

Oops Yes I will include.

> 
> > +		interrupt-parent = <&gic>;
> > +	};
> > +
> > +};
> > +
> > +#include "palmas.dtsi"
> 
> I'm a bit confused by this. Is it now common practice to break out
> nodes in this way? I assume to counter mass indentation, but it's a bit
> alien to me.
> 
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
> 
> Are these all board specific, or are they shared with any other
> platform?

Yes. Hence moved all of them to board file as compared to my
Last approach when I had kept all of them under palmas.dtsi.

> 
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
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
