Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab3CKHO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 03:14:28 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:26504 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab3CKHOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 03:14:23 -0400
Message-ID: <513D8441.7050807@huawei.com>
Date: Mon, 11 Mar 2013 15:14:09 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 09/13] tracing: use trace_seq_init to initize seq field in
 trace_iterator
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the size of seq field in trace_iterator is more than PAGE_SIZE, so
seq memset is expensive, try to use cheap seq init method: trace_seq_init

Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
---
 kernel/trace/trace.c     |   10 ++++++----
 kernel/trace/trace_kdb.c |    5 +++--
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 4cec7b8..c7cc915 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3551,9 +3551,10 @@ waitagain:
 		cnt = PAGE_SIZE - 1;

 	/* reset all but tr, trace, and overruns */
-	memset(&iter->seq, 0,
+	trace_seq_init(&iter->seq);
+	memset(&iter->ent, 0,
 	       sizeof(struct trace_iterator) -
-	       offsetof(struct trace_iterator, seq));
+	       offsetof(struct trace_iterator, ent));
 	iter->pos = -1;

 	trace_event_read_lock();
@@ -5167,9 +5168,10 @@ __ftrace_dump(bool disable_tracing, enum ftrace_dump_mode oops_dump_mode)
 		cnt++;

 		/* reset all but tr, trace, and overruns */
-		memset(&iter.seq, 0,
+		trace_seq_init(&iter.seq);
+		memset(&iter.ent, 0,
 		       sizeof(struct trace_iterator) -
-		       offsetof(struct trace_iterator, seq));
+		       offsetof(struct trace_iterator, ent));
 		iter.iter_flags |= TRACE_FILE_LAT_FMT;
 		iter.pos = -1;

diff --git a/kernel/trace/trace_kdb.c b/kernel/trace/trace_kdb.c
index 6489b2e..84f1584 100644
--- a/kernel/trace/trace_kdb.c
+++ b/kernel/trace/trace_kdb.c
@@ -37,9 +37,10 @@ static void ftrace_dump_buf(int skip_lines, long cpu_file)
 	kdb_printf("Dumping ftrace buffer:\n");

 	/* reset all but tr, trace, and overruns */
-	memset(&iter.seq, 0,
+	trace_seq_init(&iter.seq);
+	memset(&iter.ent, 0,
 		   sizeof(struct trace_iterator) -
-		   offsetof(struct trace_iterator, seq));
+		   offsetof(struct trace_iterator, ent));
 	iter.iter_flags |= TRACE_FILE_LAT_FMT;
 	iter.pos = -1;

-- 
1.7.9.7


