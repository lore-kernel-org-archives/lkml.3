Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab3LCOFW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:05:22 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:51631 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296Ab3LCOFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:05:09 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Dmitry Eremin <dmitry.eremin@intel.com>,
        Ned Bass <bass6@llnl.gov>, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH v3 14/15] staging/lustre/obdclass: remove unuse variables from lprocfs_stats_collect/clear
Date: Tue,  3 Dec 2013 21:58:52 +0800
Message-Id: <1386079133-6459-15-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386079133-6459-1-git-send-email-bergwolf@gmail.com>
References: <1386079133-6459-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Eremin <dmitry.eremin@intel.com>

This is only part of the original Lustre tree commit splitted to follow the
"one thing per patch" rule.

Lustre-change: http://review.whamcloud.com/6139
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3204
Signed-off-by: Dmitry Eremin <dmitry.eremin@intel.com>
Signed-off-by: Ned Bass <bass6@llnl.gov>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/lustre/obdclass/lprocfs_status.c        |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
index 0f0750b..8828419 100644
--- a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
+++ b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
@@ -420,7 +420,6 @@ void lprocfs_stats_collect(struct lprocfs_stats *stats, int idx,
 {
 	unsigned int			num_entry;
 	struct lprocfs_counter		*percpu_cntr;
-	struct lprocfs_counter_header	*cntr_header;
 	int				i;
 	unsigned long			flags = 0;
 
@@ -439,7 +438,6 @@ void lprocfs_stats_collect(struct lprocfs_stats *stats, int idx,
 	for (i = 0; i < num_entry; i++) {
 		if (stats->ls_percpu[i] == NULL)
 			continue;
-		cntr_header = &stats->ls_cnt_header[idx];
 		percpu_cntr = lprocfs_stats_counter_get(stats, i, idx);
 
 		cnt->lc_count += percpu_cntr->lc_count;
@@ -999,7 +997,6 @@ EXPORT_SYMBOL(lprocfs_free_stats);
 void lprocfs_clear_stats(struct lprocfs_stats *stats)
 {
 	struct lprocfs_counter		*percpu_cntr;
-	struct lprocfs_counter_header	*header;
 	int				i;
 	int				j;
 	unsigned int			num_entry;
@@ -1011,7 +1008,6 @@ void lprocfs_clear_stats(struct lprocfs_stats *stats)
 		if (stats->ls_percpu[i] == NULL)
 			continue;
 		for (j = 0; j < stats->ls_num; j++) {
-			header = &stats->ls_cnt_header[j];
 			percpu_cntr = lprocfs_stats_counter_get(stats, i, j);
 			percpu_cntr->lc_count		= 0;
 			percpu_cntr->lc_min		= LC_MIN_INIT;
-- 
1.7.9.5

