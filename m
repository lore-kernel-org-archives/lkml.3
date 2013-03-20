Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624Ab3CTJnw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 05:43:52 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:52260 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755902Ab3CTJnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 05:43:50 -0400
Message-ID: <1363772628.1390.85.camel@x61.thuisdomein>
Subject: [PATCH] CRIS: Remove last traces of legacy RTC drivers
From: Paul Bolle <pebolle@tiscali.nl>
To: Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Cc: linux-cris-kernel@axis.com, linux-kernel@vger.kernel.org
Date: Wed, 20 Mar 2013 10:43:48 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Mar 2013 09:43:48.0545 (UTC) FILETIME=[6C084B10:01CE254F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These legacy drivers were removed in commit
9c75fc8c5c8c50775fc8b89418219221335b758f ("CRIS: Remove legacy RTC
drivers"). Now remove their last traces in two Kconfig files and one
Makefile.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Eyeball tested only.

 arch/cris/Kconfig                   | 32 -------------------------
 arch/cris/arch-v10/drivers/Kconfig  | 47 -------------------------------------
 arch/cris/arch-v10/drivers/Makefile |  2 --
 3 files changed, 81 deletions(-)

diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index 06dd026..b02ca1b 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -271,38 +271,6 @@ config ETRAX_AXISFLASHMAP
 	  This option enables MTD mapping of flash devices.  Needed to use
 	  flash memories.  If unsure, say Y.
 
-config ETRAX_RTC
-	bool "Real Time Clock support"
-	depends on ETRAX_I2C
-	help
-	  Enables drivers for the Real-Time Clock battery-backed chips on
-	  some products. The kernel reads the time when booting, and
-	  the date can be set using ioctl(fd, RTC_SET_TIME, &rt) with rt a
-	  rtc_time struct (see <file:arch/cris/include/asm/rtc.h>) on the
-	  /dev/rtc device.  You can check the time with cat /proc/rtc, but
-	  normal time reading should be done using libc function time and
-	  friends.
-
-choice
-	prompt "RTC chip"
-	depends on ETRAX_RTC
-	default ETRAX_DS1302
-
-config ETRAX_DS1302
-	depends on ETRAX_ARCH_V10
-	bool "DS1302"
-	help
-	  Enables the driver for the DS1302 Real-Time Clock battery-backed
-	  chip on some products.
-
-config ETRAX_PCF8563
-	bool "PCF8563"
-	help
-	  Enables the driver for the PCF8563 Real-Time Clock battery-backed
-	  chip on some products.
-
-endchoice
-
 config ETRAX_SYNCHRONOUS_SERIAL
 	bool "Synchronous serial-port support"
 	help
diff --git a/arch/cris/arch-v10/drivers/Kconfig b/arch/cris/arch-v10/drivers/Kconfig
index 5f2cdb3..e5be544 100644
--- a/arch/cris/arch-v10/drivers/Kconfig
+++ b/arch/cris/arch-v10/drivers/Kconfig
@@ -582,51 +582,4 @@ config ETRAX_PB_CHANGEABLE_BITS
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
diff --git a/arch/cris/arch-v10/drivers/Makefile b/arch/cris/arch-v10/drivers/Makefile
index 44bf2e8..e5c1318 100644
--- a/arch/cris/arch-v10/drivers/Makefile
+++ b/arch/cris/arch-v10/drivers/Makefile
@@ -6,7 +6,5 @@ obj-$(CONFIG_ETRAX_AXISFLASHMAP)	+= axisflashmap.o
 obj-$(CONFIG_ETRAX_I2C)			+= i2c.o
 obj-$(CONFIG_ETRAX_I2C_EEPROM)		+= eeprom.o
 obj-$(CONFIG_ETRAX_GPIO)		+= gpio.o
-obj-$(CONFIG_ETRAX_DS1302)		+= ds1302.o
-obj-$(CONFIG_ETRAX_PCF8563)		+= pcf8563.o
 obj-$(CONFIG_ETRAX_SYNCHRONOUS_SERIAL)	+= sync_serial.o
 
-- 
1.7.11.7

