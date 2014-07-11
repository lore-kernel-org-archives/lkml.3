Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbaGKHz5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 03:55:57 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33559 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752885AbaGKHz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 03:55:56 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH 1/2] mtd: nand: define struct nand_timings
Date: Fri, 11 Jul 2014 09:49:41 +0200
Message-Id: <1405064982-11456-2-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405064982-11456-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1405064982-11456-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define a struct containing the standard NAND timings as described in NAND
datasheets.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 include/linux/mtd/nand.h | 49 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index 2f0af28..a3a45f2 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -947,4 +947,53 @@ static inline int jedec_feature(struct nand_chip *chip)
 	return chip->jedec_version ? le16_to_cpu(chip->jedec_params.features)
 		: 0;
 }
+
+/**
+ * struct nand_sdr_timings - SDR NAND chip timings
+ *
+ * This struct defines the timing requirements of a SDR NAND chip.
+ * These informations can be found in every NAND datasheets and the timings
+ * meaning are described in the ONFI specifications:
+ * www.onfi.org/~/media/ONFI/specs/onfi_3_1_spec.pdf (chapter 4.15 Timing
+ * Parameters)
+ *
+ * All these timings are expressed in picoseconds.
+ */
+
+struct nand_sdr_timings {
+	u32 tALH_min;
+	u32 tADL_min;
+	u32 tALS_min;
+	u32 tAR_min;
+	u32 tCEA_max;
+	u32 tCEH_min;
+	u32 tCH_min;
+	u32 tCHZ_max;
+	u32 tCLH_min;
+	u32 tCLR_min;
+	u32 tCLS_min;
+	u32 tCOH_min;
+	u32 tCS_min;
+	u32 tDH_min;
+	u32 tDS_min;
+	u32 tFEAT_max;
+	u32 tIR_min;
+	u32 tITC_max;
+	u32 tRC_min;
+	u32 tREA_max;
+	u32 tREH_min;
+	u32 tRHOH_min;
+	u32 tRHW_min;
+	u32 tRHZ_max;
+	u32 tRLOH_min;
+	u32 tRP_min;
+	u32 tRR_min;
+	u64 tRST_max;
+	u32 tWB_max;
+	u32 tWC_min;
+	u32 tWH_min;
+	u32 tWHR_min;
+	u32 tWP_min;
+	u32 tWW_min;
+};
 #endif /* __LINUX_MTD_NAND_H */
-- 
1.8.3.2

