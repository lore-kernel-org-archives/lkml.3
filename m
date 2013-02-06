Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab3BFB6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 20:58:54 -0500
Received: from mail-ia0-f179.google.com ([209.85.210.179]:56444 "EHLO
	mail-ia0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754619Ab3BFB6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 20:58:52 -0500
From: Joe Millenbach <jmillenbach@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alan Cox <alan@linux.intel.com>, Jiri Slaby <jirislaby@gmail.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Joe Millenbach <jmillenbach@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>, Jamey Sharp <jamey@minilop.net>
Subject: [PATCH] input: drop unnecessary dependencies on TTY
Date: Tue,  5 Feb 2013 17:58:34 -0800
Message-Id: <1360115914-4334-1-git-send-email-jmillenbach@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Backing out changes made in earlier TTY removal patch.  Switched
to only one dependency in SERPORT on TTY instead of many incorrect
dependencies.

Signed-off-by: Joe Millenbach <jmillenbach@gmail.com>
Reported-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/joystick/Kconfig    |    4 ----
 drivers/input/keyboard/Kconfig    |   10 +---------
 drivers/input/mouse/Kconfig       |    3 ---
 drivers/input/serio/Kconfig       |    2 +-
 drivers/input/touchscreen/Kconfig |   22 ----------------------
 5 files changed, 2 insertions(+), 39 deletions(-)

diff --git a/drivers/input/joystick/Kconfig b/drivers/input/joystick/Kconfig
index 055bcab..56eb471 100644
--- a/drivers/input/joystick/Kconfig
+++ b/drivers/input/joystick/Kconfig
@@ -132,8 +132,6 @@ config JOYSTICK_TMDC
 
 source "drivers/input/joystick/iforce/Kconfig"
 
-if TTY
-
 config JOYSTICK_WARRIOR
 	tristate "Logitech WingMan Warrior joystick"
 	select SERIO
@@ -207,8 +205,6 @@ config JOYSTICK_ZHENHUA
 	  To compile this driver as a module, choose M here: the
 	  module will be called zhenhua.
 
-endif # TTY
-
 config JOYSTICK_DB9
 	tristate "Multisystem, Sega Genesis, Saturn joysticks and gamepads"
 	depends on PARPORT
diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index 008f96a..5a240c6 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -69,7 +69,6 @@ config KEYBOARD_ATARI
 config KEYBOARD_ATKBD
 	tristate "AT keyboard" if EXPERT || !X86
 	default y
-	depends on TTY
 	select SERIO
 	select SERIO_LIBPS2
 	select SERIO_I8042 if X86
@@ -154,7 +153,6 @@ config KEYBOARD_BFIN
 
 config KEYBOARD_LKKBD
 	tristate "DECstation/VAXstation LK201/LK401 keyboard"
-	depends on TTY
 	select SERIO
 	help
 	  Say Y here if you want to use a LK201 or LK401 style serial
@@ -270,7 +268,7 @@ config KEYBOARD_HIL_OLD
 
 config KEYBOARD_HIL
 	tristate "HP HIL keyboard/pointer support"
-	depends on (GSC || HP300) && TTY
+	depends on GSC || HP300
 	default y
 	select HP_SDC
 	select HIL_MLC
@@ -402,7 +400,6 @@ config KEYBOARD_IMX
 
 config KEYBOARD_NEWTON
 	tristate "Newton keyboard"
-	depends on TTY
 	select SERIO
 	help
 	  Say Y here if you have a Newton keyboard on a serial port.
@@ -482,8 +479,6 @@ config KEYBOARD_SAMSUNG
 	  To compile this driver as a module, choose M here: the
 	  module will be called samsung-keypad.
 
-if TTY
-
 config KEYBOARD_STOWAWAY
 	tristate "Stowaway keyboard"
 	select SERIO
@@ -506,8 +501,6 @@ config KEYBOARD_SUNKBD
 	  To compile this driver as a module, choose M here: the
 	  module will be called sunkbd.
 
-endif # TTY
-
 config KEYBOARD_SH_KEYSC
 	tristate "SuperH KEYSC keypad support"
 	depends on SUPERH || ARCH_SHMOBILE
@@ -604,7 +597,6 @@ config KEYBOARD_TWL4030
 
 config KEYBOARD_XTKBD
 	tristate "XT keyboard"
-	depends on TTY
 	select SERIO
 	help
 	  Say Y here if you want to use the old IBM PC/XT keyboard (or
diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
index fc160f7..cd6268c 100644
--- a/drivers/input/mouse/Kconfig
+++ b/drivers/input/mouse/Kconfig
@@ -14,7 +14,6 @@ if INPUT_MOUSE
 
 config MOUSE_PS2
 	tristate "PS/2 mouse"
-	depends on TTY
 	default y
 	select SERIO
 	select SERIO_LIBPS2
@@ -139,7 +138,6 @@ config MOUSE_PS2_OLPC
 
 config MOUSE_SERIAL
 	tristate "Serial mouse"
-	depends on TTY
 	select SERIO
 	help
 	  Say Y here if you have a serial (RS-232, COM port) mouse connected
@@ -264,7 +262,6 @@ config MOUSE_RISCPC
 
 config MOUSE_VSXXXAA
 	tristate "DEC VSXXX-AA/GA mouse and VSXXX-AB tablet"
-	depends on TTY
 	select SERIO
 	help
 	  Say Y (or M) if you want to use a DEC VSXXX-AA (hockey
diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
index 81ee755..fe4e495 100644
--- a/drivers/input/serio/Kconfig
+++ b/drivers/input/serio/Kconfig
@@ -4,7 +4,6 @@
 config SERIO
 	tristate "Serial I/O support" if EXPERT || !X86
 	default y
-	depends on TTY
 	help
 	  Say Yes here if you have any input device that uses serial I/O to
 	  communicate with the system. This includes the
@@ -37,6 +36,7 @@ config SERIO_I8042
 config SERIO_SERPORT
 	tristate "Serial port line discipline"
 	default y
+	depends on TTY
 	help
 	  Say Y here if you plan to use an input device (mouse, joystick,
 	  tablet, 6dof) that communicates over the RS232 serial (COM) port.
diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 3d6f548..515cfe7 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -192,8 +192,6 @@ config TOUCHSCREEN_DA9052
 	  To compile this driver as a module, choose M here: the
 	  module will be called da9052_tsi.
 
-if TTY
-
 config TOUCHSCREEN_DYNAPRO
 	tristate "Dynapro serial touchscreen"
 	select SERIO
@@ -218,8 +216,6 @@ config TOUCHSCREEN_HAMPSHIRE
 	  To compile this driver as a module, choose M here: the
 	  module will be called hampshire.
 
-endif # TTY
-
 config TOUCHSCREEN_EETI
 	tristate "EETI touchscreen panel support"
 	depends on I2C
@@ -241,7 +237,6 @@ config TOUCHSCREEN_EGALAX
 
 config TOUCHSCREEN_FUJITSU
 	tristate "Fujitsu serial touchscreen"
-	depends on TTY
 	select SERIO
 	help
 	  Say Y here if you have the Fujitsu touchscreen (such as one
@@ -280,8 +275,6 @@ config TOUCHSCREEN_S3C2410
 	  To compile this driver as a module, choose M here: the
 	  module will be called s3c2410_ts.
 
-if TTY
-
 config TOUCHSCREEN_GUNZE
 	tristate "Gunze AHL-51S touchscreen"
 	select SERIO
@@ -318,8 +311,6 @@ config TOUCHSCREEN_WACOM_W8001
 	  To compile this driver as a module, choose M here: the
 	  module will be called wacom_w8001.
 
-endif # TTY
-
 config TOUCHSCREEN_WACOM_I2C
 	tristate "Wacom Tablet support (I2C)"
 	depends on I2C
@@ -378,8 +369,6 @@ config TOUCHSCREEN_MMS114
 	  To compile this driver as a module, choose M here: the
 	  module will be called mms114.
 
-if TTY
-
 config TOUCHSCREEN_MTOUCH
 	tristate "MicroTouch serial touchscreens"
 	select SERIO
@@ -404,8 +393,6 @@ config TOUCHSCREEN_INEXIO
 	  To compile this driver as a module, choose M here: the
 	  module will be called inexio.
 
-endif # TTY
-
 config TOUCHSCREEN_INTEL_MID
 	tristate "Intel MID platform resistive touchscreen"
 	depends on INTEL_SCU_IPC
@@ -463,7 +450,6 @@ config TOUCHSCREEN_HTCPEN
 
 config TOUCHSCREEN_PENMOUNT
 	tristate "Penmount serial touchscreen"
-	depends on TTY
 	select SERIO
 	help
 	  Say Y here if you have a Penmount serial touchscreen connected to
@@ -507,8 +493,6 @@ config TOUCHSCREEN_TNETV107X
 	  To compile this driver as a module, choose M here: the
 	  module will be called tnetv107x-ts.
 
-if TTY
-
 config TOUCHSCREEN_TOUCHRIGHT
 	tristate "Touchright serial touchscreen"
 	select SERIO
@@ -533,8 +517,6 @@ config TOUCHSCREEN_TOUCHWIN
 	  To compile this driver as a module, choose M here: the
 	  module will be called touchwin.
 
-endif # TTY
-
 config TOUCHSCREEN_TI_AM335X_TSC
 	tristate "TI Touchscreen Interface"
 	depends on MFD_TI_AM335X_TSCADC
@@ -808,8 +790,6 @@ config TOUCHSCREEN_USB_EASYTOUCH
 	  Say Y here if you have an EasyTouch USB Touch controller.
 	  If unsure, say N.
 
-if TTY
-
 config TOUCHSCREEN_TOUCHIT213
 	tristate "Sahara TouchIT-213 touchscreen"
 	select SERIO
@@ -833,8 +813,6 @@ config TOUCHSCREEN_TSC_SERIO
 	  To compile this driver as a module, choose M here: the
 	  module will be called tsc40.
 
-endif # TTY
-
 config TOUCHSCREEN_TSC2005
         tristate "TSC2005 based touchscreens"
         depends on SPI_MASTER && GENERIC_HARDIRQS
-- 
1.7.9.5

