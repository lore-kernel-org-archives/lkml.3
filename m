Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753771AbaIWGEB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 02:04:01 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:36569 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbaIWGD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 02:03:59 -0400
Message-ID: <54210D3F.2090409@huawei.com>
Date: Tue, 23 Sep 2014 14:03:43 +0800
From: Zefan Li <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Miao Xie <miaox@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>, Kees Cook <keescook@chromium.org>
Subject: [PATCH v2 1/3] sched: fix confusing PFA_NO_NEW_PRIVS constant
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

Commit 1d4457f99928 ("sched: move no_new_privs into new atomic flags")
defined PFA_NO_NEW_PRIVS as hexadecimal value, but it is confusing
because it is used as bit number. Redefine it as decimal bit number.

Note this changes the bit position of PFA_NOW_NEW_PRIVS from 1 to 0.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Kees Cook <keescook@chromium.org>
[ lizf: slightly modified subject and changelog ]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 include/linux/sched.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5c2c885..4557765 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1957,7 +1957,7 @@ static inline void memalloc_noio_restore(unsigned int flags)
 }
 
 /* Per-process atomic flags. */
-#define PFA_NO_NEW_PRIVS 0x00000001	/* May not gain new privileges. */
+#define PFA_NO_NEW_PRIVS 0	/* May not gain new privileges. */
 
 static inline bool task_no_new_privs(struct task_struct *p)
 {
-- 
1.8.0.2

