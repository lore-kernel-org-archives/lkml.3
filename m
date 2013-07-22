Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932799Ab3GVQLm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:11:42 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:33444 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932634Ab3GVQLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:11:39 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        Sebastien Buisson <sebastien.buisson@bull.net>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 22/48] staging/lustre: fix 'code maintainability' errors
Date: Tue, 23 Jul 2013 00:06:43 +0800
Message-Id: <1374509230-3324-23-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastien Buisson <sebastien.buisson@bull.net>

Fix 'code maintainability' issues found by Coverity version 6.5.1:
Unused pointer value (UNUSED_VALUE)
Pointer returned by function is never used.
Missing varargs init or cleanup (VARARGS)
va_end was not called for variable.

Signed-off-by: Sebastien Buisson <sebastien.buisson@bull.net>
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3107
Lustre-change: http://review.whamcloud.com/5944
Reviewed-by: Dmitry Eremin <dmitry.eremin@intel.com>
Reviewed-by: John Hammond <johnlockwoodhammond@gmail.com>
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../lustre/lustre/obdclass/lprocfs_jobstats.c      |    2 --
 .../staging/lustre/lustre/ptlrpc/pack_generic.c    |    1 +
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/lprocfs_jobstats.c b/drivers/staging/lustre/lustre/obdclass/lprocfs_jobstats.c
index e2d57fe..7f6072c 100644
--- a/drivers/staging/lustre/lustre/obdclass/lprocfs_jobstats.c
+++ b/drivers/staging/lustre/lustre/obdclass/lprocfs_jobstats.c
@@ -366,7 +366,6 @@ static int lprocfs_jobstats_seq_show(struct seq_file *p, void *v)
 	struct job_stat			*job = v;
 	struct lprocfs_stats		*s;
 	struct lprocfs_counter		ret;
-	struct lprocfs_counter		*cntr;
 	struct lprocfs_counter_header	*cntr_header;
 	int				i;
 
@@ -380,7 +379,6 @@ static int lprocfs_jobstats_seq_show(struct seq_file *p, void *v)
 
 	s = job->js_stats;
 	for (i = 0; i < s->ls_num; i++) {
-		cntr = lprocfs_stats_counter_get(s, 0, i);
 		cntr_header = &s->ls_cnt_header[i];
 		lprocfs_stats_collect(s, i, &ret);
 
diff --git a/drivers/staging/lustre/lustre/ptlrpc/pack_generic.c b/drivers/staging/lustre/lustre/ptlrpc/pack_generic.c
index be246d4..ffff648 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/pack_generic.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/pack_generic.c
@@ -2462,6 +2462,7 @@ void _debug_req(struct ptlrpc_request *req,
 			   rep_ok ? lustre_msg_get_flags(req->rq_repmsg) : -1,
 			   req->rq_status,
 			   rep_ok ? lustre_msg_get_status(req->rq_repmsg) : -1);
+	va_end(args);
 }
 EXPORT_SYMBOL(_debug_req);
 
-- 
1.7.9.5

