Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbaCYIWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 04:22:14 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:65291 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbaCYIVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 04:21:50 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, dwmw2@infradead.org, angus.clark@st.com,
        pekon@ti.com
Subject: [RFC 47/47] mtd: nand: stm_nand_bch: catch unsupported calls
Date: Tue, 25 Mar 2014 08:20:04 +0000
Message-Id: <1395735604-26706-48-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
References: <1395735604-26706-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Display a BUG() message and return appropriate/expected value.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/mtd/nand/stm_nand_bch.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/mtd/nand/stm_nand_bch.c b/drivers/mtd/nand/stm_nand_bch.c
index 4103d4f..e732bf3 100644
--- a/drivers/mtd/nand/stm_nand_bch.c
+++ b/drivers/mtd/nand/stm_nand_bch.c
@@ -852,6 +852,31 @@ static void flex_write_buf(struct mtd_info *mtd, const uint8_t *buf, int len)
 	}
 }
 
+/* Catch calls to non-supported functions */
+static uint16_t flex_read_word_bug(struct mtd_info *mtd)
+{
+	BUG();
+	return 0;
+}
+
+static int flex_block_bad_bug(struct mtd_info *mtd, loff_t ofs, int getchip)
+{
+	BUG();
+	return 1;
+}
+
+static int flex_block_markbad_bug(struct mtd_info *mtd, loff_t ofs)
+{
+	BUG();
+	return 1;
+}
+
+int flex_scan_bbt_bug(struct mtd_info *mtd)
+{
+	BUG();
+	return 1;
+}
+
 /*
  * Hamming-FLEX operations (optimised replacements for nand_base.c versions)
  */
@@ -1916,7 +1941,12 @@ static void nandi_set_mtd_defaults(struct nandi_controller *nandi,
 	chip->read_buf = flex_read_buf;
 	chip->write_buf = flex_write_buf;
 
+	chip->read_word = flex_read_word_bug;
+	chip->block_bad = flex_block_bad_bug;
+	chip->block_markbad = flex_block_markbad_bug;
+
 	chip->bbt_options |= NAND_BBT_USE_FLASH;
+	chip->scan_bbt = flex_scan_bbt_bug;
 
 	/* mtd_info */
 	mtd->owner = THIS_MODULE;
-- 
1.8.3.2

