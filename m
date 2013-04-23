Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350Ab3DWNbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 09:31:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:17687 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756168Ab3DWNbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 09:31:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,533,1363158000"; 
   d="scan'208";a="299693529"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] pch_phub: re-use native MAC address parser
Date: Tue, 23 Apr 2013 16:31:30 +0300
Message-Id: <1366723890-23838-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have mac_pton() helper to parse MAC addresses.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/misc/pch_phub.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/pch_phub.c b/drivers/misc/pch_phub.c
index 931e635..8b4d4fb 100644
--- a/drivers/misc/pch_phub.c
+++ b/drivers/misc/pch_phub.c
@@ -633,17 +633,13 @@ static ssize_t show_pch_mac(struct device *dev, struct device_attribute *attr,
 static ssize_t store_pch_mac(struct device *dev, struct device_attribute *attr,
 			     const char *buf, size_t count)
 {
-	u8 mac[6];
+	u8 mac[ETH_ALEN];
 	ssize_t rom_size;
 	struct pch_phub_reg *chip = dev_get_drvdata(dev);
 
-	if (count != 18)
+	if (!mac_pton(buf, mac))
 		return -EINVAL;
 
-	sscanf(buf, "%02x:%02x:%02x:%02x:%02x:%02x",
-		(u32 *)&mac[0], (u32 *)&mac[1], (u32 *)&mac[2], (u32 *)&mac[3],
-		(u32 *)&mac[4], (u32 *)&mac[5]);
-
 	chip->pch_phub_extrom_base_address = pci_map_rom(chip->pdev, &rom_size);
 	if (!chip->pch_phub_extrom_base_address)
 		return -ENOMEM;
-- 
1.8.2.rc0.22.gb3600c3

