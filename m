Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302AbbAKPSw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 10:18:52 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:61845 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbbAKPSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 10:18:51 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joseph Qi <joseph.qi@huawei.com>, Xue jiufei <xuejiufei@huawei.com>,
        Alex Chen <alex.chen@huawei.com>, Yiwen Jiang <jiangyiwen@huawei.com>,
        Goldwyn Rodrigues <rgoldwyn@suse.de>,
        Zongxun Wang <wangzongxun@huawei.com>,
        Zhonghua Guo <guozhonghua@h3c.com>, ocfs2-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ocfs2: dlm: dlmdomain: Remove unused function
Date: Sun, 11 Jan 2015 16:21:56 +0100
Message-Id: <1420989716-19115-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the function dlm_joined() that is not used anywhere.

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 fs/ocfs2/dlm/dlmdomain.c |   14 --------------
 fs/ocfs2/dlm/dlmdomain.h |    1 -
 2 files changed, 15 deletions(-)

diff --git a/fs/ocfs2/dlm/dlmdomain.c b/fs/ocfs2/dlm/dlmdomain.c
index 02d315f..348df90 100644
--- a/fs/ocfs2/dlm/dlmdomain.c
+++ b/fs/ocfs2/dlm/dlmdomain.c
@@ -674,20 +674,6 @@ static void dlm_leave_domain(struct dlm_ctxt *dlm)
 	spin_unlock(&dlm->spinlock);
 }
 
-int dlm_joined(struct dlm_ctxt *dlm)
-{
-	int ret = 0;
-
-	spin_lock(&dlm_domain_lock);
-
-	if (dlm->dlm_state == DLM_CTXT_JOINED)
-		ret = 1;
-
-	spin_unlock(&dlm_domain_lock);
-
-	return ret;
-}
-
 int dlm_shutting_down(struct dlm_ctxt *dlm)
 {
 	int ret = 0;
diff --git a/fs/ocfs2/dlm/dlmdomain.h b/fs/ocfs2/dlm/dlmdomain.h
index 2f7f60b..fd6122a 100644
--- a/fs/ocfs2/dlm/dlmdomain.h
+++ b/fs/ocfs2/dlm/dlmdomain.h
@@ -28,7 +28,6 @@
 extern spinlock_t dlm_domain_lock;
 extern struct list_head dlm_domains;
 
-int dlm_joined(struct dlm_ctxt *dlm);
 int dlm_shutting_down(struct dlm_ctxt *dlm);
 void dlm_fire_domain_eviction_callbacks(struct dlm_ctxt *dlm,
 					int node_num);
-- 
1.7.10.4

