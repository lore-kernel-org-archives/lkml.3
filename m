Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287AbaGZTkq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:40:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34358 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbaGZTNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:13:19 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3.15 018/109] tracing: Add TRACE_ITER_PRINTK flag check in __trace_puts/__trace_bputs
Date: Sat, 26 Jul 2014 12:01:40 -0700
Message-Id: <20140726190224.383106328@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190223.834037485@linuxfoundation.org>
References: <20140726190223.834037485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>

commit f0160a5a2912267c02cfe692eac955c360de5fdf upstream.

The TRACE_ITER_PRINTK check in __trace_puts/__trace_bputs is missing,
so add it, to be consistent with __trace_printk/__trace_bprintk.
Those functions are all called by the same function: trace_printk().

Link: http://lkml.kernel.org/p/51E7A7D6.8090900@huawei.com

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -468,6 +468,9 @@ int __trace_puts(unsigned long ip, const
 	int alloc;
 	int pc;
 
+	if (!(trace_flags & TRACE_ITER_PRINTK))
+		return 0;
+
 	pc = preempt_count();
 
 	if (unlikely(tracing_selftest_running || tracing_disabled))
@@ -515,6 +518,9 @@ int __trace_bputs(unsigned long ip, cons
 	int size = sizeof(struct bputs_entry);
 	int pc;
 
+	if (!(trace_flags & TRACE_ITER_PRINTK))
+		return 0;
+
 	pc = preempt_count();
 
 	if (unlikely(tracing_selftest_running || tracing_disabled))


