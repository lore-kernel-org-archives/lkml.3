Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763Ab3IMR3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 13:29:32 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:59942 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751741Ab3IMR3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 13:29:31 -0400
X-Sasl-enc: sO3ZDxezYEH2rOGyH6zXe//X94khPtQ0oKlx8tE8dlL1 1379093370
From: Jon Bernard <jbernard@tuxion.com>
To: gregkh@linuxfoundation.org, andreas.dilger@intel.com, tao.peng@emc.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Jon Bernard <jbernard@tuxion.com>
Subject: [PATCH] Staging: lustre: remove unnecessary braces
Date: Fri, 13 Sep 2013 13:29:30 -0400
Message-Id: <1379093370-77170-1-git-send-email-jbernard@tuxion.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the lvfs_lib.c file that removes unnecessary braces from an
if statement found by the checkpatch.pl tool.

Signed-off-by: Jon Bernard <jbernard@tuxion.com>
---
 drivers/staging/lustre/lustre/lvfs/lvfs_lib.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/lustre/lustre/lvfs/lvfs_lib.c b/drivers/staging/lustre/lustre/lvfs/lvfs_lib.c
index 97a8be2..b21e40c 100644
--- a/drivers/staging/lustre/lustre/lvfs/lvfs_lib.c
+++ b/drivers/staging/lustre/lustre/lvfs/lvfs_lib.c
@@ -154,11 +154,10 @@ int lprocfs_stats_alloc_one(struct lprocfs_stats *stats, unsigned int cpuid)
 				spin_lock(&stats->ls_lock);
 			if (stats->ls_biggest_alloc_num <= cpuid)
 				stats->ls_biggest_alloc_num = cpuid + 1;
-			if (stats->ls_flags & LPROCFS_STATS_FLAG_IRQ_SAFE) {
+			if (stats->ls_flags & LPROCFS_STATS_FLAG_IRQ_SAFE)
 				spin_unlock_irqrestore(&stats->ls_lock, flags);
-			} else {
+			else
 				spin_unlock(&stats->ls_lock);
-			}
 		}
 		/* initialize the ls_percpu[cpuid] non-zero counter */
 		for (i = 0; i < stats->ls_num; ++i) {
-- 
1.8.4

