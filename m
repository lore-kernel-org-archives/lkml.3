Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932172AbaAHOae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 09:30:34 -0500
Received: from 15.mo3.mail-out.ovh.net ([87.98.150.177]:34373 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932104AbaAHOaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 09:30:07 -0500
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mtd@lists.infradead.org, dev@linux-sunxi.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
Subject: [RFC PATCH 3/9] of: mtd: add NAND timings retrieval support
Date: Wed,  8 Jan 2014 15:21:58 +0100
Message-Id: <1389190924-26226-4-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389190924-26226-1-git-send-email-b.brezillon@overkiz.com>
References: <1389190924-26226-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 6892477755232254144
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

Add a function to retrieve NAND timings from a given DT node.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/of/of_mtd.c    |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/of_mtd.h |    9 +++++++++
 2 files changed, 56 insertions(+)

diff --git a/drivers/of/of_mtd.c b/drivers/of/of_mtd.c
index a27ec94..52e07fd 100644
--- a/drivers/of/of_mtd.c
+++ b/drivers/of/of_mtd.c
@@ -83,3 +83,50 @@ bool of_get_nand_on_flash_bbt(struct device_node *np)
 	return of_property_read_bool(np, "nand-on-flash-bbt");
 }
 EXPORT_SYMBOL_GPL(of_get_nand_on_flash_bbt);
+
+/**
+ * of_get_nand_timings - Get nand timings for the given device_node
+ * @np:	Pointer to the given device_node
+ *
+ * return 0 on success errno other wise
+ */
+int of_get_nand_timings(struct device_node *np, struct nand_timings *timings)
+{
+	memset(timings, 0, sizeof(*timings));
+
+	of_property_read_u32(np, "tCLS-min", &timings->tCLS_min);
+	of_property_read_u32(np, "tCLH-min", &timings->tCLH_min);
+	of_property_read_u32(np, "tCS-min", &timings->tCS_min);
+	of_property_read_u32(np, "tCH-min", &timings->tCH_min);
+	of_property_read_u32(np, "tWP-min", &timings->tWP_min);
+	of_property_read_u32(np, "tALS-min", &timings->tALS_min);
+	of_property_read_u32(np, "tALH-min", &timings->tALH_min);
+	of_property_read_u32(np, "tDS-min", &timings->tDS_min);
+	of_property_read_u32(np, "tDH-min", &timings->tDH_min);
+	of_property_read_u32(np, "tWC-min", &timings->tWC_min);
+	of_property_read_u32(np, "tWH-min", &timings->tWH_min);
+	of_property_read_u32(np, "tR-max", &timings->tR_max);
+	of_property_read_u32(np, "tAR-min", &timings->tAR_min);
+	of_property_read_u32(np, "tCLR-min", &timings->tCLR_min);
+	of_property_read_u32(np, "tRR-min", &timings->tRR_min);
+	of_property_read_u32(np, "tRP-min", &timings->tRP_min);
+	of_property_read_u32(np, "tWB-max", &timings->tWB_max);
+	of_property_read_u32(np, "tRC-min", &timings->tRC_min);
+	of_property_read_u32(np, "tREA-max", &timings->tREA_max);
+	of_property_read_u32(np, "tRHZ-max", &timings->tRHZ_max);
+	of_property_read_u32(np, "tCHZ-max", &timings->tCHZ_max);
+	of_property_read_u32(np, "tRHOH-min", &timings->tRHOH_min);
+	of_property_read_u32(np, "tRLOH-min", &timings->tRLOH_min);
+	of_property_read_u32(np, "tCOH-min", &timings->tCOH_min);
+	of_property_read_u32(np, "tREH-min", &timings->tREH_min);
+	of_property_read_u32(np, "tWHR-min", &timings->tWHR_min);
+	of_property_read_u32(np, "tRHW-min", &timings->tRHW_min);
+	of_property_read_u32(np, "tIR-min", &timings->tIR_min);
+	of_property_read_u32(np, "tCR-min", &timings->tCR_min);
+	of_property_read_u32(np, "tADL-min", &timings->tADL_min);
+	of_property_read_u32(np, "tRST-max", &timings->tRST_max);
+	of_property_read_u32(np, "tWW-min", &timings->tWW_min);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(of_get_nand_timings);
diff --git a/include/linux/of_mtd.h b/include/linux/of_mtd.h
index 6f10e93..ecedb5f 100644
--- a/include/linux/of_mtd.h
+++ b/include/linux/of_mtd.h
@@ -9,12 +9,15 @@
 #ifndef __LINUX_OF_MTD_H
 #define __LINUX_OF_NET_H
 
+#include <linux/mtd/nand.h>
+
 #ifdef CONFIG_OF_MTD
 
 #include <linux/of.h>
 int of_get_nand_ecc_mode(struct device_node *np);
 int of_get_nand_bus_width(struct device_node *np);
 bool of_get_nand_on_flash_bbt(struct device_node *np);
+int of_get_nand_timings(struct device_node *np, struct nand_timings *timings);
 
 #else /* CONFIG_OF_MTD */
 
@@ -33,6 +36,12 @@ static inline bool of_get_nand_on_flash_bbt(struct device_node *np)
 	return false;
 }
 
+static inline int of_get_nand_timings(struct device_node *np,
+				      struct nand_timings *timings)
+{
+	return -ENOSYS;
+}
+
 #endif /* CONFIG_OF_MTD */
 
 #endif /* __LINUX_OF_MTD_H */
-- 
1.7.9.5

