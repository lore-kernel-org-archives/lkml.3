Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbaEVM2n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 08:28:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51293 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755509AbaEVM2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 08:28:41 -0400
Date: Thu, 22 May 2014 05:27:47 -0700
From: tip-bot for Dongsheng Yang <tipbot@zytor.com>
Message-ID: <tip-a9467fa3cd2d5bf39e7cb7d0706d29d7ef4df212@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        keescook@chromium.org, peterz@infradead.org, tglx@linutronix.de,
        yangds.fnst@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        keescook@chromium.org, peterz@infradead.org, tglx@linutronix.de,
        yangds.fnst@cn.fujitsu.com
In-Reply-To: <1399541715-19568-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1399541715-19568-1-git-send-email-yangds.fnst@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Use clamp() and clamp_val()
  to make sys_nice() more readable
Git-Commit-ID: a9467fa3cd2d5bf39e7cb7d0706d29d7ef4df212
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

Commit-ID:  a9467fa3cd2d5bf39e7cb7d0706d29d7ef4df212
Gitweb:     http://git.kernel.org/tip/a9467fa3cd2d5bf39e7cb7d0706d29d7ef4df212
Author:     Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
AuthorDate: Thu, 8 May 2014 18:35:15 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 22 May 2014 11:16:31 +0200

sched: Use clamp() and clamp_val() to make sys_nice() more readable

Suggested-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1399541715-19568-1-git-send-email-yangds.fnst@cn.fujitsu.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 6340c60..f5605b6 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3057,17 +3057,10 @@ SYSCALL_DEFINE1(nice, int, increment)
 	 * We don't have to worry. Conceptually one call occurs first
 	 * and we have a single winner.
 	 */
-	if (increment < -40)
-		increment = -40;
-	if (increment > 40)
-		increment = 40;
-
+	increment = clamp(increment, -NICE_WIDTH, NICE_WIDTH);
 	nice = task_nice(current) + increment;
-	if (nice < MIN_NICE)
-		nice = MIN_NICE;
-	if (nice > MAX_NICE)
-		nice = MAX_NICE;
 
+	nice = clamp_val(nice, MIN_NICE, MAX_NICE);
 	if (increment < 0 && !can_nice(current, nice))
 		return -EPERM;
 
