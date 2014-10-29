Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933336AbaJ2MwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 08:52:24 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14399 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932887AbaJ2MqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 08:46:17 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tlinder@codeaurora.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH 17/35] UBI: Remove alloc_ai() slab name from parameter list
Date: Wed, 29 Oct 2014 13:45:40 +0100
Message-Id: <1414586758-9972-18-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1414586758-9972-1-git-send-email-richard@nod.at>
References: <1414586758-9972-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is always exactly one ubi_attach_info object allocated,
therefore we don't have to care about the name.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/attach.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/mtd/ubi/attach.c b/drivers/mtd/ubi/attach.c
index d1072bc..9364348 100644
--- a/drivers/mtd/ubi/attach.c
+++ b/drivers/mtd/ubi/attach.c
@@ -1297,7 +1297,7 @@ out_ech:
 	return err;
 }
 
-static struct ubi_attach_info *alloc_ai(const char *slab_name)
+static struct ubi_attach_info *alloc_ai(void)
 {
 	struct ubi_attach_info *ai;
 
@@ -1310,7 +1310,7 @@ static struct ubi_attach_info *alloc_ai(const char *slab_name)
 	INIT_LIST_HEAD(&ai->erase);
 	INIT_LIST_HEAD(&ai->alien);
 	ai->volumes = RB_ROOT;
-	ai->aeb_slab_cache = kmem_cache_create(slab_name,
+	ai->aeb_slab_cache = kmem_cache_create("ubi_aeb_slab_cache",
 					       sizeof(struct ubi_ainf_peb),
 					       0, 0, NULL);
 	if (!ai->aeb_slab_cache) {
@@ -1371,7 +1371,7 @@ static int scan_fast(struct ubi_device *ubi, struct ubi_attach_info **ai)
 		return UBI_NO_FASTMAP;
 
 	destroy_ai(*ai);
-	*ai = alloc_ai("ubi_aeb_slab_cache");
+	*ai = alloc_ai();
 	if (!*ai)
 		return -ENOMEM;
 
@@ -1400,7 +1400,7 @@ int ubi_attach(struct ubi_device *ubi, int force_scan)
 	int err;
 	struct ubi_attach_info *ai;
 
-	ai = alloc_ai("ubi_aeb_slab_cache");
+	ai = alloc_ai();
 	if (!ai)
 		return -ENOMEM;
 
@@ -1418,7 +1418,7 @@ int ubi_attach(struct ubi_device *ubi, int force_scan)
 		if (err > 0) {
 			if (err != UBI_NO_FASTMAP) {
 				destroy_ai(ai);
-				ai = alloc_ai("ubi_aeb_slab_cache2");
+				ai = alloc_ai();
 				if (!ai)
 					return -ENOMEM;
 
@@ -1457,7 +1457,7 @@ int ubi_attach(struct ubi_device *ubi, int force_scan)
 	if (ubi->fm && ubi_dbg_chk_gen(ubi)) {
 		struct ubi_attach_info *scan_ai;
 
-		scan_ai = alloc_ai("ubi_ckh_aeb_slab_cache");
+		scan_ai = alloc_ai();
 		if (!scan_ai) {
 			err = -ENOMEM;
 			goto out_wl;
-- 
1.8.4.5

