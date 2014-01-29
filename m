Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbaA2Oem (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 09:34:42 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:36809 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645AbaA2Oej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 09:34:39 -0500
From: Boris BREZILLON <b.brezillon.dev@gmail.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: Boris BREZILLON <b.brezillon.dev@gmail.com>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
        dev@linux-sunxi.org
Subject: =?UTF-8?q?=5BRFC=20PATCH=20v2=2004/14=5D=20mtd=3A=20nand=3A=20define=20struct=20nand=5Ftimings?=
Date: Wed, 29 Jan 2014 15:34:14 +0100
Message-Id: <1391006064-28890-5-git-send-email-b.brezillon.dev@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391006064-28890-1-git-send-email-b.brezillon.dev@gmail.com>
References: <1391006064-28890-1-git-send-email-b.brezillon.dev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define a struct containing the standard NAND timings as described in NAND
datasheets.

Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
---
 include/linux/mtd/nand.h |   49 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index 9e6c8f9..67f0829 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -805,4 +805,53 @@ static inline bool nand_is_slc(struct nand_chip *chip)
 {
 	return chip->bits_per_cell == 1;
 }
+
+/**
+ * struct nand_sdr_timings - SDR NAND chip timings
+ *
+ * This struct defines the timing requirements of a SDR NAND chip.
+ * These informations can be found in every NAND datasheets and the timings
+ * meaning are described in the ONFI specifications:
+ * www.onfi.org/~/media/ONFI/specs/onfi_3_1_spec.pdf‎ (chapter 4.15 Timing
+ * Parameters)
+ *
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
+
 #endif /* __LINUX_MTD_NAND_H */
-- 
1.7.9.5

