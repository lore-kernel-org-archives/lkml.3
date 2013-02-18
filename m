Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722Ab3BRQOU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 11:14:20 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:39550 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755403Ab3BRQOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 11:14:18 -0500
X-IronPort-AV: E=Sophos;i="4.84,688,1355068800"; 
   d="scan'208";a="6724951"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH V2 12/15] workqueue: add extra flags to set_work_worker_and_keep_pending()
Date: Tue, 19 Feb 2013 00:12:13 +0800
Message-Id: <1361203940-6300-13-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1361203940-6300-1-git-send-email-laijs@cn.fujitsu.com>
References: <1361203940-6300-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/19 00:13:39,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/19 00:13:40,
	Serialize complete at 2013/02/19 00:13:40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index cdd5523..ab5c61a 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -544,9 +544,11 @@ static inline unsigned long worker_id_to_data(int worker_id)
 }
 
 static void set_work_worker_and_keep_pending(struct work_struct *work,
-					     int worker_id)
+					     int worker_id,
+					     unsigned long extra_flags)
 {
-	set_work_data(work, worker_id_to_data(worker_id), WORK_STRUCT_PENDING);
+	set_work_data(work, worker_id_to_data(worker_id),
+			extra_flags | WORK_STRUCT_PENDING);
 }
 
 static void set_work_worker_and_clear_pending(struct work_struct *work,
@@ -1157,7 +1159,7 @@ static int try_to_grab_pending(struct work_struct *work, bool is_dwork,
 		else
 			worker_id = WORK_OFFQ_WORKER_NONE;
 
-		set_work_worker_and_keep_pending(work, worker_id);
+		set_work_worker_and_keep_pending(work, worker_id, 0);
 
 		spin_unlock(&pool->lock);
 		return 1;
-- 
1.7.7.6

