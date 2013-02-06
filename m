Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104Ab3BFQ2H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 11:28:07 -0500
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:46160 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757701Ab3BFQYP (ORCPT
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
Subject: [PATCH 02/15] drivers/i2c: remove !S390 dependency, add missing GENERIC_HARDIRQS dependencies
Date: Wed,  6 Feb 2013 17:23:50 +0100
Message-Id: <1360167843-3587-3-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360167843-3587-1-git-send-email-heiko.carstens@de.ibm.com>
References: <1360167843-3587-1-git-send-email-heiko.carstens@de.ibm.com>
x-cbid: 13020616-6892-0000-0000-000004445FCB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove !S390 dependency from i2c Kconfig, since s390 now supports PCI, HAS_IOMEM
and HAS_DMA, however we need to add a couple of GENERIC_HARDIRQS dependecies to
fix compile and link errors like these:

ERROR: "devm_request_threaded_irq" [drivers/i2c/i2c-smbus.ko] undefined!
ERROR: "devm_request_threaded_irq" [drivers/i2c/busses/i2c-ocores.ko] undefined!

Cc: Wolfram Sang <w.sang@pengutronix.de>
Cc: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 drivers/i2c/Kconfig        |    2 +-
 drivers/i2c/busses/Kconfig |    6 ++++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/Kconfig b/drivers/i2c/Kconfig
index 46cde09..e380c6e 100644
--- a/drivers/i2c/Kconfig
+++ b/drivers/i2c/Kconfig
@@ -4,7 +4,6 @@
 
 menuconfig I2C
 	tristate "I2C support"
-	depends on !S390
 	select RT_MUTEXES
 	---help---
 	  I2C (pronounce: I-squared-C) is a slow serial bus protocol used in
@@ -76,6 +75,7 @@ config I2C_HELPER_AUTO
 
 config I2C_SMBUS
 	tristate "SMBus-specific protocols" if !I2C_HELPER_AUTO
+	depends on GENERIC_HARDIRQS
 	help
 	  Say Y here if you want support for SMBus extensions to the I2C
 	  specification. At the moment, the only supported extension is
diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 8bb810e..fd30505 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -112,7 +112,7 @@ config I2C_I801
 
 config I2C_ISCH
 	tristate "Intel SCH SMBus 1.0"
-	depends on PCI
+	depends on PCI && GENERIC_HARDIRQS
 	select LPC_SCH
 	help
 	  Say Y here if you want to use SMBus controller on the Intel SCH
@@ -519,6 +519,7 @@ config I2C_NUC900
 
 config I2C_OCORES
 	tristate "OpenCores I2C Controller"
+	depends on GENERIC_HARDIRQS
 	help
 	  If you say yes to this option, support will be included for the
 	  OpenCores I2C controller. For details see
@@ -753,7 +754,7 @@ config I2C_DIOLAN_U2C
 
 config I2C_PARPORT
 	tristate "Parallel port adapter"
-	depends on PARPORT
+	depends on PARPORT && GENERIC_HARDIRQS
 	select I2C_ALGOBIT
 	select I2C_SMBUS
 	help
@@ -778,6 +779,7 @@ config I2C_PARPORT
 
 config I2C_PARPORT_LIGHT
 	tristate "Parallel port adapter (light)"
+	depends on GENERIC_HARDIRQS
 	select I2C_ALGOBIT
 	select I2C_SMBUS
 	help
-- 
1.7.10.4

