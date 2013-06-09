Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324Ab3FIULb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 16:11:31 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:42506 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab3FIUL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 16:11:29 -0400
Date: Sun, 9 Jun 2013 23:11:19 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: pali.rohar@gmail.com, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org
Subject: Re: N900 device tree conversion: how to do first step
Message-ID: <20130609201119.GA3190@blackmetal.musicnaut.iki.fi>
References: <20130609015944.GA23559@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130609015944.GA23559@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jun 09, 2013 at 03:59:44AM +0200, Pavel Machek wrote:
> I'd like to convert Nokia N900 to device tree.
> 
> Unfortunately, serial port is not easily available (very special cable
> would be needed, does someone know where to get one?) and I don't have
> BDI (and very special cable would be needed, too).
> 
> So I tried doing very small first step, hoping that I get booting
> system... obviously I did not.

The following works for me, it's enough to boot and get the USB networking
working. After that I can connect to the device with ssh. I don't use
serial either, I just have initramfs with busybox+dropbear with hardcoded
interface setup.

---8<---

/dts-v1/;

/include/ "omap34xx.dtsi"

/ {
	model = "Nokia N900";
	compatible = "nokia,omap3-n900", "ti,omap3";

	cpus {
		cpu@0 {
			cpu0-supply = <&vcc>;
		};
	};

	memory {
		device_type = "memory";
		reg = <0x80000000 0x10000000>; /* 256 MB */
	};

};

&i2c1 {
	clock-frequency = <2200000>;

	twl: twl@48 {
		reg = <0x48>;
		interrupts = <7>; /* SYS_NIRQ cascaded to intc */
		interrupt-parent = <&intc>;
	};
};

/include/ "twl4030.dtsi"

&twl_gpio {
	ti,pullups	= <0x0>;
	ti,pulldowns	= <0x03ff3f>; /* BIT(0..5) | BIT(8..17) */
};

&i2c2 {
	clock-frequency = <400000>;
};

&i2c3 {
	clock-frequency = <100000>;
};

&mmc1 {
	status = "disabled";
};

&mmc2 {
	status = "disabled";
};

&mmc3 {
	status = "disabled";
};

&usb_otg_hs {
	interface-type = <0>;
	usb-phy = <&usb2_phy>;
	mode = <2>;
	power = <50>;
};
