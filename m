Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167Ab3FQGVm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 02:21:42 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56021 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932142Ab3FQGVk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 02:21:40 -0400
From: "J, KEERTHY" <j-keerthy@ti.com>
To: "Cousson, Benoit" <b-cousson@ti.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ldewangan@nvidia.com" <ldewangan@nvidia.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: RE: [PATCH v6] ARM: dts: OMAP5: Add Palmas MFD node and regulator
 nodes
Thread-Topic: [PATCH v6] ARM: dts: OMAP5: Add Palmas MFD node and regulator
 nodes
Thread-Index: AQHOZ+7UhtfCJexSIkigCr6os/kkTpkz26YwgAWZ1tA=
Date: Mon, 17 Jun 2013 06:21:07 +0000
Message-ID: <DC88CAD03C0052499C1907B327FC63229EBEB1@DBDE04.ent.ti.com>
References: <1371097811-4618-1-git-send-email-j-keerthy@ti.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benoit,

> -----Original Message-----
> From: J, KEERTHY
> Sent: Thursday, June 13, 2013 10:19 PM
> To: Cousson, Benoit
> Cc: linux-omap@vger.kernel.org; linux-kernel@vger.kernel.org;
> ldewangan@nvidia.com; grant.likely@secretlab.ca; swarren@wwwdotorg.org;
> swarren@nvidia.com; sameo@linux.intel.com; gg@slimlogic.co.uk;
> lee.jones@linaro.org; devicetree-discuss@lists.ozlabs.org
> Subject: RE: [PATCH v6] ARM: dts: OMAP5: Add Palmas MFD node and
> regulator nodes
> 
> Hi Benoit,
> 
> 
> > -----Original Message-----
> > From: J, KEERTHY
> > Sent: Thursday, June 13, 2013 10:00 AM
> > To: Cousson, Benoit; devicetree-discuss@lists.ozlabs.org
> > Cc: linux-omap@vger.kernel.org; linux-kernel@vger.kernel.org;
> > ldewangan@nvidia.com; grant.likely@secretlab.ca;
> > swarren@wwwdotorg.org; swarren@nvidia.com; sameo@linux.intel.com;
> > gg@slimlogic.co.uk; lee.jones@linaro.org; J, KEERTHY
> > Subject: [PATCH v6] ARM: dts: OMAP5: Add Palmas MFD node and
> regulator
> > nodes
> >
> > This patch adds Palmas MFD node and the regulator nodes for OMAP5.
> >
> > The node definitions are based on: https://lkml.org/lkml/2013/6/6/25
> >
> > Boot tested on omap5-uevm board.
> 
> Could you please pull this patch?
> 

A gentle ping on this patch.

> Regards,
> Keerthy

