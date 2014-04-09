Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065AbaDICwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 22:52:37 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:20426 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756572AbaDICwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 22:52:35 -0400
Message-Id: <20140409025232.161960044@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 08 Apr 2014 22:47:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH RT 2/2] rtmutex: Remove duplicate rt_mutex_init()
References: <20140409024700.702797305@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0002-rtmutex-Remove-duplicate-rt_mutex_init.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The rt_mutex_init() macro is the same whether or not
CONFIG_DEBUG_RT_MUTEX is set. Remove the duplicate.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/rtmutex.h | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/include/linux/rtmutex.h b/include/linux/rtmutex.h
index fa18682..f7e79e8 100644
--- a/include/linux/rtmutex.h
+++ b/include/linux/rtmutex.h
@@ -62,25 +62,19 @@ struct hrtimer_sleeper;
 # define __DEBUG_RT_MUTEX_INITIALIZER(mutexname) \
 	, .name = #mutexname, .file = __FILE__, .line = __LINE__
 
-# define rt_mutex_init(mutex)					\
-	do {							\
-		raw_spin_lock_init(&(mutex)->wait_lock);	\
-		__rt_mutex_init(mutex, #mutex);			\
-	} while (0)
-
  extern void rt_mutex_debug_task_free(struct task_struct *tsk);
 #else
 # define __DEBUG_RT_MUTEX_INITIALIZER(mutexname)
 
+# define rt_mutex_debug_task_free(t)			do { } while (0)
+#endif
+
 # define rt_mutex_init(mutex)					\
 	do {							\
 		raw_spin_lock_init(&(mutex)->wait_lock);	\
 		__rt_mutex_init(mutex, #mutex);			\
 	} while (0)
 
-# define rt_mutex_debug_task_free(t)			do { } while (0)
-#endif
-
 #define __RT_MUTEX_INITIALIZER_PLAIN(mutexname) \
 	.wait_lock = __RAW_SPIN_LOCK_UNLOCKED(mutexname.wait_lock) \
 	, .wait_list = PLIST_HEAD_INIT(mutexname.wait_list) \
-- 
1.8.5.3


