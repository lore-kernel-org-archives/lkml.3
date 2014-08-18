Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425AbaHRKGE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 06:06:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42488 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbaHRJdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:33:52 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 019/137] tracing: Add TRACE_ITER_PRINTK flag check in __trace_puts/__trace_bputs
Date: Mon, 18 Aug 2014 10:31:20 +0100
Message-Id: <1408354398-10226-20-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>

commit f0160a5a2912267c02cfe692eac955c360de5fdf upstream.

The TRACE_ITER_PRINTK check in __trace_puts/__trace_bputs is missing,
so add it, to be consistent with __trace_printk/__trace_bprintk.
Those functions are all called by the same function: trace_printk().

Link: http://lkml.kernel.org/p/51E7A7D6.8090900@huawei.com

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/trace/trace.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index c75803fba4b9..3ef771112cde 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -436,6 +436,9 @@ int __trace_puts(unsigned long ip, const char *str, int size)
 	int alloc;
 	int pc;
 
+	if (!(trace_flags & TRACE_ITER_PRINTK))
+		return 0;
+
 	pc = preempt_count();
 
 	if (unlikely(tracing_selftest_running || tracing_disabled))
@@ -483,6 +486,9 @@ int __trace_bputs(unsigned long ip, const char *str)
 	int size = sizeof(struct bputs_entry);
 	int pc;
 
+	if (!(trace_flags & TRACE_ITER_PRINTK))
+		return 0;
+
 	pc = preempt_count();
 
 	if (unlikely(tracing_selftest_running || tracing_disabled))
-- 
1.9.1

