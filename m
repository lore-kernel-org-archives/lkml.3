Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab3KKWQH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 17:16:07 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:60368 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752311Ab3KKWPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 17:15:54 -0500
Date: Mon, 11 Nov 2013 17:15:46 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        kbuild test robot <fengguang.wu@intel.com>
Subject: [for-next][PATCH] tracing: Add rcu annotation for syscall trace
 descriptors
Message-ID: <20131111171546.30b49fbf@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
for-next

Head SHA1: 3a81a5210b7d33bb6d836b4c4952a54166a336f3


Steven Rostedt (Red Hat) (1):
      tracing: Add rcu annotation for syscall trace descriptors

----
 kernel/trace/trace.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
---------------------------
commit 3a81a5210b7d33bb6d836b4c4952a54166a336f3
Author: Steven Rostedt (Red Hat) <rostedt@goodmis.org>
Date:   Mon Nov 11 11:47:06 2013 -0500

    tracing: Add rcu annotation for syscall trace descriptors
    
    sparse complains about the enter/exit_sysycall_files[] variables being
    dereferenced with rcu_dereference_sched(). The fields need to be
    annotated with __rcu.
    
    Reported-by: kbuild test robot <fengguang.wu@intel.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 11a04d6..7ca1993 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -192,8 +192,8 @@ struct trace_array {
 #ifdef CONFIG_FTRACE_SYSCALLS
 	int			sys_refcount_enter;
 	int			sys_refcount_exit;
-	struct ftrace_event_file *enter_syscall_files[NR_syscalls];
-	struct ftrace_event_file *exit_syscall_files[NR_syscalls];
+	struct ftrace_event_file __rcu *enter_syscall_files[NR_syscalls];
+	struct ftrace_event_file __rcu *exit_syscall_files[NR_syscalls];
 #endif
 	int			stop_count;
 	int			clock_id;
