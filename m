Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753713Ab3CKHO5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 03:14:57 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:26938 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650Ab3CKHOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 03:14:54 -0400
Message-ID: <513D8449.4090003@huawei.com>
Date: Mon, 11 Mar 2013 15:14:17 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 11/13] tracing: export syscall_nr_to_meta function
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently syscall meta table is important for kernel
syscall tracing, even mandatory, external modules may need this
meta info when perform syscall tracing(like ktap), so export it.

Instead of export variable syscalls_metadata, export function
syscall_nr_to_meta is more safe.

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
---
 include/trace/syscall.h       |    2 ++
 kernel/trace/trace_syscalls.c |    3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/trace/syscall.h b/include/trace/syscall.h
index 84bc419..3d88f63 100644
--- a/include/trace/syscall.h
+++ b/include/trace/syscall.h
@@ -31,4 +31,6 @@ struct syscall_metadata {
 	struct ftrace_event_call *exit_event;
 };

+struct syscall_metadata *syscall_nr_to_meta(int nr);
+
 #endif /* _TRACE_SYSCALL_H */
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index d24a84c..63433f9 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -102,13 +102,14 @@ find_syscall_meta(unsigned long syscall)
 	return NULL;
 }

-static struct syscall_metadata *syscall_nr_to_meta(int nr)
+struct syscall_metadata *syscall_nr_to_meta(int nr)
 {
 	if (!syscalls_metadata || nr >= NR_syscalls || nr < 0)
 		return NULL;

 	return syscalls_metadata[nr];
 }
+EXPORT_SYMBOL_GPL(syscall_nr_to_meta);

 static enum print_line_t
 print_syscall_enter(struct trace_iterator *iter, int flags,
-- 
1.7.9.7