Regards,
Keerthy
> 
> >
> > Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
> > Signed-off-by: J Keerthy <j-keerthy@ti.com>
> > Reviewed-by: Stephen Warren <swarren@nvidia.com>
> > ---
> > V6:
> > Changed the order of properties.
> >
> > V5:
> > Corrected the IRQ_TYPE flag for OMAP5 board.
> >
> > V4:
> > Removed splitting Palmas node.
> >
> > V3:
> > Moved the entire Palmas device tree node to board file.
> >
> >  arch/arm/boot/dts/omap5-uevm.dts |  167
> > ++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 167 insertions(+), 0 deletions(-)
> >
> > diff --git a/arch/arm/boot/dts/omap5-uevm.dts
> > b/arch/arm/boot/dts/omap5-uevm.dts
> > index 927db1e..3d0b7b6 100644
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
> > @@ -254,6 +256,171 @@
> >  	pinctrl-0 = <&i2c1_pins>;
> >
> >  	clock-frequency = <400000>;
> > +
> > +	palmas: palmas@48 {
> > +		compatible = "ti,palmas";
> > +		interrupts = <GIC_SPI 7 IRQ_TYPE_NONE>; /* IRQ_SYS_1N */
> > +		interrupt-parent = <&gic>;
> > +		reg = <0x48>;
> > +		interrupt-controller;
> > +		#interrupt-cells = <2>;
> > +
> > +		palmas_pmic {
> > +			compatible = "ti,palmas-pmic";
> > +			interrupt-parent = <&palmas>;
> > +			interrupts = <14 IRQ_TYPE_NONE>;
> > +			interrupt-name = "short-irq";
> > +
> > +			ti,ldo6-vibrator;
> > +
> > +			regulators {
> > +				smps123_reg: smps123 {
> > +					regulator-name = "smps123";
> > +					regulator-min-microvolt = < 600000>;
> > +					regulator-max-microvolt = <1500000>;
> > +					regulator-always-on;
> > +					regulator-boot-on;
> > +				};
> > +
> > +				smps45_reg: smps45 {
> > +					regulator-name = "smps45";
> > +					regulator-min-microvolt = < 600000>;
> > +					regulator-max-microvolt = <1310000>;
> > +					regulator-always-on;
> > +					regulator-boot-on;
> > +				};
> > +
> > +				smps6_reg: smps6 {
> > +					regulator-name = "smps6";
> > +					regulator-min-microvolt = <1200000>;
> > +					regulator-max-microvolt = <1200000>;
> > +					regulator-always-on;
> > +					regulator-boot-on;
> > +				};
> > +
> > +				smps7_reg: smps7 {
> > +					regulator-name = "smps7";
> > +					regulator-min-microvolt = <1800000>;
> > +					regulator-max-microvolt = <1800000>;
> > +					regulator-always-on;
> > +					regulator-boot-on;
> > +				};
> > +
> > +				smps8_reg: smps8 {
> > +					regulator-name = "smps8";
> > +					regulator-min-microvolt = < 600000>;
> > +					regulator-max-microvolt = <1310000>;
> > +					regulator-always-on;
> > +					regulator-boot-on;
> > +				};
> > +
> > +				smps9_reg: smps9 {
> > +					regulator-name = "smps9";
> > +					regulator-min-microvolt = <2100000>;
> > +					regulator-max-microvolt = <2100000>;
> > +					regulator-always-on;
> > +					regulator-boot-on;
> > +					ti,smps-range = <0x80>;
> > +				};
> > +
> > +				smps10_reg: smps10 {
> > +					regulator-name = "smps10";
> > +					regulator-min-microvolt = <5000000>;
> > +					regulator-max-microvolt = <5000000>;
> > +					regulator-always-on;
> > +					regulator-boot-on;
> > +				};
> > +
> > +				ldo1_reg: ldo1 {
> > +					regulator-name = "ldo1";
> > +					regulator-min-microvolt = <2800000>;
> > +					regulator-max-microvolt = <2800000>;
> > +					regulator-always-on;
> > +					regulator-boot-on;
> > +				};
> > +
> > +				ldo2_reg: ldo2 {
> > +					regulator-name = "ldo2";
> > +					regulator-min-microvolt = <2900000>;
> > +					regulator-max-microvolt = <2900000>;
> > +					regulator-always-on;
> > +					regulator-boot-on;
> > +				};
> > +
> > +				ldo3_reg: ldo3 {
> > +					regulator-name = "ldo3";
> > +					regulator-min-microvolt = <3000000>;
> > +					regulator-max-microvolt = <3000000>;
> > +					regulator-always-on;
> > +					regulator-boot-on;
> > +				};
> > +
> > +				ldo4_reg: ldo4 {
> > +					regulator-name = "ldo4";
> > +					regulator-min-microvolt = <2200000>;
> > +					regulator-max-microvolt = <2200000>;
> > +					regulator-always-on;
> > +					regulator-boot-on;
> > +				};
> > +
> > +				ldo5_reg: ldo5 {
> > +					regulator-name = "ldo5";
> > +					regulator-min-microvolt = <1800000>;
> > +					regulator-max-microvolt = <1800000>;
> > +					regulator-always-on;
> > +					regulator-boot-on;
> > +				};
> > +
> > +				ldo6_reg: ldo6 {
> > +					regulator-name = "ldo6";
> > +					regulator-min-microvolt = <1500000>;
> > +					regulator-max-microvolt = <1500000>;
> > +					regulator-always-on;
> > +					regulator-boot-on;
> > +				};
> > +
> > +				ldo7_reg: ldo7 {
> > +					regulator-name = "ldo7";
> > +					regulator-min-microvolt = <1500000>;
> > +					regulator-max-microvolt = <1500000>;
> > +					regulator-always-on;
> > +					regulator-boot-on;
> > +				};
> > +
> > +				ldo8_reg: ldo8 {
> > +					regulator-name = "ldo8";
> > +					regulator-min-microvolt = <1500000>;
> > +					regulator-max-microvolt = <1500000>;
> > +					regulator-always-on;
> > +					regulator-boot-on;
> > +				};
> > +
> > +				ldo9_reg: ldo9 {
> > +					regulator-name = "ldo9";
> > +					regulator-min-microvolt = <1800000>;
> > +					regulator-max-microvolt = <3300000>;
> > +					regulator-always-on;
> > +					regulator-boot-on;
> > +				};
> > +
> > +				ldoln_reg: ldoln {
> > +					regulator-name = "ldoln";
> > +					regulator-min-microvolt = <1800000>;
> > +					regulator-max-microvolt = <1800000>;
> > +					regulator-always-on;
> > +					regulator-boot-on;
> > +				};
> > +
> > +				ldousb_reg: ldousb {
> > +					regulator-name = "ldousb";
> > +					regulator-min-microvolt = <3250000>;
> > +					regulator-max-microvolt = <3250000>;
> > +					regulator-always-on;
> > +					regulator-boot-on;
> > +				};
> > +			};
> > +		};
> > +	};
> >  };
> >
> >  &i2c5 {
> > --
> > 1.7.5.4

