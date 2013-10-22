Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab3JVPN1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 11:13:27 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:54785 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014Ab3JVPNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 11:13:24 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Kishon Vijay Abraham I <kishon@ti.com>, Tony Lindgren <tony@atomide.com>,
        Greg KH <greg@kroah.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the arm-soc tree
Date: Tue, 22 Oct 2013 17:10:48 +0200
Message-Id: <1382454649-16442-4-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1382454649-16442-1-git-send-email-treding@nvidia.com>
References: <1382369814-7582-1-git-send-email-treding@nvidia.com>
 <1382454649-16442-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's linux-next merge of the arm-soc tree got a conflict in

	arch/arm/boot/dts/omap3-evm.dts

caused by commits 975d963 (ARM: dts: omap: update usb_otg_hs data) and
465ce68 (ARM: dts: Add common support for omap3-evm).

I fixed it up (see below). Please verify that the resolution looks good.
Note that the resolution adds the phys and phy-names properties in the
usb_otg_hs node to complement the common omap3-evm DTSI introduced in
465ce68 with the changes done in 975d963.

Thanks,
Thierry
---
diff --cc arch/arm/boot/dts/omap3-evm-common.dtsi
index 0000000,b549329..3007e79
mode 000000,100644..100644
--- a/arch/arm/boot/dts/omap3-evm-common.dtsi
+++ b/arch/arm/boot/dts/omap3-evm-common.dtsi
@@@ -1,0 -1,94 +1,96 @@@
+ /*
+  * Common support for omap3 EVM boards
+  */
+ 
+ #include "omap-gpmc-smsc911x.dtsi"
+ 
+ / {
+ 	cpus {
+ 		cpu@0 {
+ 			cpu0-supply = <&vcc>;
+ 		};
+ 	};
+ 
+ 	leds {
+ 		compatible = "gpio-leds";
+ 		ledb {
+ 			label = "omap3evm::ledb";
+ 			gpios = <&twl_gpio 19 GPIO_ACTIVE_HIGH>; /* LEDB */
+ 			linux,default-trigger = "default-on";
+ 		};
+ 	};
+ 
+ 	wl12xx_vmmc: wl12xx_vmmc {
+ 		compatible = "regulator-fixed";
+ 		regulator-name = "vwl1271";
+ 		regulator-min-microvolt = <1800000>;
+ 		regulator-max-microvolt = <1800000>;
+ 		gpio = <&gpio5 22 0>;	/* gpio150 */
+ 		startup-delay-us = <70000>;
+ 		enable-active-high;
+ 		vin-supply = <&vmmc2>;
+ 	};
+ };
+ 
+ &i2c1 {
+ 	clock-frequency = <2600000>;
+ 
+ 	twl: twl@48 {
+ 		reg = <0x48>;
+ 		interrupts = <7>; /* SYS_NIRQ cascaded to intc */
+ 		interrupt-parent = <&intc>;
+ 	};
+ };
+ 
+ #include "twl4030.dtsi"
+ #include "twl4030_omap3.dtsi"
+ 
+ &i2c2 {
+ 	clock-frequency = <400000>;
+ };
+ 
+ &i2c3 {
+ 	clock-frequency = <400000>;
+ 
+ 	/*
+ 	 * TVP5146 Video decoder-in for analog input support.
+ 	 */
+ 	tvp5146@5c {
+ 		compatible = "ti,tvp5146m2";
+ 		reg = <0x5c>;
+ 	};
+ };
+ 
+ &mmc1 {
+ 	vmmc-supply = <&vmmc1>;
+ 	vmmc_aux-supply = <&vsim>;
+ 	bus-width = <8>;
+ };
+ 
+ &mmc2 {
+ 	vmmc-supply = <&wl12xx_vmmc>;
+ 	non-removable;
+ 	bus-width = <4>;
+ 	cap-power-off-card;
+ };
+ 
+ &twl_gpio {
+ 	ti,use-leds;
+ };
+ 
+ &usb_otg_hs {
+ 	interface-type = <0>;
+ 	usb-phy = <&usb2_phy>;
++	phys = <&usb2_phy>;
++	phy-names = "usb2-phy";
+ 	mode = <3>;
+ 	power = <50>;
+ };
+ 
+ &gpmc {
+ 	ethernet@gpmc {
+ 		interrupt-parent = <&gpio6>;
+ 		interrupts = <16 8>;
+ 		reg = <5 0 0xff>;
+ 	};
+ };
