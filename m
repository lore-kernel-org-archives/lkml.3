Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549Ab3CNH7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 03:59:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:4885 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750988Ab3CNH7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 03:59:18 -0400
X-IronPort-AV: E=Sophos;i="4.84,843,1355068800"; 
   d="scan'208";a="6870985"
From: liguang <lig.fnst@cn.fujitsu.com>
To: viro@zeniv.linux.org.uk, oleg@redhat.com, edumazet@google.com,
        linux-kernel@vger.kernel.org
Cc: liguang <lig.fnst@cn.fujitsu.com>
Subject: [PATCH 2/2] task_work: check callback if it's NULL
Date: Thu, 14 Mar 2013 15:57:45 +0800
Message-Id: <1363247865-3531-2-git-send-email-lig.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1363247865-3531-1-git-send-email-lig.fnst@cn.fujitsu.com>
References: <1363247865-3531-1-git-send-email-lig.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/14 15:57:56,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/14 15:57:56,
	Serialize complete at 2013/03/14 15:57:56
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
---
 kernel/task_work.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/task_work.c b/kernel/task_work.c
index 0bf4258..f458b08 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -75,7 +75,8 @@ void task_work_run(void)
 
 		do {
 			next = work->next;
-			work->func(work);
+			if (unlikely(work->func))
+				work->func(work);
 			work = next;
 			cond_resched();
 		} while (work);
-- 
1.7.2.5

