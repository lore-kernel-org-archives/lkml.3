Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760889AbaGPD1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 23:27:09 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:55746 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760769AbaGPD0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 23:26:39 -0400
Message-Id: <20140716032637.303492057@goodmis.org>
User-Agent: quilt/0.63-1
Date: Tue, 15 Jul 2014 23:24:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Subject: [PATCH 3/4] tracing: Add TRACE_ITER_PRINTK flag check in
 __trace_puts/__trace_bputs
References: <20140716032455.761976900@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0003-tracing-Add-TRACE_ITER_PRINTK-flag-check-in-__trace_.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>

The TRACE_ITER_PRINTK check in __trace_puts/__trace_bputs is missing,
so add it, to be consistent with __trace_printk/__trace_bprintk.
Those functions are all called by the same function: trace_printk().

Link: http://lkml.kernel.org/p/51E7A7D6.8090900@huawei.com

Cc: stable@vger.kernel.org # 3.11+
Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a6ffc8918dda..bda9621638cc 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -468,6 +468,9 @@ int __trace_puts(unsigned long ip, const char *str, int size)
 	int alloc;
 	int pc;
 
+	if (!(trace_flags & TRACE_ITER_PRINTK))
+		return 0;
+
 	pc = preempt_count();
 
 	if (unlikely(tracing_selftest_running || tracing_disabled))
@@ -515,6 +518,9 @@ int __trace_bputs(unsigned long ip, const char *str)
 	int size = sizeof(struct bputs_entry);
 	int pc;
 
+	if (!(trace_flags & TRACE_ITER_PRINTK))
+		return 0;
+
 	pc = preempt_count();
 
 	if (unlikely(tracing_selftest_running || tracing_disabled))
-- 
2.0.0


