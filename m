Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbaCKKLb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 06:11:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:41222 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754763AbaCKKL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 06:11:29 -0400
X-IronPort-AV: E=Sophos;i="4.97,629,1389715200"; 
   d="scan'208";a="9678276"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, joe@perches.com, mingo@kernel.org,
        tglx@linutronix.de, heiko.carstens@de.ibm.com,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 03/17] kernel/sys: Replace opened code implementation with nice_to_rlimit().
Date: Tue, 11 Mar 2014 18:09:11 +0800
Message-Id: <899055f9b6fc82c7c6b824029f49be9ff00d160b.1394532288.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1394532288.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1394532288.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 18:08:33,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/11 18:08:35,
	Serialize complete at 2014/03/11 18:08:35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 kernel/sys.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 61a2ae9..1bfe79a 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -250,7 +250,7 @@ SYSCALL_DEFINE2(getpriority, int, which, int, who)
 		else
 			p = current;
 		if (p) {
-			niceval = 20 - task_nice(p);
+			niceval = nice_to_rlimit(task_nice(p));
 			if (niceval > retval)
 				retval = niceval;
 		}
@@ -261,7 +261,7 @@ SYSCALL_DEFINE2(getpriority, int, which, int, who)
 		else
 			pgrp = task_pgrp(current);
 		do_each_pid_thread(pgrp, PIDTYPE_PGID, p) {
-			niceval = 20 - task_nice(p);
+			niceval = nice_to_rlimit(task_nice(p));
 			if (niceval > retval)
 				retval = niceval;
 		} while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
@@ -277,7 +277,7 @@ SYSCALL_DEFINE2(getpriority, int, which, int, who)
 
 		do_each_thread(g, p) {
 			if (uid_eq(task_uid(p), uid)) {
-				niceval = 20 - task_nice(p);
+				niceval = nice_to_rlimit(task_nice(p));
 				if (niceval > retval)
 					retval = niceval;
 			}
-- 
1.8.2.1

