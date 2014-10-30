Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933489AbaJ3Go3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 02:44:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37989 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231AbaJ3GoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 02:44:25 -0400
Date: Wed, 29 Oct 2014 23:43:40 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-y2nl2v7p7of0dzuyc3tppxoo@git.kernel.org>
Cc: peterz@infradead.org, jean.pihet@linaro.org, adrian.hunter@intel.com,
        paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, tglx@linutronix.de, hpa@zytor.com,
        namhyung@kernel.org, bp@suse.de, dzickus@redhat.com, efault@gmx.de,
        jolsa@redhat.com, mingo@kernel.org, dsahern@gmail.com,
        eranian@google.com
Reply-To: peterz@infradead.org, adrian.hunter@intel.com, jean.pihet@linaro.org,
        acme@redhat.com, fweisbec@gmail.com, linux-kernel@vger.kernel.org,
        paulus@samba.org, tglx@linutronix.de, hpa@zytor.com,
        namhyung@kernel.org, dzickus@redhat.com, bp@suse.de, mingo@kernel.org,
        efault@gmx.de, jolsa@redhat.com, eranian@google.com, dsahern@gmail.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests: Use thread->mg->machine
Git-Commit-ID: 29f9e5211132b0a0a4dfbbb403c136eebc334b73
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  29f9e5211132b0a0a4dfbbb403c136eebc334b73
Gitweb:     http://git.kernel.org/tip/29f9e5211132b0a0a4dfbbb403c136eebc334b73
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 23 Oct 2014 17:21:54 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 29 Oct 2014 10:32:47 -0200

perf tests: Use thread->mg->machine

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
index 144a412..f671ec3 100644
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
