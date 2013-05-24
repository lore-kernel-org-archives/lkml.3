Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018Ab3EXLRN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 07:17:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752018Ab3EXLRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 07:17:10 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 4/5] perf tools: Remove unused code from record command
Date: Fri, 24 May 2013 13:16:40 +0200
Message-Id: <1369394201-20044-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1369394201-20044-1-git-send-email-jolsa@redhat.com>
References: <1369394201-20044-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing old/unused leftover from __cmd_record function.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/builtin-report.c | 23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index ca98d34..a62a7d9 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -497,7 +497,7 @@ static int __cmd_report(struct perf_report *rep)
 		ret = perf_session__cpu_bitmap(session, rep->cpu_list,
 					       rep->cpu_bitmap);
 		if (ret)
-			goto out_delete;
+			return ret;
 	}
 
 	if (use_browser <= 0)
@@ -508,11 +508,11 @@ static int __cmd_report(struct perf_report *rep)
 
 	ret = perf_report__setup_sample_type(rep);
 	if (ret)
-		goto out_delete;
+		return ret;
 
 	ret = perf_session__process_events(session, &rep->tool);
 	if (ret)
-		goto out_delete;
+		return ret;
 
 	kernel_map = session->machines.host.vmlinux_maps[MAP__FUNCTION];
 	kernel_kmap = map__kmap(kernel_map);
@@ -547,7 +547,7 @@ static int __cmd_report(struct perf_report *rep)
 
 	if (dump_trace) {
 		perf_session__fprintf_nr_events(session, stdout);
-		goto out_delete;
+		return 0;
 	}
 
 	nr_samples = 0;
@@ -572,7 +572,7 @@ static int __cmd_report(struct perf_report *rep)
 
 	if (nr_samples == 0) {
 		ui__error("The %s file has no samples!\n", session->filename);
-		goto out_delete;
+		return 0;
 	}
 
 	list_for_each_entry(pos, &session->evlist->entries, node)
@@ -598,19 +598,6 @@ static int __cmd_report(struct perf_report *rep)
 	} else
 		perf_evlist__tty_browse_hists(session->evlist, rep, help);
 
-out_delete:
-	/*
-	 * Speed up the exit process, for large files this can
-	 * take quite a while.
-	 *
-	 * XXX Enable this when using valgrind or if we ever
-	 * librarize this command.
-	 *
-	 * Also experiment with obstacks to see how much speed
-	 * up we'll get here.
-	 *
- 	 * perf_session__delete(session);
- 	 */
 	return ret;
 }
 
-- 
1.7.11.7

