Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005Ab3GRIcg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 04:32:36 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:12534 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089Ab3GRIce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 04:32:34 -0400
Message-ID: <51E7A7D6.8090900@huawei.com>
Date: Thu, 18 Jul 2013 16:31:18 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] tracing: add TRACE_ITER_PRINTK flag check in __trace_puts/__trace_bputs
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There missed TRACE_ITER_PRINTK check in __trace_puts/__trace_bputs,
so add it, to constant with __trace_printk/__trace_bprintk,
those functions mainly called by same function: trace_printk.

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
---
 kernel/trace/trace.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 4d70cc5..41340c3 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -365,6 +365,9 @@ int __trace_puts(unsigned long ip, const char *str, int size)
 	int alloc;
 	int pc;

+	if (!(trace_flags & TRACE_ITER_PRINTK))
+		return 0;
+
 	pc = preempt_count();

 	alloc = sizeof(*entry) + size + 2; /* possible \n added */
@@ -409,6 +412,9 @@ int __trace_bputs(unsigned long ip, const char *str)
 	int size = sizeof(struct bputs_entry);
 	int pc;

+	if (!(trace_flags & TRACE_ITER_PRINTK))
+		return 0;
+
 	pc = preempt_count();

 	local_save_flags(irq_flags);
-- 
1.7.9.7


