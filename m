Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934483AbaFIXKE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 19:10:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56773 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933509AbaFIWpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:45:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 3.14 32/78] sched: Disallow sched_attr::sched_policy < 0
Date: Mon,  9 Jun 2014 15:48:12 -0700
Message-Id: <20140609224814.372439472@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140609224813.282275135@linuxfoundation.org>
References: <20140609224813.282275135@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

commit dbdb22754fde671dc93d2fae06f8be113d47f2fb upstream.

The scheduler uses policy=-1 to preserve the current policy state to
implement sys_sched_setparam(), this got exposed to userspace by
accident through sys_sched_setattr(), cure this.

Reported-by: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140509085311.GJ30445@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -3683,6 +3683,9 @@ SYSCALL_DEFINE3(sched_setattr, pid_t, pi
 	if (sched_copy_attr(uattr, &attr))
 		return -EFAULT;
 
+	if (attr.sched_policy < 0)
+		return -EINVAL;
+
 	rcu_read_lock();
 	retval = -ESRCH;
 	p = find_process_by_pid(pid);


