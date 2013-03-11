Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab3CKHOj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 03:14:39 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:26677 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab3CKHOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 03:14:38 -0400
Message-ID: <513D8437.8060400@huawei.com>
Date: Mon, 11 Mar 2013 15:13:59 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 07/13] tracing/kdb: remove redundant checking
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

trace_empty is checking in while-loop, so the previous checking
is totally redundant, and more worse, the first trace entry is losted.

so remove it.

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
---
 kernel/trace/trace_kdb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/trace/trace_kdb.c b/kernel/trace/trace_kdb.c
index 3c5c5df..6489b2e 100644
--- a/kernel/trace/trace_kdb.c
+++ b/kernel/trace/trace_kdb.c
@@ -57,8 +57,7 @@ static void ftrace_dump_buf(int skip_lines, long cpu_file)
 		ring_buffer_read_start(iter.buffer_iter[cpu_file]);
 		tracing_iter_reset(&iter, cpu_file);
 	}
-	if (!trace_empty(&iter))
-		trace_find_next_entry_inc(&iter);
+
 	while (!trace_empty(&iter)) {
 		if (!cnt)
 			kdb_printf("---------------------------------\n");
-- 
1.7.9.7


