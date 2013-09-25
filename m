Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab3IYQiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 12:38:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40166 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387Ab3IYQis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 12:38:48 -0400
Date: Wed, 25 Sep 2013 09:38:08 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-qfc1el2zvhxiyut4ai99ij4n@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Remove {set,clear}_need_resched
Git-Commit-ID: 3150398626466c6cc626732f60bc901d58f40677
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 25 Sep 2013 09:38:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3150398626466c6cc626732f60bc901d58f40677
Gitweb:     http://git.kernel.org/tip/3150398626466c6cc626732f60bc901d58f40677
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 12 Sep 2013 15:10:31 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 25 Sep 2013 13:53:09 +0200

sched: Remove {set,clear}_need_resched

Preemption semantics are going to change which mandate a change.

All DRM usage sites are already broken and will not be affected (much)
by this change. DRM people are aware and will remove the last few
stragglers.

For now, leave an empty stub that generates a warning, once all users
are gone we can remove this.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: airlied@linux.ie
Cc: daniel.vetter@ffwll.ch
Cc: paulmck@linux.vnet.ibm.com
Link: http://lkml.kernel.org/n/tip-qfc1el2zvhxiyut4ai99ij4n@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/thread_info.h | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index e7e0473..a629e4b 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -104,8 +104,19 @@ static inline int test_ti_thread_flag(struct thread_info *ti, int flag)
 #define test_thread_flag(flag) \
 	test_ti_thread_flag(current_thread_info(), flag)
 
-#define set_need_resched()	set_thread_flag(TIF_NEED_RESCHED)
-#define clear_need_resched()	clear_thread_flag(TIF_NEED_RESCHED)
+static inline __deprecated void set_need_resched(void)
+{
+	/*
+	 * Use of this function in deprecated.
+	 *
+	 * As of this writing there are only a few users in the DRM tree left
+	 * all of which are wrong and can be removed without causing too much
+	 * grief.
+	 *
+	 * The DRM people are aware and are working on removing the last few
+	 * instances.
+	 */
+}
 
 #if defined TIF_RESTORE_SIGMASK && !defined HAVE_SET_RESTORE_SIGMASK
 /*
