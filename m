Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502AbaCTCE0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 22:04:26 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59311 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbaCTCEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 22:04:24 -0400
X-IronPort-AV: E=Sophos;i="4.97,690,1389715200"; 
   d="scan'208";a="9731468"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 03/17 V2] kernel/sys: Replace opened code implementation with nice_to_rlimit().
Date: Thu, 20 Mar 2014 10:02:24 +0800
Message-Id: <1395280944-19643-1-git-send-email-yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/20 10:01:23,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/20 10:01:24,
	Serialize complete at 2014/03/20 10:01:24
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 kernel/sys.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index adaeab6..d412b9e 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -250,7 +250,7 @@ SYSCALL_DEFINE2(getpriority, int, which, int, who)
 			else
 				p = current;
 			if (p) {
-				niceval = 20 - task_nice(p);
+				niceval = nice_to_rlimit(task_nice(p));
 				if (niceval > retval)
 					retval = niceval;
 			}
@@ -261,7 +261,7 @@ SYSCALL_DEFINE2(getpriority, int, which, int, who)
 			else
 				pgrp = task_pgrp(current);
 			do_each_pid_thread(pgrp, PIDTYPE_PGID, p) {
-				niceval = 20 - task_nice(p);
+				niceval = nice_to_rlimit(task_nice(p));
 				if (niceval > retval)
 					retval = niceval;
 			} while_each_pid_thread(pgrp, PIDTYPE_PGID, p);
@@ -277,7 +277,7 @@ SYSCALL_DEFINE2(getpriority, int, which, int, who)
 
 			do_each_thread(g, p) {
 				if (uid_eq(task_uid(p), uid)) {
-					niceval = 20 - task_nice(p);
+					niceval = nice_to_rlimit(task_nice(p));
 					if (niceval > retval)
 						retval = niceval;
 				}
-- 
1.8.2.1

