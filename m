Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbaESNKc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:10:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59422 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbaESNK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 09:10:29 -0400
Date: Mon, 19 May 2014 06:09:27 -0700
From: tip-bot for Dongsheng Yang <tipbot@zytor.com>
Message-ID: <tip-418cc9ad0cd4f67c360cdf8f4f00c3b588fb0c78@git.kernel.org>
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
  to make it more readable.
Git-Commit-ID: 418cc9ad0cd4f67c360cdf8f4f00c3b588fb0c78
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

Commit-ID:  418cc9ad0cd4f67c360cdf8f4f00c3b588fb0c78
Gitweb:     http://git.kernel.org/tip/418cc9ad0cd4f67c360cdf8f4f00c3b588fb0c78
Author:     Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
AuthorDate: Thu, 8 May 2014 18:35:15 +0900
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 19 May 2014 22:02:41 +0900

sched: Use clamp() and clamp_val() to make it more readable.

As Kees suggested, I use clamp() function to replace the if and
else branch, making it more readable and modular.

Cc: mingo@redhat.com
Suggested-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1399541715-19568-1-git-send-email-yangds.fnst@cn.fujitsu.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/core.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 354cd5a..10d9b50 100644
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
 
