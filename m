Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098AbbANTT3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 14:19:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39784 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbbANTT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 14:19:27 -0500
Date: Wed, 14 Jan 2015 11:18:36 -0800
From: tip-bot for Davidlohr Bueso <tipbot@zytor.com>
Message-ID: <tip-63dc47e956b464e0ed3282f6e70974eebf850180@git.kernel.org>
Cc: torvalds@linux-foundation.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
        dave@stgolabs.net, dbueso@suse.de, linux-kernel@vger.kernel.org
Reply-To: tglx@linutronix.de, dbueso@suse.de, linux-kernel@vger.kernel.org,
        dave@stgolabs.net, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org, hpa@zytor.com, peterz@infradead.org,
        mingo@kernel.org
In-Reply-To: <1420573509-24774-2-git-send-email-dave@stgolabs.net>
References: <1420573509-24774-2-git-send-email-dave@stgolabs.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:locking/core] locking/mutex: Checking the stamp is WW only
Git-Commit-ID: 63dc47e956b464e0ed3282f6e70974eebf850180
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

Commit-ID:  63dc47e956b464e0ed3282f6e70974eebf850180
Gitweb:     http://git.kernel.org/tip/63dc47e956b464e0ed3282f6e70974eebf850180
Author:     Davidlohr Bueso <dave@stgolabs.net>
AuthorDate: Tue, 6 Jan 2015 11:45:04 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 14 Jan 2015 15:07:21 +0100

locking/mutex: Checking the stamp is WW only

Mark it so by renaming __mutex_lock_check_stamp().

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1420573509-24774-2-git-send-email-dave@stgolabs.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/locking/mutex.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index 4541951..b042ea5 100644
--- a/kernel/locking/mutex.c
+++ b/kernel/locking/mutex.c
@@ -469,7 +469,7 @@ void __sched ww_mutex_unlock(struct ww_mutex *lock)
 EXPORT_SYMBOL(ww_mutex_unlock);
 
 static inline int __sched
-__mutex_lock_check_stamp(struct mutex *lock, struct ww_acquire_ctx *ctx)
+__ww_mutex_lock_check_stamp(struct mutex *lock, struct ww_acquire_ctx *ctx)
 {
 	struct ww_mutex *ww = container_of(lock, struct ww_mutex, base);
 	struct ww_acquire_ctx *hold_ctx = ACCESS_ONCE(ww->ctx);
@@ -557,7 +557,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 		}
 
 		if (use_ww_ctx && ww_ctx->acquired > 0) {
-			ret = __mutex_lock_check_stamp(lock, ww_ctx);
+			ret = __ww_mutex_lock_check_stamp(lock, ww_ctx);
 			if (ret)
 				goto err;
 		}
