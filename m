Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755719Ab3KAV4q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 17:56:46 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:56344 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754568Ab3KAVzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 17:55:03 -0400
Message-Id: <20131101215501.272654481@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 01 Nov 2013 17:53:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 5/8] tools lib traceevent: Have bprintk output the same as the kernel does
References: <20131101215352.875376844@goodmis.org>
Content-Disposition: inline; filename=0005-tools-lib-traceevent-Have-bprintk-output-the-same-as.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

The trace_bprintk() in the kernel looks like:

 ring_buffer_producer_thread: Missed:   0
 ring_buffer_producer_thread: Hit:      62174350
 ring_buffer_producer_thread: Entries per millisec: 6296
 ring_buffer_producer_thread: 158 ns per entry
 ring_buffer_producer_thread: Sleeping for 10 secs
 ring_buffer_producer_thread: Starting ring buffer hammer
 ring_buffer_producer_thread: End ring buffer hammer

But the current output looks like this:

 ring_buffer_producer_thread : Time:     9407018 (usecs)
 ring_buffer_producer_thread : Overruns: 43285485
 ring_buffer_producer_thread : Read:     4405365  (by events)
 ring_buffer_producer_thread : Entries:  0
 ring_buffer_producer_thread : Total:    47690850
 ring_buffer_producer_thread : Missed:   0
 ring_buffer_producer_thread : Hit:      47690850

Remove the space between the function and the colon.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/lib/traceevent/event-parse.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 0a1ffe0..e1c743c 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -3802,8 +3802,8 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
 	if (asprintf(&arg->atom.atom, "%lld", ip) < 0)
 		goto out_free;
 
-	/* skip the first "%pf : " */
-	for (ptr = fmt + 6, bptr = data + field->offset;
+	/* skip the first "%pf: " */
+	for (ptr = fmt + 5, bptr = data + field->offset;
 	     bptr < data + size && *ptr; ptr++) {
 		int ls = 0;
 
@@ -3929,12 +3929,12 @@ get_bprint_format(void *data, int size __maybe_unused,
 
 	printk = find_printk(pevent, addr);
 	if (!printk) {
-		if (asprintf(&format, "%%pf : (NO FORMAT FOUND at %llx)\n", addr) < 0)
+		if (asprintf(&format, "%%pf: (NO FORMAT FOUND at %llx)\n", addr) < 0)
 			return NULL;
 		return format;
 	}
 
-	if (asprintf(&format, "%s : %s", "%pf", printk->printk) < 0)
+	if (asprintf(&format, "%s: %s", "%pf", printk->printk) < 0)
 		return NULL;
 
 	return format;
-- 
1.8.4.rc3


