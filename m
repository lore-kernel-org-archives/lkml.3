Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab3KDUXc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 15:23:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50159 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623Ab3KDUXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 15:23:16 -0500
Date: Mon, 4 Nov 2013 12:23:01 -0800
From: "tip-bot for Steven Rostedt (Red Hat)" <tipbot@zytor.com>
Message-ID: <tip-0883d9d730fc294c3d90ebd190b94e5782ead316@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, namhyung@kernel.org, fweisbec@gmail.com,
        rostedt@goodmis.org, akpm@linux-foundation.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, namhyung@kernel.org, fweisbec@gmail.com,
        rostedt@goodmis.org, akpm@linux-foundation.org, tglx@linutronix.de
In-Reply-To: <20131101215501.272654481@goodmis.org>
References: <20131101215501.272654481@goodmis.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Have bprintk output the same as the kernel does
Git-Commit-ID: 0883d9d730fc294c3d90ebd190b94e5782ead316
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 04 Nov 2013 12:23:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0883d9d730fc294c3d90ebd190b94e5782ead316
Gitweb:     http://git.kernel.org/tip/0883d9d730fc294c3d90ebd190b94e5782ead316
Author:     Steven Rostedt (Red Hat) <rostedt@goodmis.org>
AuthorDate: Fri, 1 Nov 2013 17:53:57 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 4 Nov 2013 14:35:35 -0300

tools lib traceevent: Have bprintk output the same as the kernel does

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
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/20131101215501.272654481@goodmis.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
