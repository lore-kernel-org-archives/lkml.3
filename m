Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452AbaHKHAD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 03:00:03 -0400
Received: from mga03.intel.com ([143.182.124.21]:60093 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030AbaHKHAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 03:00:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,839,1400050800"; 
   d="scan'208";a="467305454"
From: Lan Tianyu <tianyu.lan@intel.com>
To: wsa@the-dreams.de, torvalds@linux-foundation.org,
        mika.westerberg@linux.intel.com
Cc: Lan Tianyu <tianyu.lan@intel.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] I2C: Make I2C core able to be module when I2C_ACPI is selected.
Date: Mon, 11 Aug 2014 15:00:55 +0800
Message-Id: <1407740455-21269-1-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit da3c6647(I2C/ACPI: Clean up I2C ACPI code and Add CONFIG_I2C_ACPI
config) adds a new kernel config I2C_ACPI and make I2C core built in
when the config is selected. This is wrong because distributions
etc generally compile I2C as a module and the commit broken that.
This patch is to make I2C core able to be a module when I2C_ACPI is
selected. Original issue the commit da3c6647 tried to avoid will
be fixed in ACPICA and it's rarely triggered during unloading module. 

Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
---
 drivers/i2c/Kconfig | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/i2c/Kconfig b/drivers/i2c/Kconfig
index 3e3b680..436ba27 100644
--- a/drivers/i2c/Kconfig
+++ b/drivers/i2c/Kconfig
@@ -2,9 +2,7 @@
 # I2C subsystem configuration
 #
 
-menu "I2C support"
-
-config I2C
+menuconfig I2C
 	tristate "I2C support"
 	select RT_MUTEXES
 	---help---
@@ -25,8 +23,7 @@ config I2C
 
 config I2C_ACPI
 	bool "I2C ACPI support"
-	select I2C
-	depends on ACPI
+	depends on I2C && ACPI
 	default y
 	help
 	  Say Y here if you want to enable ACPI I2C support. This includes support
@@ -139,4 +136,3 @@ config I2C_DEBUG_BUS
 
 endif # I2C
 
-endmenu
-- 
1.8.3.1

