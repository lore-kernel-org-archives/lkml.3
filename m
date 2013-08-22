Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab3HVNDm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 09:03:42 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:55277 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab3HVNDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 09:03:41 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: liuj97@gmail.com, Jiang Liu <jiang.liu@huawei.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] tracing: store entry->next_cpu to trace records in trace_ctxwake_bin()
Date: Thu, 22 Aug 2013 20:59:39 +0800
Message-Id: <1377176379-27908-1-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Function trace_ctxwake_bin() misses ctx_switch_entry->next_cpu field,
so user will get stale value for "next_cpu".

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org
---
 kernel/trace/trace_output.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 34e7cba..201eb76 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -1157,6 +1157,7 @@ static enum print_line_t trace_ctxwake_bin(struct trace_iterator *iter,
 	SEQ_PUT_FIELD_RET(s, field->prev_pid);
 	SEQ_PUT_FIELD_RET(s, field->prev_prio);
 	SEQ_PUT_FIELD_RET(s, field->prev_state);
+	SEQ_PUT_FIELD_RET(s, field->next_cpu);
 	SEQ_PUT_FIELD_RET(s, field->next_pid);
 	SEQ_PUT_FIELD_RET(s, field->next_prio);
 	SEQ_PUT_FIELD_RET(s, field->next_state);
-- 
1.8.1.2

