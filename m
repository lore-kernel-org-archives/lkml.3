Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760956AbaGEKs2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 06:48:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58190 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755638AbaGEKsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 06:48:24 -0400
Date: Sat, 5 Jul 2014 03:47:23 -0700
From: tip-bot for Jason Low <tipbot@zytor.com>
Message-ID: <tip-0c3c0f0d6e56422cef60a33726d062e9923005c3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, jason.low2@hp.com,
        tglx@linutronix.de, davidlohr@hp.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, jason.low2@hp.com,
        tglx@linutronix.de, davidlohr@hp.com
In-Reply-To: <1402511843-4721-2-git-send-email-jason.low2@hp.com>
References: <1402511843-4721-2-git-send-email-jason.low2@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] locking/mutexes:
  Correct documentation on mutex optimistic spinning
Git-Commit-ID: 0c3c0f0d6e56422cef60a33726d062e9923005c3
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

Commit-ID:  0c3c0f0d6e56422cef60a33726d062e9923005c3
Gitweb:     http://git.kernel.org/tip/0c3c0f0d6e56422cef60a33726d062e9923005c3
Author:     Jason Low <jason.low2@hp.com>
AuthorDate: Wed, 11 Jun 2014 11:37:20 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 5 Jul 2014 11:25:41 +0200

locking/mutexes: Correct documentation on mutex optimistic spinning

The mutex optimistic spinning documentation states that we spin for
acquisition when we find that there are no pending waiters. However,
in actuality, whether or not there are waiters for the mutex doesn't
determine if we will spin for it.

This patch removes that statement and also adds a comment which
mentions that we spin for the mutex while we don't need to reschedule.

Signed-off-by: Jason Low <jason.low2@hp.com>
Acked-by: Davidlohr Bueso <davidlohr@hp.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: akpm@linux-foundation.org
Cc: tim.c.chen@linux.intel.com
Cc: paulmck@linux.vnet.ibm.com
Cc: rostedt@goodmis.org
Cc: Waiman.Long@hp.com
Cc: scott.norton@hp.com
Cc: aswin@hp.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1402511843-4721-2-git-send-email-jason.low2@hp.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/locking/mutex.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index bc73d33..dd26bf6de 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -388,12 +388,10 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	/*
 	 * Optimistic spinning.
 	 *
-	 * We try to spin for acquisition when we find that there are no
-	 * pending waiters and the lock owner is currently running on a
-	 * (different) CPU.
-	 *
-	 * The rationale is that if the lock owner is running, it is likely to
-	 * release the lock soon.
+	 * We try to spin for acquisition when we find that the lock owner
+	 * is currently running on a (different) CPU and while we don't
+	 * need to reschedule. The rationale is that if the lock owner is
+	 * running, it is likely to release the lock soon.
 	 *
 	 * Since this needs the lock owner, and this mutex implementation
 	 * doesn't track the owner atomically in the lock field, we need to
