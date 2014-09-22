Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbaIVDw4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 23:52:56 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:64908 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbaIVDwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 23:52:54 -0400
Message-ID: <541F9CD4.5040407@huawei.com>
Date: Mon, 22 Sep 2014 11:51:48 +0800
From: Zefan Li <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        <keescook@chromium.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH 2/3] sched: add a macro to define bitops for task atomic flags
References: <541F9C96.10705@huawei.com>
In-Reply-To: <541F9C96.10705@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will simplify code when we add new flags.

Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 include/linux/sched.h | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4557765..04a2ae2 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1959,15 +1959,17 @@ static inline void memalloc_noio_restore(unsigned int flags)
 /* Per-process atomic flags. */
 #define PFA_NO_NEW_PRIVS 0	/* May not gain new privileges. */
 
-static inline bool task_no_new_privs(struct task_struct *p)
-{
-	return test_bit(PFA_NO_NEW_PRIVS, &p->atomic_flags);
-}
-
-static inline void task_set_no_new_privs(struct task_struct *p)
-{
-	set_bit(PFA_NO_NEW_PRIVS, &p->atomic_flags);
-}
+#define TASK_PFA_BITOPS(name, func)				\
+static inline bool task_##func(struct task_struct *p)		\
+{ return test_bit(PFA_##name, &p->atomic_flags); }		\
+								\
+static inline void task_set_##func(struct task_struct *p)	\
+{ set_bit(PFA_##name, &p->atomic_flags); }			\
+								\
+static inline void task_clear_##func(struct task_struct *p)	\
+{ clear_bit(PFA_##name, &p->atomic_flags); }
+
+TASK_PFA_BITOPS(NO_NEW_PRIVS, no_new_privs)
 
 /*
  * task->jobctl flags
-- 
1.8.0.2


