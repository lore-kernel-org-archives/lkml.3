Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149AbaAHOaL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 09:30:11 -0500
Received: from 15.mo3.mail-out.ovh.net ([87.98.150.177]:53622 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756867AbaAHOaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 09:30:05 -0500
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mtd@lists.infradead.org, dev@linux-sunxi.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
Subject: [RFC PATCH 2/9] mtd: nand: define struct nand_timings
Date: Wed,  8 Jan 2014 15:21:57 +0100
Message-Id: <1389190924-26226-3-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389190924-26226-1-git-send-email-b.brezillon@overkiz.com>
References: <1389190924-26226-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 6882063181093959871
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrfedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrfedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define a struct containing the standard NAND timings as described in NAND
datasheets.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 include/linux/mtd/nand.h |   44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
index 9e6c8f9..3dda312 100644
--- a/include/linux/mtd/nand.h
+++ b/include/linux/mtd/nand.h
@@ -805,4 +805,48 @@ static inline bool nand_is_slc(struct nand_chip *chip)
 {
 	return chip->bits_per_cell == 1;
 }
+
+/**
+ * struct nand_timings - NAND chip timing definitions
+ *
+ * This struct defines the timing requirements of a NAND chip.
+ * These informations can be found in every NAND datasheets.
+ *
+ * All fields are optional and depend on the hardware driver requirements
+ */
+struct nand_timings {
+	u32 tCLS_min;
+	u32 tCLH_min;
+	u32 tCS_min;
+	u32 tCH_min;
+	u32 tWP_min;
+	u32 tALS_min;
+	u32 tALH_min;
+	u32 tDS_min;
+	u32 tDH_min;
+	u32 tWC_min;
+	u32 tWH_min;
+	u32 tR_max;
+	u32 tAR_min;
+	u32 tCLR_min;
+	u32 tRR_min;
+	u32 tRP_min;
+	u32 tWB_max;
+	u32 tRC_min;
+	u32 tREA_max;
+	u32 tRHZ_max;
+	u32 tCHZ_max;
+	u32 tRHOH_min;
+	u32 tRLOH_min;
+	u32 tCOH_min;
+	u32 tREH_min;
+	u32 tWHR_min;
+	u32 tRHW_min;
+	u32 tIR_min;
+	u32 tCR_min;
+	u32 tADL_min;
+	u32 tRST_max;
+	u32 tWW_min;
+};
+
 #endif /* __LINUX_MTD_NAND_H */
-- 
1.7.9.5

