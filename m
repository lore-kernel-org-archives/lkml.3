Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab3GHGEl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 02:04:41 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:57536 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753700Ab3GHGEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 02:04:22 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: starvik@axis.com, jesper.nilsson@axis.com
Cc: sfr@canb.auug.org.au, gregkh@linuxfoundation.org,
        David.Woodhouse@intel.com, artem.bityutskiy@linux.intel.com,
        linux-cris-kernel@axis.com, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH 1/3] cris: cleanup arch-v10/drivers/Kconfig
Date: Mon,  8 Jul 2013 08:04:09 +0200
Message-Id: <1373263451-26841-2-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373263451-26841-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1373263451-26841-1-git-send-email-michael.opdenacker@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove kernel configuration parameters
defined in arch/cris/arch-v10/drivers/Kconfig, but used nowhere
in the makefiles and source code.

It also removes parameters which are no longer used after this change

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/cris/arch-v10/drivers/Kconfig | 79 --------------------------------------
 1 file changed, 79 deletions(-)

diff --git a/arch/cris/arch-v10/drivers/Kconfig b/arch/cris/arch-v10/drivers/Kconfig
index 5f2cdb3..15dc349 100644
--- a/arch/cris/arch-v10/drivers/Kconfig
+++ b/arch/cris/arch-v10/drivers/Kconfig
@@ -410,25 +410,6 @@ config ETRAX_RS485_DISABLE_RECEIVER
 	  loopback.  Not all products are able to do this in software only.
 	  Axis 2400/2401 must disable receiver.
 
-config ETRAX_USB_HOST
-	bool "USB host"
-	select USB
-	help
-	   This option enables the host functionality of the ETRAX 100LX
-	   built-in USB controller. In host mode the controller is designed
-	   for CTRL and BULK traffic only, INTR traffic may work as well
-	   however (depending on the requirements of timeliness).
-
-config ETRAX_USB_HOST_PORT1
-	bool "USB port 1 enabled"
-	depends on ETRAX_USB_HOST
-	default n
-
-config ETRAX_USB_HOST_PORT2
-	bool "USB port 2 enabled"
-	depends on ETRAX_USB_HOST
-	default n
-
 config ETRAX_PTABLE_SECTOR
 	int "Byte-offset of partition table sector"
 	depends on ETRAX_AXISFLASHMAP
@@ -529,19 +510,6 @@ config ETRAX_GPIO
 	  Remember that you need to setup the port directions appropriately in
 	  the General configuration.
 
-config ETRAX_PA_BUTTON_BITMASK
-	hex "PA-buttons bitmask"
-	depends on ETRAX_GPIO
-	default "02"
-	help
-	  This is a bitmask with information about what bits on PA that
-	  are used for buttons.
-	  Most products has a so called TEST button on PA1, if that's true
-	  use 02 here.
-	  Use 00 if there are no buttons on PA.
-	  If the bitmask is <> 00 a button driver will be included in the gpio
-	  driver. ETRAX general I/O support must be enabled.
-
 config ETRAX_PA_CHANGEABLE_DIR
 	hex "PA user changeable dir mask"
 	depends on ETRAX_GPIO
@@ -582,51 +550,4 @@ config ETRAX_PB_CHANGEABLE_BITS
 	  Bit set = changeable.
 	  You probably want 00 here.
 
-config ETRAX_DS1302_RST_ON_GENERIC_PORT
-	bool "DS1302 RST on Generic Port"
-	depends on ETRAX_DS1302
-	help
-	  If your product has the RST signal line for the DS1302 RTC on the
-	  Generic Port then say Y here, otherwise leave it as N in which
-	  case the RST signal line is assumed to be connected to Port PB
-	  (just like the SCL and SDA lines).
-
-config ETRAX_DS1302_RSTBIT
-	int "DS1302 RST bit number"
-	depends on ETRAX_DS1302
-	default "2"
-	help
-	  This is the bit number for the RST signal line of the DS1302 RTC on
-	  the selected port. If you have selected the generic port then it
-	  should be bit 27, otherwise your best bet is bit 5.
-
-config ETRAX_DS1302_SCLBIT
-	int "DS1302 SCL bit number"
-	depends on ETRAX_DS1302
-	default "1"
-	help
-	  This is the bit number for the SCL signal line of the DS1302 RTC on
-	  Port PB. This is probably best left at 3.
-
-config ETRAX_DS1302_SDABIT
-	int "DS1302 SDA bit number"
-	depends on ETRAX_DS1302
-	default "0"
-	help
-	  This is the bit number for the SDA signal line of the DS1302 RTC on
-	  Port PB. This is probably best left at 2.
-
-config ETRAX_DS1302_TRICKLE_CHARGE
-	int "DS1302 Trickle charger value"
-	depends on ETRAX_DS1302
-	default "0"
-	help
-	  This controls the initial value of the trickle charge register.
-	  0 = disabled (use this if you are unsure or have a non rechargeable battery)
-	  Otherwise the following values can be OR:ed together to control the
-	  charge current:
-	  1 = 2kohm, 2 = 4kohm, 3 = 4kohm
-	  4 = 1 diode, 8 = 2 diodes
-	  Allowed values are (increasing current): 0, 11, 10, 9, 7, 6, 5
-
 endif
-- 
1.8.1.2

