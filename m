Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbaA2Oes (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 09:34:48 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:40600 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbaA2Oen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 09:34:43 -0500
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
Subject: [RFC PATCH v2 06/14] of: mtd: add NAND timing mode retrieval support
Date: Wed, 29 Jan 2014 15:34:16 +0100
Message-Id: <1391006064-28890-7-git-send-email-b.brezillon.dev@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391006064-28890-1-git-send-email-b.brezillon.dev@gmail.com>
References: <1391006064-28890-1-git-send-email-b.brezillon.dev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a function to retrieve NAND timing mode (ONFI timing mode) from a given
DT node.

Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
---
 drivers/of/of_mtd.c    |   19 +++++++++++++++++++
 include/linux/of_mtd.h |    8 ++++++++
 2 files changed, 27 insertions(+)

diff --git a/drivers/of/of_mtd.c b/drivers/of/of_mtd.c
index e8ced61..63155d4 100644
--- a/drivers/of/of_mtd.c
+++ b/drivers/of/of_mtd.c
@@ -108,3 +108,22 @@ bool of_get_nand_on_flash_bbt(struct device_node *np)
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
+int of_get_nand_onfi_timing_mode(struct device_node *np)
+{
+	int err;
+	u32 mode;
+
+	err = of_property_read_u32(np, "onfi,nand-timing-mode", &mode);
+	if (err)
+		return err;
+
+	return mode;
+}
+EXPORT_SYMBOL_GPL(of_get_nand_onfi_timing_mode);
diff --git a/include/linux/of_mtd.h b/include/linux/of_mtd.h
index 3bd8c3b..eb9fda6 100644
--- a/include/linux/of_mtd.h
+++ b/include/linux/of_mtd.h
@@ -9,6 +9,8 @@
 #ifndef __LINUX_OF_MTD_H
 #define __LINUX_OF_NET_H
 
+#include <linux/mtd/nand.h>
+
 #ifdef CONFIG_OF_MTD
 
 #include <linux/of.h>
@@ -16,6 +18,7 @@ int of_get_nand_ecc_mode(struct device_node *np);
 int of_get_nand_ecc_level(struct device_node *np, u32 *strengh, u32 *blk_size);
 int of_get_nand_bus_width(struct device_node *np);
 bool of_get_nand_on_flash_bbt(struct device_node *np);
+int of_get_nand_onfi_timing_mode(struct device_node *np);
 
 #else /* CONFIG_OF_MTD */
 
@@ -40,6 +43,11 @@ static inline bool of_get_nand_on_flash_bbt(struct device_node *np)
 	return false;
 }
 
+static inline int of_get_nand_onfi_timing_mode(struct device_node *np)
+{
+	return -ENOSYS;
+}
+
 #endif /* CONFIG_OF_MTD */
 
 #endif /* __LINUX_OF_MTD_H */
-- 
1.7.9.5

