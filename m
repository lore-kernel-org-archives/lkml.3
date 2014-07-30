Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbaG3Mhx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:37:53 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36674 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752794AbaG3MP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:27 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 22/94] tracing: Add TRACE_ITER_PRINTK flag check in __trace_puts/__trace_bputs
Date: Wed, 30 Jul 2014 14:14:11 +0200
Message-Id: <e12331d98e5726a6a0597eac8853d9408bae5a12.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit f0160a5a2912267c02cfe692eac955c360de5fdf upstream.

The TRACE_ITER_PRINTK check in __trace_puts/__trace_bputs is missing,
so add it, to be consistent with __trace_printk/__trace_bprintk.
Those functions are all called by the same function: trace_printk().

Link: http://lkml.kernel.org/p/51E7A7D6.8090900@huawei.com

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 kernel/trace/trace.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 952cde4d4e3c..b7566fe4d607 100644
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
2.0.1

