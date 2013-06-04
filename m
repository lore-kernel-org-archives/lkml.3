Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab3FDOob (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:44:31 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:58083 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825Ab3FDOo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:44:28 -0400
MIME-Version: 1.0
Date: Tue, 4 Jun 2013 22:44:27 +0800
Message-ID: <CAPgLHd9eC=4Q45OKuh0mjUwkpQgLZnaoNCw0NhyVvo9mb43dXw@mail.gmail.com>
Subject: [PATCH] pch_phub: fix error return code in pch_phub_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: arnd@arndb.de, gregkh@linuxfoundation.org
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Error code had been assigned to retval in some error handling case
but never use it, 0 is always returned in those case, this patch
fix them to return a negative error code.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/misc/pch_phub.c | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/misc/pch_phub.c b/drivers/misc/pch_phub.c
index 931e635..6888450 100644
--- a/drivers/misc/pch_phub.c
+++ b/drivers/misc/pch_phub.c
@@ -669,8 +669,6 @@ static struct bin_attribute pch_bin_attr = {
 static int pch_phub_probe(struct pci_dev *pdev,
 				    const struct pci_device_id *id)
 {
-	int retval;
-
 	int ret;
 	struct pch_phub_reg *chip;
 
@@ -713,13 +711,13 @@ static int pch_phub_probe(struct pci_dev *pdev,
 	if (id->driver_data == 1) { /* EG20T PCH */
 		const char *board_name;
 
-		retval = sysfs_create_file(&pdev->dev.kobj,
-					   &dev_attr_pch_mac.attr);
-		if (retval)
+		ret = sysfs_create_file(&pdev->dev.kobj,
+					&dev_attr_pch_mac.attr);
+		if (ret)
 			goto err_sysfs_create;
 
-		retval = sysfs_create_bin_file(&pdev->dev.kobj, &pch_bin_attr);
-		if (retval)
+		ret = sysfs_create_bin_file(&pdev->dev.kobj, &pch_bin_attr);
+		if (ret)
 			goto exit_bin_attr;
 
 		pch_phub_read_modify_write_reg(chip,
@@ -743,8 +741,8 @@ static int pch_phub_probe(struct pci_dev *pdev,
 		chip->pch_opt_rom_start_address = PCH_PHUB_ROM_START_ADDR_EG20T;
 		chip->pch_mac_start_address = PCH_PHUB_MAC_START_ADDR_EG20T;
 	} else if (id->driver_data == 2) { /* ML7213 IOH */
-		retval = sysfs_create_bin_file(&pdev->dev.kobj, &pch_bin_attr);
-		if (retval)
+		ret = sysfs_create_bin_file(&pdev->dev.kobj, &pch_bin_attr);
+		if (ret)
 			goto err_sysfs_create;
 		/* set the prefech value
 		 * Device2(USB OHCI #1/ USB EHCI #1/ USB Device):a
@@ -766,12 +764,12 @@ static int pch_phub_probe(struct pci_dev *pdev,
 						 PCH_PHUB_ROM_START_ADDR_ML7223;
 		chip->pch_mac_start_address = PCH_PHUB_MAC_START_ADDR_ML7223;
 	} else if (id->driver_data == 4) { /* ML7223 IOH Bus-n*/
-		retval = sysfs_create_file(&pdev->dev.kobj,
-					   &dev_attr_pch_mac.attr);
-		if (retval)
+		ret = sysfs_create_file(&pdev->dev.kobj,
+					&dev_attr_pch_mac.attr);
+		if (ret)
 			goto err_sysfs_create;
-		retval = sysfs_create_bin_file(&pdev->dev.kobj, &pch_bin_attr);
-		if (retval)
+		ret = sysfs_create_bin_file(&pdev->dev.kobj, &pch_bin_attr);
+		if (ret)
 			goto exit_bin_attr;
 		/* set the prefech value
 		 * Device2(USB OHCI #0,1,2,3/ USB EHCI #0):a
@@ -783,13 +781,13 @@ static int pch_phub_probe(struct pci_dev *pdev,
 						 PCH_PHUB_ROM_START_ADDR_ML7223;
 		chip->pch_mac_start_address = PCH_PHUB_MAC_START_ADDR_ML7223;
 	} else if (id->driver_data == 5) { /* ML7831 */
-		retval = sysfs_create_file(&pdev->dev.kobj,
-					   &dev_attr_pch_mac.attr);
-		if (retval)
+		ret = sysfs_create_file(&pdev->dev.kobj,
+					&dev_attr_pch_mac.attr);
+		if (ret)
 			goto err_sysfs_create;
 
-		retval = sysfs_create_bin_file(&pdev->dev.kobj, &pch_bin_attr);
-		if (retval)
+		ret = sysfs_create_bin_file(&pdev->dev.kobj, &pch_bin_attr);
+		if (ret)
 			goto exit_bin_attr;
 
 		/* set the prefech value */

