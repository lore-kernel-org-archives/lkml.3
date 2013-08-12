Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab3HLSzE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 14:55:04 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:35172 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679Ab3HLSzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 14:55:00 -0400
Date: Mon, 12 Aug 2013 20:54:56 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] core/urgent fix
Message-ID: <20130812185456.GA20494@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git core-urgent-for-linus

   HEAD: 85f4896123d0299128f2c95cc40f3b8b01d4b0f6 mutex: Fix w/w mutex deadlock injection

A w/w mutex fixlet.

 Thanks,

	Ingo

------------------>
Maarten Lankhorst (1):
      mutex: Fix w/w mutex deadlock injection


 kernel/mutex.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/mutex.c b/kernel/mutex.c
index ff05f4b..a52ee7bb 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -686,7 +686,7 @@ __ww_mutex_lock(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
 	might_sleep();
 	ret =  __mutex_lock_common(&lock->base, TASK_UNINTERRUPTIBLE,
 				   0, &ctx->dep_map, _RET_IP_, ctx);
-	if (!ret && ctx->acquired > 0)
+	if (!ret && ctx->acquired > 1)
 		return ww_mutex_deadlock_injection(lock, ctx);
 
 	return ret;
@@ -702,7 +702,7 @@ __ww_mutex_lock_interruptible(struct ww_mutex *lock, struct ww_acquire_ctx *ctx)
 	ret = __mutex_lock_common(&lock->base, TASK_INTERRUPTIBLE,
 				  0, &ctx->dep_map, _RET_IP_, ctx);
 
-	if (!ret && ctx->acquired > 0)
+	if (!ret && ctx->acquired > 1)
 		return ww_mutex_deadlock_injection(lock, ctx);
 
 	return ret;
