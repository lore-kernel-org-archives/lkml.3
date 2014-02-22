Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbaBVHaQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 02:30:16 -0500
Received: from smtp21.mail.ru ([94.100.176.174]:41626 "EHLO smtp21.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbaBVHaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 02:30:08 -0500
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <kernel@pengutronix.de>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 1/4] w1: Remove excess dependencies on W1 for masters and slaves
Date: Sat, 22 Feb 2014 11:29:48 +0400
Message-Id: <1393054191-8623-1-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.8.3.2
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Configuration for masters and slaves is included only if W1 symbol
enabled, so no reason to check it once more.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/w1/masters/Kconfig | 3 +--
 drivers/w1/slaves/Kconfig  | 5 -----
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/w1/masters/Kconfig b/drivers/w1/masters/Kconfig
index efc7f07..6ffe120 100644
--- a/drivers/w1/masters/Kconfig
+++ b/drivers/w1/masters/Kconfig
@@ -36,13 +36,12 @@ config W1_MASTER_DS2482
 
 config W1_MASTER_MXC
 	tristate "Freescale MXC 1-wire busmaster"
-	depends on W1 && ARCH_MXC
+	depends on ARCH_MXC
 	help
 	  Say Y here to enable MXC 1-wire host
 
 config W1_MASTER_DS1WM
 	tristate "Maxim DS1WM 1-wire busmaster"
-	depends on W1
 	help
 	  Say Y here to enable the DS1WM 1-wire driver, such as that
 	  in HP iPAQ devices like h5xxx, h2200, and ASIC3-based like
diff --git a/drivers/w1/slaves/Kconfig b/drivers/w1/slaves/Kconfig
index 5e6a3c9..1cdce80 100644
--- a/drivers/w1/slaves/Kconfig
+++ b/drivers/w1/slaves/Kconfig
@@ -72,7 +72,6 @@ config W1_SLAVE_DS2433_CRC
 
 config W1_SLAVE_DS2760
 	tristate "Dallas 2760 battery monitor chip (HP iPAQ & others)"
-	depends on W1
 	help
 	  If you enable this you will have the DS2760 battery monitor
 	  chip support.
@@ -85,7 +84,6 @@ config W1_SLAVE_DS2760
 
 config W1_SLAVE_DS2780
 	tristate "Dallas 2780 battery monitor chip"
-	depends on W1
 	help
 	  If you enable this you will have the DS2780 battery monitor
 	  chip support.
@@ -98,7 +96,6 @@ config W1_SLAVE_DS2780
 
 config W1_SLAVE_DS2781
 	tristate "Dallas 2781 battery monitor chip"
-	depends on W1
 	help
 	  If you enable this you will have the DS2781 battery monitor
 	  chip support.
@@ -111,7 +108,6 @@ config W1_SLAVE_DS2781
 
 config W1_SLAVE_DS28E04
 	tristate "4096-Bit Addressable 1-Wire EEPROM with PIO (DS28E04-100)"
-	depends on W1
 	select CRC16
 	help
 	  If you enable this you will have the DS28E04-100
@@ -124,7 +120,6 @@ config W1_SLAVE_DS28E04
 
 config W1_SLAVE_BQ27000
 	tristate "BQ27000 slave support"
-	depends on W1
 	help
 	  Say Y here if you want to use a hdq
 	  bq27000 slave support.
-- 
1.8.3.2

