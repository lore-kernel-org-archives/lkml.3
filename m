Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbaJ1NdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 09:33:20 -0400
Received: from mail.kernel.org ([198.145.19.201]:51253 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754300AbaJ1NdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 09:33:16 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 07/32] perf tests: Use thread->mg->machine
Date: Tue, 28 Oct 2014 11:32:01 -0200
Message-Id: <1414503146-22789-8-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1414503146-22789-1-git-send-email-acme@kernel.org>
References: <1414503146-22789-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Instead of passing both thread and machine.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-y2nl2v7p7of0dzuyc3tppxoo@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/code-reading.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/tools/perf/tests/code-reading.c b/tools/perf/tests/code-reading.c
index 144a41236456..f671ec37a7c4 100644
--- a/tools/perf/tests/code-reading.c
+++ b/tools/perf/tests/code-reading.c
@@ -133,8 +133,7 @@ static int read_via_objdump(const char *filename, u64 addr, void *buf,
 }
 
 static int read_object_code(u64 addr, size_t len, u8 cpumode,
-			    struct thread *thread, struct machine *machine,
-			    struct state *state)
+			    struct thread *thread, struct state *state)
 {
 	struct addr_location al;
 	unsigned char buf1[BUFSZ];
@@ -169,8 +168,8 @@ static int read_object_code(u64 addr, size_t len, u8 cpumode,
 		len = al.map->end - addr;
 
 	/* Read the object code using perf */
-	ret_len = dso__data_read_offset(al.map->dso, machine, al.addr, buf1,
-					len);
+	ret_len = dso__data_read_offset(al.map->dso, thread->mg->machine,
+					al.addr, buf1, len);
 	if (ret_len != len) {
 		pr_debug("dso__data_read_offset failed\n");
 		return -1;
@@ -263,8 +262,7 @@ static int process_sample_event(struct machine *machine,
 
 	cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 
-	return read_object_code(sample.ip, READLEN, cpumode, thread, machine,
-				state);
+	return read_object_code(sample.ip, READLEN, cpumode, thread, state);
 }
 
 static int process_event(struct machine *machine, struct perf_evlist *evlist,
-- 
1.9.3

