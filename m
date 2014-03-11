Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945AbaCKMhT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:37:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35538 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972AbaCKMhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:37:17 -0400
Date: Tue, 11 Mar 2014 05:36:36 -0700
From: tip-bot for Juri Lelli <tipbot@zytor.com>
Message-ID: <tip-d44753b843e093f9e1f2f14806fbe106fff74898@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, juri.lelli@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de, juri.lelli@gmail.com
In-Reply-To: <1393844961-18097-1-git-send-email-juri.lelli@gmail.com>
References: <1393844961-18097-1-git-send-email-juri.lelli@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/deadline: Deny unprivileged users to set/
 change SCHED_DEADLINE policy
Git-Commit-ID: d44753b843e093f9e1f2f14806fbe106fff74898
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d44753b843e093f9e1f2f14806fbe106fff74898
Gitweb:     http://git.kernel.org/tip/d44753b843e093f9e1f2f14806fbe106fff74898
Author:     Juri Lelli <juri.lelli@gmail.com>
AuthorDate: Mon, 3 Mar 2014 12:09:21 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 11 Mar 2014 11:33:46 +0100

sched/deadline: Deny unprivileged users to set/change SCHED_DEADLINE policy

Deny the use of SCHED_DEADLINE policy to unprivileged users.
Even if root users can set the policy for normal users, we
don't want the latter to be able to change their parameters
(safest behavior).

Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1393844961-18097-1-git-send-email-juri.lelli@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 6edbef2..f5c6635 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3338,6 +3338,15 @@ recheck:
 				return -EPERM;
 		}
 
+		 /*
+		  * Can't set/change SCHED_DEADLINE policy at all for now
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
