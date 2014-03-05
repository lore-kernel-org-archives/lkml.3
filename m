Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415AbaCEJww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 04:52:52 -0500
Received: from webbox1416.server-home.net ([77.236.96.61]:58666 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753933AbaCEJwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 04:52:50 -0500
X-Greylist: delayed 439 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Mar 2014 04:52:50 EST
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        Alexander Stein <alexander.stein@systec-electronic.com>
Subject: [PATCH] pch_phub: Report error writing MAC back to user
Date: Wed,  5 Mar 2014 10:44:57 +0100
Message-Id: <1394012697-27285-1-git-send-email-alexander.stein@systec-electronic.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
---
 drivers/misc/pch_phub.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/pch_phub.c b/drivers/misc/pch_phub.c
index a5925f7f..9565973 100644
--- a/drivers/misc/pch_phub.c
+++ b/drivers/misc/pch_phub.c
@@ -636,6 +636,7 @@ static ssize_t store_pch_mac(struct device *dev, struct device_attribute *attr,
 	u8 mac[ETH_ALEN];
 	ssize_t rom_size;
 	struct pch_phub_reg *chip = dev_get_drvdata(dev);
+	int ret;
 
 	if (!mac_pton(buf, mac))
 		return -EINVAL;
@@ -644,8 +645,10 @@ static ssize_t store_pch_mac(struct device *dev, struct device_attribute *attr,
 	if (!chip->pch_phub_extrom_base_address)
 		return -ENOMEM;
 
-	pch_phub_write_gbe_mac_addr(chip, mac);
+	ret = pch_phub_write_gbe_mac_addr(chip, mac);
 	pci_unmap_rom(chip->pdev, chip->pch_phub_extrom_base_address);
+	if (ret)
+		return ret;
 
 	return count;
 }
-- 
1.8.3.2

