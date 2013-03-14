Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757599Ab3CNOyj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 10:54:39 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:53543 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755972Ab3CNOyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 10:54:38 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] mfd: abx500 move the AB8500 Kconfig fragment
Date: Thu, 14 Mar 2013 15:54:24 +0100
Message-ID: <1363272864-16183-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

Move the AB8500 Kconfig fragment below the AB3100 so the
menuconfig menu gets hierarchically nested and looks nice.
Having the EZX PCAP in the middle disturbs the nice
hierarchical layout from kconfig.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
NOTE: it might look like this code is only touching the EZX
PCAP config fragment, but that is not the semantic effect,
that affects only the ABx500's.
---
 drivers/mfd/Kconfig | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 671f5b1..f91ae12 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -848,13 +848,6 @@ config AB3100_OTP
 	  programmable memory) support. This exposes a sysfs file to read
 	  out OTP values.
 
-config EZX_PCAP
-	bool "PCAP Support"
-	depends on GENERIC_HARDIRQS && SPI_MASTER
-	help
-	  This enables the PCAP ASIC present on EZX Phones. This is
-	  needed for MMC, TouchScreen, Sound, USB, etc..
-
 config AB8500_CORE
 	bool "ST-Ericsson AB8500 Mixed Signal Power Management chip"
 	depends on GENERIC_HARDIRQS && ABX500_CORE && MFD_DB8500_PRCMU
@@ -882,6 +875,13 @@ config AB8500_GPADC
 	help
 	  AB8500 GPADC driver used to convert Acc and battery/ac/usb voltage
 
+config EZX_PCAP
+	bool "PCAP Support"
+	depends on GENERIC_HARDIRQS && SPI_MASTER
+	help
+	  This enables the PCAP ASIC present on EZX Phones. This is
+	  needed for MMC, TouchScreen, Sound, USB, etc..
+
 config MFD_DB8500_PRCMU
 	bool "ST-Ericsson DB8500 Power Reset Control Management Unit"
 	depends on UX500_SOC_DB8500
-- 
1.7.11.3

