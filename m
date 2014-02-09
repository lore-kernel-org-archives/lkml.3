Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861AbaBIN2l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 08:28:41 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:34285 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbaBIN2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 08:28:39 -0500
Date: Sun, 9 Feb 2014 18:58:34 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Andi Kleen <ak@linux.intel.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Dario Faggioli <raistlin@linux.it>,
        Michal Simek <michal.simek@xilinx.com>, josh@joshtriplett.org
Subject: [PATCH 19/21] fs: Add prototype declaration to header file
 include/linux/syscalls.h
Message-ID: <71025cb48e277e15705eb5645228a4857f729234.1391949868.git.rashika.kheria@gmail.com>
References: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add prototype declaration to header file include/linux/syscalls.h
because it is used by more than one file.

This eliminates the following warning in quota/compat.c:
fs/quota/compat.c:43:17: warning: no previous prototype for ‘sys32_quotactl’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 include/linux/syscalls.h |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 40ed9e9..1f109ea 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -198,6 +198,11 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	}								\
 	static inline long SYSC##name(__MAP(x,__SC_DECL,__VA_ARGS__))
 
+#ifdef CONFIG_QUOTACTL_COMPAT
+asmlinkage long sys32_quotactl(unsigned int cmd, const char __user *special,
+			       qid_t id, void __user *addr);
+#endif
+
 asmlinkage long sys_time(time_t __user *tloc);
 asmlinkage long sys_stime(time_t __user *tptr);
 asmlinkage long sys_gettimeofday(struct timeval __user *tv,
-- 
1.7.9.5

