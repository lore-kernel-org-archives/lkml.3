Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541Ab3GDLIz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 07:08:55 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:62587 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756152Ab3GDLIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 07:08:54 -0400
Message-ID: <51D556BB.50400@huawei.com>
Date: Thu, 4 Jul 2013 19:04:27 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2 v6] tracing/uprobes: Support soft-mode disabling
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support soft-mode disabling on uprobe-based dynamic events.
Soft-disabling is just ignoring recording if the soft disabled
flag is set.

Signed-off-by: zhangwei(Jovi) <jovi.zhangwe@huawei.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 kernel/trace/trace_uprobe.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/trace/trace_uprobe.c b/kernel/trace/trace_uprobe.c
index 2fc9931..94f180d 100644
--- a/kernel/trace/trace_uprobe.c
+++ b/kernel/trace/trace_uprobe.c
@@ -530,6 +530,9 @@ static void uprobe_trace_print(struct trace_uprobe *tu,

 	WARN_ON(call != ftrace_file->event_call);

+	if (test_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &ftrace_file->flags))
+		return;
+
 	size = SIZEOF_TRACE_ENTRY(is_ret_probe(tu));
 	event = trace_event_buffer_lock_reserve(&buffer, ftrace_file,
 						call->event.type,
-- 
1.7.9.7


