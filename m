Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542Ab3FYDa7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 23:30:59 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:26288 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102Ab3FYDa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 23:30:56 -0400
Message-ID: <51C90ED1.5070209@huawei.com>
Date: Tue, 25 Jun 2013 11:30:25 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2 v3] tracing/uprobes: Support soft-mode disabling
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
index dbbb4a9..d2da3ea 100644
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


