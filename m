Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344AbaK3MT7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 07:19:59 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:14385 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbaK3MT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 07:19:58 -0500
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 2/6] UBI: Add accessor functions for WL data structures
Date: Sun, 30 Nov 2014 13:19:44 +0100
Message-Id: <1417349988-9238-3-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1417349988-9238-1-git-send-email-richard@nod.at>
References: <1417349988-9238-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fastmap need access to various WL data structures as
fastmap tightly depends on WL.
To make the access less invasive add accessor functions.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/ubi.h | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index d3ad165..4fe33fe 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -897,6 +897,42 @@ static inline int ubiblock_remove(struct ubi_volume_info *vi)
 }
 #endif
 
+/*
+ * ubi_for_each_free_peb - walk the UBI free RB tree.
+ * @ubi: UBI device description object
+ * @e: a pointer to a ubi_wl_entry to use as cursor
+ * @pos: a pointer to RB-tree entry type to use as a loop counter
+ */
+#define ubi_for_each_free_peb(ubi, e, tmp_rb)	\
+	ubi_rb_for_each_entry((tmp_rb), (e), &(ubi)->free, u.rb)
+
+/*
+ * ubi_for_each_used_peb - walk the UBI used RB tree.
+ * @ubi: UBI device description object
+ * @e: a pointer to a ubi_wl_entry to use as cursor
+ * @pos: a pointer to RB-tree entry type to use as a loop counter
+ */
+#define ubi_for_each_used_peb(ubi, e, tmp_rb)	\
+	ubi_rb_for_each_entry((tmp_rb), (e), &(ubi)->used, u.rb)
+
+/*
+ * ubi_for_each_scub_peb - walk the UBI scub RB tree.
+ * @ubi: UBI device description object
+ * @e: a pointer to a ubi_wl_entry to use as cursor
+ * @pos: a pointer to RB-tree entry type to use as a loop counter
+ */
+#define ubi_for_each_scrub_peb(ubi, e, tmp_rb)	\
+	ubi_rb_for_each_entry((tmp_rb), (e), &(ubi)->scrub, u.rb)
+
+/*
+ * ubi_for_each_protected_peb - walk the UBI protection queue.
+ * @ubi: UBI device description object
+ * @i: a integer used as counter
+ * @e: a pointer to a ubi_wl_entry to use as cursor
+ */
+#define ubi_for_each_protected_peb(ubi, i, e)	\
+	for ((i) = 0; (i) < UBI_PROT_QUEUE_LEN; (i)++)	\
+		list_for_each_entry((e), &(ubi->pq[(i)]), u.list)
 
 /*
  * ubi_rb_for_each_entry - walk an RB-tree.
-- 
1.8.4.5

