Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934698Ab3E1Pz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 11:55:28 -0400
Received: from mga14.intel.com ([143.182.124.37]:54189 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934550Ab3E1Pz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 11:55:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,758,1363158000"; 
   d="scan'208";a="247706855"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH, resend] pch_phub: re-use native MAC address parser
Date: Tue, 28 May 2013 18:54:58 +0300
Message-Id: <1369756498-5670-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.8.2.rc0.22.gb3600c3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have mac_pton() helper to parse MAC addresses.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
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

