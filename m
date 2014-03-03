Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440AbaCCLJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 06:09:39 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:56108 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964AbaCCLJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 06:09:37 -0500
From: Juri Lelli <juri.lelli@gmail.com>
To: mingo@redhat.com, peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, Juri Lelli <juri.lelli@gmail.com>
Subject: [PATCH] sched/deadline: Normal users can't set/change SCHED_DEADLINE policy
Date: Mon,  3 Mar 2014 12:09:21 +0100
Message-Id: <1393844961-18097-1-git-send-email-juri.lelli@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Deny the use of SCHED_DEADLINE policy to unprivileged users.
Even if root users can set the policy for normal users, we
don't want the latter to be able to change their parameters
(safest behavior).

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
---
 kernel/sched/core.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 6edbef2..dbed360 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3338,6 +3338,15 @@ recheck:
 				return -EPERM;
 		}
 
+		 /*
+		  * can't set/change SCHED_DEADLINE policy at all for now
+		  * (safest behavior); in the future we would like to allow
+		  * unprivileged DL tasks to increase their relative deadline
+		  * or reduce their runtime (both ways reducing utilization)
+		  */
+		if (dl_policy(policy))
+			return -EPERM;
+
 		/*
 		 * Treat SCHED_IDLE as nice 20. Only allow a switch to
 		 * SCHED_NORMAL if the RLIMIT_NICE would normally permit it.
-- 
1.7.9.5

