Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151AbaKERCH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 12:02:07 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:47497 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123AbaKERAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 12:00:42 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, computersforpeace@gmail.com,
        pekon@pek-sem.com, linux-mtd@lists.infradead.org
Subject: [PATCH v4 09/11] mtd: nand: stm_nand_bch: adding BBT header
Date: Wed,  5 Nov 2014 16:59:51 +0000
Message-Id: <1415206793-25670-10-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415206793-25670-1-git-send-email-lee.jones@linaro.org>
References: <1415206793-25670-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This header will be used firstly by the BCH main driver, then the
Bad Block Table (BBT) code which will be added immediately after.
Doing it this way provides the cleanest method of keeping the
patch-set bisectable.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 include/linux/mtd/stm_nand_bbt.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)
 create mode 100644 include/linux/mtd/stm_nand_bbt.h

diff --git a/include/linux/mtd/stm_nand_bbt.h b/include/linux/mtd/stm_nand_bbt.h
new file mode 100644
index 0000000..8f5deaa
--- /dev/null
+++ b/include/linux/mtd/stm_nand_bbt.h
@@ -0,0 +1,22 @@
+#ifndef __LINUX_MTD_STM_BBT_H
+#define __LINUX_MTD_STM_BBT_H
+
+#include <linux/mtd/stm_nand.h>
+
+/* BCH ECC sizes */
+static int bch_ecc_sizes[] = {
+	[BCH_18BIT_ECC] = 32,
+	[BCH_30BIT_ECC] = 54,
+	[BCH_NO_ECC] = 0,
+};
+
+#if IS_ENABLED(CONFIG_MTD_NAND_STM_BCH_BBT)
+extern void nandi_dump_bad_blocks(struct nandi_controller *nandi);
+extern int bch_scan_bbt(struct mtd_info *mtd);
+extern int bch_block_isbad(struct mtd_info *mtd, loff_t offs, int getchip);
+extern int bch_block_markbad(struct mtd_info *mtd, loff_t offs);
+#else
+static inline void nandi_dump_bad_blocks(struct nandi_controller *nandi) {}
+#endif
+
+#endif /* __LINUX_MTD_STM_BBT_H */
-- 
1.9.1

