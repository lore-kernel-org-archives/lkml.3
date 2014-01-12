Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbaALSgi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:36:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45771 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbaALSge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:36:34 -0500
Date: Sun, 12 Jan 2014 10:35:55 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-kx9temzdcy7mk2edya9c1tdu@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf mem:
  Remove unused parameter from dump_raw_samples()
Git-Commit-ID: 8b640cc4c56cee14bfe5cfb4dbb372ac66d5ec6b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:36:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8b640cc4c56cee14bfe5cfb4dbb372ac66d5ec6b
Gitweb:     http://git.kernel.org/tip/8b640cc4c56cee14bfe5cfb4dbb372ac66d5ec6b
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 19 Dec 2013 17:00:45 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 19 Dec 2013 17:03:39 -0300

perf mem: Remove unused parameter from dump_raw_samples()

The 'evsel' parameter is not used, ditch it, reducing the function
signature.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-kx9temzdcy7mk2edya9c1tdu@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-mem.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-mem.c b/tools/perf/builtin-mem.c
index 31c00f1..2e3ade69 100644
--- a/tools/perf/builtin-mem.c
+++ b/tools/perf/builtin-mem.c
@@ -62,7 +62,6 @@ static int
 dump_raw_samples(struct perf_tool *tool,
 		 union perf_event *event,
 		 struct perf_sample *sample,
-		 struct perf_evsel *evsel __maybe_unused,
 		 struct machine *machine)
 {
 	struct perf_mem *mem = container_of(tool, struct perf_mem, tool);
@@ -112,10 +111,10 @@ dump_raw_samples(struct perf_tool *tool,
 static int process_sample_event(struct perf_tool *tool,
 				union perf_event *event,
 				struct perf_sample *sample,
-				struct perf_evsel *evsel,
+				struct perf_evsel *evsel __maybe_unused,
 				struct machine *machine)
 {
-	return dump_raw_samples(tool, event, sample, evsel, machine);
+	return dump_raw_samples(tool, event, sample, machine);
 }
 
 static int report_raw_events(struct perf_mem *mem)
