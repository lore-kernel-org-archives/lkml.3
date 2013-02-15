Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161759Ab3BOM5j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:57:39 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:40715 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161361Ab3BOM5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:57:36 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 07/35] mfd: ab8500-debug: Print banks in hex
Date: Fri, 15 Feb 2013 12:56:38 +0000
Message-Id: <1360933026-30325-8-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mattias Wallin <mattias.wallin@stericsson.com>

This patch changes bank prints to use hex value.

Signed-off-by: Mattias Wallin <mattias.wallin@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Reviewed-by: Marcus COOPER <marcus.xm.cooper@stericsson.com>
Reviewed-by: Daniel WILLERUD <daniel.willerud@stericsson.com>
Tested-by: Jonas ABERG <jonas.aberg@stericsson.com>
---
 drivers/mfd/ab8500-debugfs.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index 8078a93..18ff86b 100644
--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -524,19 +524,19 @@ static int ab8500_registers_print(struct device *dev, u32 bank,
 			}
 
 			if (s) {
-				err = seq_printf(s, "  [%u/0x%02X]: 0x%02X\n",
+				err = seq_printf(s, "  [0x%02X/0x%02X]: 0x%02X\n",
 					bank, reg, value);
 				if (err < 0) {
 					dev_err(dev,
-					"seq_printf overflow bank=%d reg=%d\n",
+					"seq_printf overflow bank=0x%02X reg=0x%02X\n",
 						bank, reg);
 					/* Error is not returned here since
 					 * the output is wanted in any case */
 					return 0;
 				}
 			} else {
-				printk(KERN_INFO" [%u/0x%02X]: 0x%02X\n", bank,
-					reg, value);
+				printk(KERN_INFO" [0x%02X/0x%02X]: 0x%02X\n",
+					bank, reg, value);
 			}
 		}
 	}
@@ -550,7 +550,7 @@ static int ab8500_print_bank_registers(struct seq_file *s, void *p)
 
 	seq_printf(s, AB8500_NAME_STRING " register values:\n");
 
-	seq_printf(s, " bank %u:\n", bank);
+	seq_printf(s, " bank 0x%02X:\n", bank);
 
 	ab8500_registers_print(dev, bank, s);
 	return 0;
@@ -578,9 +578,9 @@ static int ab8500_print_all_banks(struct seq_file *s, void *p)
 	seq_printf(s, AB8500_NAME_STRING " register values:\n");
 
 	for (i = 1; i < AB8500_NUM_BANKS; i++) {
-		err = seq_printf(s, " bank %u:\n", i);
+		err = seq_printf(s, " bank 0x%02X:\n", i);
 		if (err < 0)
-			dev_err(dev, "seq_printf overflow, bank=%d\n", i);
+			dev_err(dev, "seq_printf overflow, bank=0x%02X\n", i);
 
 		ab8500_registers_print(dev, i, s);
 	}
@@ -595,7 +595,7 @@ void ab8500_dump_all_banks(struct device *dev)
 	printk(KERN_INFO"ab8500 register values:\n");
 
 	for (i = 1; i < AB8500_NUM_BANKS; i++) {
-		printk(KERN_INFO" bank %u:\n", i);
+		printk(KERN_INFO" bank 0x%02X:\n", i);
 		ab8500_registers_print(dev, i, NULL);
 	}
 }
@@ -629,7 +629,7 @@ static const struct file_operations ab8500_all_banks_fops = {
 
 static int ab8500_bank_print(struct seq_file *s, void *p)
 {
-	return seq_printf(s, "%d\n", debug_bank);
+	return seq_printf(s, "0x%02X\n", debug_bank);
 }
 
 static int ab8500_bank_open(struct inode *inode, struct file *file)
-- 
1.7.10.4

