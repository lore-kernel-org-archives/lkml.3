Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbaG0HgO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 03:36:14 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14385 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbaG0HgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 03:36:13 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH] UBI: ubi_wl_flush(): Use list_for_each_entry_safe()
Date: Sun, 27 Jul 2014 09:35:48 +0200
Message-Id: <1406446548-5790-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the _safe variant because we're iterating over
a list where items get deleted and freed.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/wl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 0f3425d..20f491713 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -1718,12 +1718,12 @@ int ubi_wl_flush(struct ubi_device *ubi, int vol_id, int lnum)
 	       vol_id, lnum, ubi->works_count);
 
 	while (found) {
-		struct ubi_work *wrk;
+		struct ubi_work *wrk, *tmp;
 		found = 0;
 
 		down_read(&ubi->work_sem);
 		spin_lock(&ubi->wl_lock);
-		list_for_each_entry(wrk, &ubi->works, list) {
+		list_for_each_entry_safe(wrk, tmp, &ubi->works, list) {
 			if ((vol_id == UBI_ALL || wrk->vol_id == vol_id) &&
 			    (lnum == UBI_ALL || wrk->lnum == lnum)) {
 				list_del(&wrk->list);
-- 
2.0.1

