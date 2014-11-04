Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbaKDNtg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 08:49:36 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:13127 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932065AbaKDNtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 08:49:19 -0500
Message-Id: <20141104134916.450863338@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 04 Nov 2014 08:48:51 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Jiang Liu <jiang.liu@huawei.com>
Subject: [for-next][PATCH 4/4] tracing: Add entry->next_cpu to trace_ctxwake_bin()
References: <20141104134847.978505265@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0004-tracing-Add-entry-next_cpu-to-trace_ctxwake_bin.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Function trace_ctxwake_bin() misses ctx_switch_entry->next_cpu field,
so user will get stale value for "next_cpu".

Link: http://lkml.kernel.org/p/1377176379-27908-1-git-send-email-liuj97@gmail.com

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_output.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index c6977d5a9b12..cfa91de22e27 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -976,6 +976,7 @@ static enum print_line_t trace_ctxwake_bin(struct trace_iterator *iter,
 	SEQ_PUT_FIELD_RET(s, field->prev_pid);
 	SEQ_PUT_FIELD_RET(s, field->prev_prio);
 	SEQ_PUT_FIELD_RET(s, field->prev_state);
+	SEQ_PUT_FIELD_RET(s, field->next_cpu);
 	SEQ_PUT_FIELD_RET(s, field->next_pid);
 	SEQ_PUT_FIELD_RET(s, field->next_prio);
 	SEQ_PUT_FIELD_RET(s, field->next_state);
-- 
2.1.1


