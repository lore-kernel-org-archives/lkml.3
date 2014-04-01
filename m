Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821AbaDAICV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 04:02:21 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:56112 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbaDAICP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 04:02:15 -0400
From: Tanya Brokhman <tlinder@codeaurora.org>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, Tanya Brokhman <tlinder@codeaurora.org>,
        linux-kernel@vger.kernel.org (open list)
Subject: [RFC/PATCH] mtd: ubi: Fix ubi free PEBs count calculation
Date: Tue,  1 Apr 2014 11:02:07 +0300
Message-Id: <1396339327-16090-1-git-send-email-tlinder@codeaurora.org>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ubi->free_count should be updated with every insert/remove to/from
the ubi->free list.

Signed-off-by: Tanya Brokhman <tlinder@codeaurora.org>

diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 9a36f78..ca74d19 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -690,6 +690,8 @@ static struct ubi_wl_entry *get_peb_for_wl(struct ubi_device *ubi)
 
 	e = find_wl_entry(ubi, &ubi->free, WL_FREE_MAX_DIFF);
 	self_check_in_wl_tree(ubi, e, &ubi->free);
+	ubi->free_count--;
+	ubi_assert(ubi->free_count >= 0);
 	rb_erase(&e->u.rb, &ubi->free);
 
 	return e;
@@ -1090,6 +1092,7 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
 
 			/* Give the unused PEB back */
 			wl_tree_add(e2, &ubi->free);
+			ubi->free_count++;
 			goto out_cancel;
 		}
 		self_check_in_wl_tree(ubi, e1, &ubi->used);
-- 
1.7.6
-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundat

