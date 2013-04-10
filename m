Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765547Ab3DJDs0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 23:48:26 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60883 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713Ab3DJDsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 23:48:24 -0400
Date: Wed, 10 Apr 2013 13:48:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: linux-next: manual merge of the mfd tree with the v4l-dvb tree
Message-Id: <20130410134813.b1bff6027f64f14d75d43927@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__10_Apr_2013_13_48_13_+1000_BHXyCuoTN3K1V.mc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Apr_2013_13_48_13_+1000_BHXyCuoTN3K1V.mc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

Today's linux-next merge of the mfd tree got a conflict in
drivers/mfd/Kconfig between commit 3f8ec5df11aa ("[media] mfd: Add header
files and Kbuild plumbing for SI476x MFD core") from the v4l-dvb tree and
commit ab85b120e692 ("mfd: Kconfig alphabetical re-ordering") from the
mfd tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

diff --cc drivers/mfd/Kconfig
index b6bb6d5,2f3ce18..0000000
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@@ -977,68 -920,38 +920,51 @@@ config MFD_WL1273_COR
  	  driver connects the radio-wl1273 V4L2 module and the wl1273
  	  audio codec.
 =20
 +config MFD_SI476X_CORE
 +	tristate "Support for Silicon Laboratories 4761/64/68 AM/FM radio."
 +	depends on I2C
 +	select MFD_CORE
 +	select REGMAP_I2C
 +	help
 +	  This is the core driver for the SI476x series of AM/FM
 +	  radio. This MFD driver connects the radio-si476x V4L2 module
 +	  and the si476x audio codec.
 +
 +	  To compile this driver as a module, choose M here: the
 +	  module will be called si476x-core.
 +
- config MFD_OMAP_USB_HOST
- 	bool "Support OMAP USBHS core and TLL driver"
- 	depends on USB_EHCI_HCD_OMAP || USB_OHCI_HCD_OMAP3
- 	default y
- 	help
- 	  This is the core driver for the OAMP EHCI and OHCI drivers.
- 	  This MFD driver does the required setup functionalities for
- 	  OMAP USB Host drivers.
-=20
- config MFD_PM8XXX
- 	tristate
-=20
- config MFD_PM8921_CORE
- 	tristate "Qualcomm PM8921 PMIC chip"
- 	depends on MSM_SSBI
+ config MFD_LM3533
+ 	tristate "TI/National Semiconductor LM3533 Lighting Power chip"
+ 	depends on I2C
  	select MFD_CORE
- 	select MFD_PM8XXX
+ 	select REGMAP_I2C
+ 	depends on GENERIC_HARDIRQS
  	help
- 	  If you say yes to this option, support will be included for the
- 	  built-in PM8921 PMIC chip.
-=20
- 	  This is required if your board has a PM8921 and uses its features,
- 	  such as: MPPs, GPIOs, regulators, interrupts, and PWM.
-=20
- 	  Say M here if you want to include support for PM8921 chip as a module.
- 	  This will build a module called "pm8921-core".
+ 	  Say yes here to enable support for National Semiconductor / TI
+ 	  LM3533 Lighting Power chips.
 =20
- config MFD_PM8XXX_IRQ
- 	bool "Support for Qualcomm PM8xxx IRQ features"
- 	depends on MFD_PM8XXX
- 	default y if MFD_PM8XXX
- 	help
- 	  This is the IRQ driver for Qualcomm PM 8xxx PMIC chips.
+ 	  This driver provides common support for accessing the device;
+ 	  additional drivers must be enabled in order to use the LED,
+ 	  backlight or ambient-light-sensor functionality of the device.
 =20
- 	  This is required to use certain other PM 8xxx features, such as GPIO
- 	  and MPP.
+ config MFD_TIMBERDALE
+ 	tristate "Timberdale FPGA"
+ 	select MFD_CORE
+ 	depends on PCI && GPIOLIB
+ 	---help---
+ 	This is the core driver for the timberdale FPGA. This device is a
+ 	multifunction device which exposes numerous platform devices.
 =20
- config TPS65911_COMPARATOR
- 	tristate
+ 	The timberdale FPGA can be found on the Intel Atom development board
+ 	for in-vehicle infontainment, called Russellville.
 =20
- config MFD_TPS65090
- 	bool "TPS65090 Power Management chips"
+ config MFD_TC3589X
+ 	bool "Toshiba TC35892 and variants"
  	depends on I2C=3Dy && GENERIC_HARDIRQS
  	select MFD_CORE
- 	select REGMAP_I2C
- 	select REGMAP_IRQ
  	help
- 	  If you say yes here you get support for the TPS65090 series of
- 	  Power Management chips.
+ 	  Support for the Toshiba TC35892 and variants I/O Expander.
+=20
  	  This driver provides common support for accessing the device,
  	  additional drivers must be enabled in order to use the
  	  functionality of the device.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__10_Apr_2013_13_48_13_+1000_BHXyCuoTN3K1V.mc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRZOD9AAoJEECxmPOUX5FEaK4P/2EIOIJUQIibR4gRBmvHuwKS
xSBL+OjZBj0tMznscQEWSDdVw49iP9LG2dh7cE201NvR0/mj8OgmJGYJfnGi+oSA
lLKck0/KwzBTyKcmNv59FXXLzpSs4N3WpHoBkXfq+5nUOJIrXW+En09bJPIj3pt0
PbLFpXvSHc+gZ9OuC3DFFuyCOVEoYygWGJKI6Y+iNSq8wb00TAmQrl8yCjvZpgiQ
Jm07b96MCQGNVi9HWo1wvECNhNkmCd+v7qGEBNjR4y5CZ4+j53C+TVAqXtfzfjjM
3Xm6lwK84WcF52XBUP2oUsH+r+/sRYQpZpF97MFHcMRknJxeu6Gk3J+zSsxOJ0Ov
zBWk7WzutnTKwFAKPRTTS+Kg4i7tHIhyma5SoQcllyDALTKtHQ4SOvuTHJb3NdJK
HAUggrRLsym4AuunH428BCeSROyIikn/qumiwx82JSRNIDsMoVAj1e3nbhkN89Il
ZxxXbNMmmoxdb9Jf7VTQsAO7mMatyRcdUMGcI1zqRn/GzjPskPlBMYpVMISgYfXL
8twKmkjPqEb5CUmJDN+AR3kQT01rEc1uRlTVjygCupe6NLBR+fAZFgzOaK9QyAIM
oXE9LcuNQku01vwbY5Panx8uwcuMNhV7/9YAqfGSD2lPh5p81r5D1bsFhxxBj01n
4CZ5jVGLyvaFXWwTO2gR
=DDFS
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Apr_2013_13_48_13_+1000_BHXyCuoTN3K1V.mc--
