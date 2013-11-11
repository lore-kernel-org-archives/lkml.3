Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570Ab3KKFD5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 00:03:57 -0500
Received: from mga11.intel.com ([192.55.52.93]:10893 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156Ab3KKFDv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 00:03:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,675,1378882800"; 
   d="scan'208";a="431112259"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH 1/2] tracing: Add __rcu to enter/exit_syscall_files
Date: Sun, 10 Nov 2013 23:03:45 -0600
Message-Id: <5e250e4e8a87071fe6e0b2042fea27f42d63794a.1384145701.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <cover.1384145701.git.tom.zanussi@linux.intel.com>
References: <cover.1384145701.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1384145701.git.tom.zanussi@linux.intel.com>
References: <cover.1384145701.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add __rcu annotation to the contents of enter/exit_syscall_files to
signify that they're protected by rcu and to silence the following
sparse warnings when CONFIG_SPARSE_RCU_POINTER=y:

kernel/trace/trace_syscalls.c:320:23: error: incompatible types in
  comparison expression (different address spaces)
kernel/trace/trace_syscalls.c:368:23: error: incompatible types in
  comparison expression (different address spaces)

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
---
 kernel/trace/trace.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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
-- 
1.8.3.1

