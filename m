Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989AbaL1JOV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 04:14:21 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:50621 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbaL1JMS (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Sun, 28 Dec 2014 04:12:18 -0500
From: Davidlohr Bueso <dave@stgolabs.net>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Davidlohr Bueso <dave@stgolabs.net>, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH 3/8] locking/mutex: Checking the stamp is ww only
Date: Sun, 28 Dec 2014 01:11:18 -0800
Message-Id: <1419757883-4423-4-git-send-email-dave@stgolabs.net>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1419757883-4423-1-git-send-email-dave@stgolabs.net>
References: <1419757883-4423-1-git-send-email-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark it so by renaming mutex_lock_check_stamp().

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 kernel/locking/mutex.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/locking/mutex.c b/kernel/locking/mutex.c
index 2e687a8..3252a7d 100644
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
 
 		if (ww_ctx && ww_ctx->acquired > 0) {
-			ret = __mutex_lock_check_stamp(lock, ww_ctx);
+			ret = __ww_mutex_lock_check_stamp(lock, ww_ctx);
 			if (ret)
 				goto err;
 		}
-- 
2.1.2

