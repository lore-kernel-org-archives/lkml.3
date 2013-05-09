Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572Ab3EIGIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 02:08:34 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:58688 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab3EIGG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 02:06:26 -0400
From: Francis Deslauriers <fdeslaur@gmail.com>
To: linux-mm@kvack.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, rostedt@goodmis.org, fweisbec@gmail.com
Cc: raphael.beamonte@gmail.com, mathieu.desnoyers@efficios.com,
        linux-kernel@vger.kernel.org, Francis Deslauriers <fdeslaur@gmail.com>
Subject: [page fault tracepoint 1/2] Add page fault trace event definitions
Date: Thu,  9 May 2013 02:05:19 -0400
Message-Id: <1368079520-11015-1-git-send-email-fdeslaur@gmail.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add page_fault_entry and page_fault_exit event definitions. It will
allow each architecture to instrument their page faults.

Signed-off-by: Francis Deslauriers <fdeslaur@gmail.com>
Reviewed-by: Raphaël Beamonte <raphael.beamonte@gmail.com>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
---
 include/trace/events/fault.h |   51 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)
 create mode 100644 include/trace/events/fault.h

diff --git a/include/trace/events/fault.h b/include/trace/events/fault.h
new file mode 100644
index 0000000..522ddee
--- /dev/null
+++ b/include/trace/events/fault.h
@@ -0,0 +1,51 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM fault
+
+#if !defined(_TRACE_FAULT_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_FAULT_H
+
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(page_fault_entry,
+
+	TP_PROTO(struct pt_regs *regs, unsigned long address,
+					int write_access),
+
+	TP_ARGS(regs, address, write_access),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	ip	)
+		__field(	unsigned long,	addr	)
+		__field(	uint8_t,	write	)
+	),
+
+	TP_fast_assign(
+		__entry->ip	= regs ? instruction_pointer(regs) : 0UL;
+		__entry->addr	= address;
+		__entry->write	= !!write_access;
+	),
+
+	TP_printk("ip=%lu addr=%lu write_access=%d",
+		__entry->ip, __entry->addr, __entry->write)
+);
+
+TRACE_EVENT(page_fault_exit,
+
+	TP_PROTO(int result),
+
+	TP_ARGS(result),
+
+	TP_STRUCT__entry(
+		__field(	int,	res	)
+	),
+
+	TP_fast_assign(
+		__entry->res	= result;
+	),
+
+	TP_printk("result=%d", __entry->res)
+);
+
+#endif /* _TRACE_FAULT_H */
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
1.7.10.4

