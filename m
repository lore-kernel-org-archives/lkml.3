Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab3JWMTP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 08:19:15 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:48564 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752767Ab3JWMTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 08:19:13 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19BWkO87CwVq9wIe8TIEEXj
Date: Wed, 23 Oct 2013 05:19:03 -0700
From: Tony Lindgren <tony@atomide.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, Greg KH <greg@kroah.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the arm-soc tree
Message-ID: <20131023121903.GT15154@atomide.com>
References: <1382369814-7582-1-git-send-email-treding@nvidia.com>
 <1382454649-16442-1-git-send-email-treding@nvidia.com>
 <1382454649-16442-4-git-send-email-treding@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382454649-16442-4-git-send-email-treding@nvidia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thierry Reding <thierry.reding@gmail.com> [131022 08:13]:
> Today's linux-next merge of the arm-soc tree got a conflict in
> 
> 	arch/arm/boot/dts/omap3-evm.dts
> 
> caused by commits 975d963 (ARM: dts: omap: update usb_otg_hs data) and
> 465ce68 (ARM: dts: Add common support for omap3-evm).
> 
> I fixed it up (see below). Please verify that the resolution looks good.
> Note that the resolution adds the phys and phy-names properties in the
> usb_otg_hs node to complement the common omap3-evm DTSI introduced in
> 465ce68 with the changes done in 975d963.

Sigh there was no conflict in sight when I acked patch "ARM: dts: Add common
support for omap3-evm", then I created the omap3-evm-common.dtsi not
remembering about the earlier patch. So a totally self-inflicted merge
conflict again and more proof that the dts files need to be always
merged seprately from the drivers.

The merge conflict below looks correct thanks.

Regards,

Tony
 
> diff --cc arch/arm/boot/dts/omap3-evm-common.dtsi
> index 0000000,b549329..3007e79
> mode 000000,100644..100644
> --- a/arch/arm/boot/dts/omap3-evm-common.dtsi
> +++ b/arch/arm/boot/dts/omap3-evm-common.dtsi
> @@@ -1,0 -1,94 +1,96 @@@
> + /*
> +  * Common support for omap3 EVM boards
> +  */
> + 
> + #include "omap-gpmc-smsc911x.dtsi"
> + 
> + / {
> + 	cpus {
> + 		cpu@0 {
> + 			cpu0-supply = <&vcc>;
> + 		};
> + 	};
> + 
> + 	leds {
> + 		compatible = "gpio-leds";
> + 		ledb {
> + 			label = "omap3evm::ledb";
> + 			gpios = <&twl_gpio 19 GPIO_ACTIVE_HIGH>; /* LEDB */
> + 			linux,default-trigger = "default-on";
> + 		};
> + 	};
> + 
> + 	wl12xx_vmmc: wl12xx_vmmc {
> + 		compatible = "regulator-fixed";
> + 		regulator-name = "vwl1271";
> + 		regulator-min-microvolt = <1800000>;
> + 		regulator-max-microvolt = <1800000>;
> + 		gpio = <&gpio5 22 0>;	/* gpio150 */
> + 		startup-delay-us = <70000>;
> + 		enable-active-high;
> + 		vin-supply = <&vmmc2>;
> + 	};
> + };
> + 
> + &i2c1 {
> + 	clock-frequency = <2600000>;
> + 
> + 	twl: twl@48 {
> + 		reg = <0x48>;
> + 		interrupts = <7>; /* SYS_NIRQ cascaded to intc */
> + 		interrupt-parent = <&intc>;
> + 	};
> + };
> + 
> + #include "twl4030.dtsi"
> + #include "twl4030_omap3.dtsi"
> + 
> + &i2c2 {
> + 	clock-frequency = <400000>;
> + };
> + 
> + &i2c3 {
> + 	clock-frequency = <400000>;
> + 
> + 	/*
> + 	 * TVP5146 Video decoder-in for analog input support.
> + 	 */
> + 	tvp5146@5c {
> + 		compatible = "ti,tvp5146m2";
> + 		reg = <0x5c>;
> + 	};
> + };
> + 
> + &mmc1 {
> + 	vmmc-supply = <&vmmc1>;
> + 	vmmc_aux-supply = <&vsim>;
> + 	bus-width = <8>;
> + };
> + 
> + &mmc2 {
> + 	vmmc-supply = <&wl12xx_vmmc>;
> + 	non-removable;
> + 	bus-width = <4>;
> + 	cap-power-off-card;
> + };
> + 
> + &twl_gpio {
> + 	ti,use-leds;
> + };
> + 
> + &usb_otg_hs {
> + 	interface-type = <0>;
> + 	usb-phy = <&usb2_phy>;
> ++	phys = <&usb2_phy>;
> ++	phy-names = "usb2-phy";
> + 	mode = <3>;
> + 	power = <50>;
> + };
> + 
> + &gpmc {
> + 	ethernet@gpmc {
> + 		interrupt-parent = <&gpio6>;
> + 		interrupts = <16 8>;
> + 		reg = <5 0 0xff>;
> + 	};
> + };
