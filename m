Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbaIEKkj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 06:40:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45304 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756364AbaIEKki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 06:40:38 -0400
Date: Fri, 5 Sep 2014 03:39:33 -0700
From: tip-bot for Scot Doyle <tipbot@zytor.com>
Message-ID: <tip-6b44f519017b219a12b37173c7eef8dfce2c0100@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, lkml14@scotdoyle.com, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, lkml14@scotdoyle.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <alpine.LNX.2.11.1408241710070.6462@localhost.localdomain>
References: <alpine.LNX.2.11.1408241710070.6462@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/wait: Document timeout corner case
Git-Commit-ID: 6b44f519017b219a12b37173c7eef8dfce2c0100
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

Commit-ID:  6b44f519017b219a12b37173c7eef8dfce2c0100
Gitweb:     http://git.kernel.org/tip/6b44f519017b219a12b37173c7eef8dfce2c0100
Author:     Scot Doyle <lkml14@scotdoyle.com>
AuthorDate: Sun, 24 Aug 2014 17:12:27 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 5 Sep 2014 12:37:10 +0200

sched/wait: Document timeout corner case

The timeout may elapse without 0 being returned, such as when waiting
on an unused queue. Document this possibility.

Signed-off-by: Scot Doyle <lkml14@scotdoyle.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/alpine.LNX.2.11.1408241710070.6462@localhost.localdomain
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/wait.h | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 6fb1ba5..034f6fc 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -280,9 +280,11 @@ do {									\
  * wake_up() has to be called after changing any variable that could
  * change the result of the wait condition.
  *
- * The function returns 0 if the @timeout elapsed, or the remaining
- * jiffies (at least 1) if the @condition evaluated to %true before
- * the @timeout elapsed.
+ * Returns:
+ * 0 if the @condition evaluated to %false after the @timeout elapsed,
+ * 1 if the @condition evaluated to %true after the @timeout elapsed,
+ * or the remaining jiffies (at least 1) if the @condition evaluated
+ * to %true before the @timeout elapsed.
  */
 #define wait_event_timeout(wq, condition, timeout)			\
 ({									\
@@ -363,9 +365,11 @@ do {									\
  * change the result of the wait condition.
  *
  * Returns:
- * 0 if the @timeout elapsed, -%ERESTARTSYS if it was interrupted by
- * a signal, or the remaining jiffies (at least 1) if the @condition
- * evaluated to %true before the @timeout elapsed.
+ * 0 if the @condition evaluated to %false after the @timeout elapsed,
+ * 1 if the @condition evaluated to %true after the @timeout elapsed,
+ * the remaining jiffies (at least 1) if the @condition evaluated
+ * to %true before the @timeout elapsed, or -%ERESTARTSYS if it was
+ * interrupted by a signal.
  */
 #define wait_event_interruptible_timeout(wq, condition, timeout)	\
 ({									\
