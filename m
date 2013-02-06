Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871Ab3BFQ17 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 11:27:59 -0500
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:46168 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757702Ab3BFQYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 11:24:15 -0500
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: arnd@arndb.de, axboe@kernel.dk, cbou@mail.ru, davem@davemloft.net,
        dtor@mail.ru, dwmw2@infradead.org, grant.likely@secretlab.ca,
        gregkh@linuxfoundation.org, jkosina@suse.cz, jslaby@suse.cz,
        khali@linux-fr.org, mchehab@redhat.com, perex@perex.cz,
        sameo@linux.intel.com, tiwai@suse.de, w.sang@pengutronix.de
Cc: linux-kernel@vger.kernel.org, sebott@linux.vnet.ibm.com,
        gerald.schaefer@de.ibm.com, schwidefsky@de.ibm.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 01/15] drivers/input: add couple of missing GENERIC_HARDIRQS dependencies
Date: Wed,  6 Feb 2013 17:23:49 +0100
Message-Id: <1360167843-3587-2-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360167843-3587-1-git-send-email-heiko.carstens@de.ibm.com>
References: <1360167843-3587-1-git-send-email-heiko.carstens@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
x-cbid: 13020616-6892-0000-0000-000004445FC6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When removing the !S390 dependency from drivers/input/Kconfig a couple
of drivers don't compile because they have a dependency on GENERIC_HARDIRQS.
So add the missing dependencies.
Fixes e.g. this one:

drivers/input/keyboard/lm8323.c: In function ‘lm8323_suspend’:
drivers/input/keyboard/lm8323.c:801:2: error: implicit declaration of function ‘irq_set_irq_wake’
	[-Werror=implicit-function-declaration]

Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 drivers/input/Kconfig             |    2 +-
 drivers/input/keyboard/Kconfig    |    4 ++--
 drivers/input/serio/Kconfig       |    1 +
 drivers/input/touchscreen/Kconfig |    2 +-
 4 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/input/Kconfig b/drivers/input/Kconfig
index 55f7e57..38b523a 100644
--- a/drivers/input/Kconfig
+++ b/drivers/input/Kconfig
@@ -3,7 +3,7 @@
 #
 
 menu "Input device support"
-	depends on !S390 && !UML
+	depends on !UML
 
 config INPUT
 	tristate "Generic input layer (needed for keyboard, mouse, ...)" if EXPERT
diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
index 502ed23..6a65da2 100644
--- a/drivers/input/keyboard/Kconfig
+++ b/drivers/input/keyboard/Kconfig
@@ -226,7 +226,7 @@ config KEYBOARD_TCA6416
 
 config KEYBOARD_TCA8418
 	tristate "TCA8418 Keypad Support"
-	depends on I2C
+	depends on I2C && GENERIC_HARDIRQS
 	select INPUT_MATRIXKMAP
 	help
 	  This driver implements basic keypad functionality
@@ -305,7 +305,7 @@ config KEYBOARD_HP7XX
 
 config KEYBOARD_LM8323
 	tristate "LM8323 keypad chip"
-	depends on I2C
+	depends on I2C && GENERIC_HARDIRQS
 	depends on LEDS_CLASS
 	help
 	  If you say yes here you get support for the National Semiconductor
diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
index 81ee755..d2138bf 100644
--- a/drivers/input/serio/Kconfig
+++ b/drivers/input/serio/Kconfig
@@ -237,6 +237,7 @@ config SERIO_PS2MULT
 
 config SERIO_ARC_PS2
 	tristate "ARC PS/2 support"
+	depends on GENERIC_HARDIRQS
 	help
 	  Say Y here if you have an ARC FPGA platform with a PS/2
 	  controller in it.
diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 3d6f548..59877b7 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -368,7 +368,7 @@ config TOUCHSCREEN_MCS5000
 
 config TOUCHSCREEN_MMS114
 	tristate "MELFAS MMS114 touchscreen"
-	depends on I2C
+	depends on I2C && GENERIC_HARDIRQS
 	help
 	  Say Y here if you have the MELFAS MMS114 touchscreen controller
 	  chip in your system.
-- 
1.7.10.4

