Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab3KLTLo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 14:11:44 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:58552 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644Ab3KLTLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 14:11:39 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] mtd: Make mtd_partition.name const
Date: Tue, 12 Nov 2013 20:11:26 +0100
Message-Id: <1384283486-10348-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows to drop a few casts.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/mtd/mtdpart.c          |    2 +-
 drivers/mtd/ofpart.c           |    4 ++--
 include/linux/mtd/partitions.h |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/mtdpart.c b/drivers/mtd/mtdpart.c
index 6e732c3820c1..67a89bb45943 100644
--- a/drivers/mtd/mtdpart.c
+++ b/drivers/mtd/mtdpart.c
@@ -534,7 +534,7 @@ out_register:
 	return slave;
 }
 
-int mtd_add_partition(struct mtd_info *master, char *name,
+int mtd_add_partition(struct mtd_info *master, const char *name,
 		      long long offset, long long length)
 {
 	struct mtd_partition part;
diff --git a/drivers/mtd/ofpart.c b/drivers/mtd/ofpart.c
index d64f8c30945f..f0a708bf9b0e 100644
--- a/drivers/mtd/ofpart.c
+++ b/drivers/mtd/ofpart.c
@@ -81,7 +81,7 @@ static int parse_ofpart_partitions(struct mtd_info *master,
 		partname = of_get_property(pp, "label", &len);
 		if (!partname)
 			partname = of_get_property(pp, "name", &len);
-		(*pparts)[i].name = (char *)partname;
+		(*pparts)[i].name = partname;
 
 		if (of_get_property(pp, "read-only", &len))
 			(*pparts)[i].mask_flags |= MTD_WRITEABLE;
@@ -152,7 +152,7 @@ static int parse_ofoldpart_partitions(struct mtd_info *master,
 		if (names && (plen > 0)) {
 			int len = strlen(names) + 1;
 
-			(*pparts)[i].name = (char *)names;
+			(*pparts)[i].name = names;
 			plen -= len;
 			names += len;
 		} else {
diff --git a/include/linux/mtd/partitions.h b/include/linux/mtd/partitions.h
index 1f8d24bdafda..335ffca10c10 100644
--- a/include/linux/mtd/partitions.h
+++ b/include/linux/mtd/partitions.h
@@ -37,7 +37,7 @@
  */
 
 struct mtd_partition {
-	char *name;			/* identifier string */
+	const char *name;		/* identifier string */
 	uint64_t size;			/* partition size */
 	uint64_t offset;		/* offset within the master MTD space */
 	uint32_t mask_flags;		/* master MTD flags to mask out for this partition */
@@ -80,7 +80,7 @@ extern int register_mtd_parser(struct mtd_part_parser *parser);
 extern int deregister_mtd_parser(struct mtd_part_parser *parser);
 
 int mtd_is_partition(const struct mtd_info *mtd);
-int mtd_add_partition(struct mtd_info *master, char *name,
+int mtd_add_partition(struct mtd_info *master, const char *name,
 		      long long offset, long long length);
 int mtd_del_partition(struct mtd_info *master, int partno);
 uint64_t mtd_get_device_size(const struct mtd_info *mtd);
-- 
1.7.9.5

