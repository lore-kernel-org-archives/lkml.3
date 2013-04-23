Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288Ab3DWQcD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:32:03 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60797 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757235Ab3DWQbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:31:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Marc Dietrich <marvin24@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 14/21] staging: nvec: allow modular build
Date: Tue, 23 Apr 2013 18:30:46 +0200
Message-Id: <1366734653-488286-15-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366734653-488286-1-git-send-email-arnd@arndb.de>
References: <1366734653-488286-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:hNQPunI4GtS80JnaF1hEU7vdzUvu44Uwx0Yge0msK3O
 9RcfdOyx+CmWhb8s6Jtq5P1sNBimsJscFKwgvo0Lm9bZH7NUT/
 +IVWUMUAlyc90C4091STN8EQIyifcQ5of6mp0imUdYO2g5gBOu
 MLkCZ68HwVNtyVbUUasKBLh7gF77vKh+1T+IqV3sbNbcvisUSN
 w4EI6H/qUIIZ8txDXFtaPHBoxGdwWi8hQwvJTH8+VcTRLIBk/n
 xcgkODec+DIClHdlRhL5n54S8D4/iniuWhpzr3Upvf8rhS0gBb
 ucP3AFceizAMejuMZdBaVPONQ1GDYPtzPy9CviL+Skb6ToX3Ej
 ASEQlcJiZwiLqdTLHFGv38FoXUmTivp7gmTWkN6UY
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The serio code can be a loadable module, which in turn means that nvec
also has to be a module, so mark it as "tristate" in Kconfig.

drivers/built-in.o: In function `nvec_mouse_remove':
drivers/staging/nvec/nvec_ps2.c:136: undefined reference to `serio_unregister_port'
drivers/built-in.o: In function `nvec_mouse_probe':
drivers/staging/nvec/nvec_ps2.c:126: undefined reference to `__serio_register_port'
drivers/built-in.o: In function `nvec_ps2_notifier':
drivers/staging/nvec/nvec_ps2.c:84: undefined reference to `serio_interrupt'
drivers/staging/nvec/nvec_ps2.c:91: undefined reference to `serio_interrupt'

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Marc Dietrich <marvin24@gmx.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/nvec/Kconfig | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/nvec/Kconfig b/drivers/staging/nvec/Kconfig
index f779fdc..7e61ada 100644
--- a/drivers/staging/nvec/Kconfig
+++ b/drivers/staging/nvec/Kconfig
@@ -1,5 +1,5 @@
 config MFD_NVEC
-	bool "NV Tegra Embedded Controller SMBus Interface"
+	tristate "NV Tegra Embedded Controller SMBus Interface"
 	depends on I2C && GPIOLIB && ARCH_TEGRA
 	select MFD_CORE
 	help
@@ -7,28 +7,28 @@ config MFD_NVEC
 	    controller.
 
 config KEYBOARD_NVEC
-	bool "Keyboard on nVidia compliant EC"
+	tristate "Keyboard on nVidia compliant EC"
 	depends on MFD_NVEC && INPUT
 	help
 	  Say Y here to enable support for a keyboard connected to 
 	  a nVidia compliant embedded controller.
 
 config SERIO_NVEC_PS2
-	bool "PS2 on nVidia EC"
+	tristate "PS2 on nVidia EC"
 	depends on MFD_NVEC && SERIO
 	help
 	  Say Y here to enable support for a Touchpad / Mouse connected
 	  to a nVidia compliant embedded controller.
 
 config NVEC_POWER
-	bool "NVEC charger and battery"
+	tristate "NVEC charger and battery"
 	depends on MFD_NVEC && POWER_SUPPLY
 	help
 	  Say Y to enable support for battery and charger interface for
 	  nVidia compliant embedded controllers.
 
 config NVEC_PAZ00
-	bool "Support for OEM specific functions on Compal PAZ00 based devices"
+	tristate "Support for OEM specific functions on Compal PAZ00 based devices"
 	depends on MFD_NVEC && LEDS_CLASS
 	help
 	  Say Y to enable control of the yellow side leds on Compal PAZ00 based
-- 
1.8.1.2

