Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbaIWGMk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 02:12:40 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:65206 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbaIWGMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 02:12:37 -0400
From: taeung <treeze.taeung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: linux-kernel@vger.kernel.org, jolsa@redhat.com, namhyung@kernel.org,
        linux-perf-users@vger.kernel.org, taeung <treeze.taeung@gmail.com>
Subject: [PATCH] modify error code when perf_session__new() fail.
Date: Tue, 23 Sep 2014 15:12:17 +0900
Message-Id: <1411452737-28188-1-git-send-email-treeze.taeung@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Because perf_session__new() could fail
	for more reasons than just ENOMEM,
	I modified error code(ENOMEM or EINVAL)
	into -1.

Signed-off-by: taeung <treeze.taeung@gmail.com>
---
 tools/perf/builtin-annotate.c  | 2 +-
 tools/perf/builtin-diff.c      | 2 +-
 tools/perf/builtin-evlist.c    | 2 +-
 tools/perf/builtin-inject.c    | 2 +-
 tools/perf/builtin-kmem.c      | 2 +-
 tools/perf/builtin-kvm.c       | 4 ++--
 tools/perf/builtin-lock.c      | 2 +-
 tools/perf/builtin-mem.c       | 2 +-
 tools/perf/builtin-report.c    | 2 +-
 tools/perf/builtin-script.c    | 2 +-
 tools/perf/builtin-timechart.c | 2 +-
 tools/perf/builtin-top.c       | 2 +-
 tools/perf/builtin-trace.c     | 2 +-
 13 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index d4da692..be59394 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -340,7 +340,7 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	annotate.session = perf_session__new(&file, false, &annotate.tool);
 	if (annotate.session == NULL)
-		return -ENOMEM;
+		return -1;
 
 	symbol_conf.priv_size = sizeof(struct annotation);
 	symbol_conf.try_vmlinux_path = true;
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 190d0b6..a3ce19f 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -683,7 +683,7 @@ static int __cmd_diff(void)
 		d->session = perf_session__new(&d->file, false, &tool);
 		if (!d->session) {
 			pr_err("Failed to open %s\n", d->file.path);
-			ret = -ENOMEM;
+			ret = -1;
 			goto out_delete;
 		}
 
diff --git a/tools/perf/builtin-evlist.c b/tools/perf/builtin-evlist.c
index 66e12f5..0f93f85 100644
--- a/tools/perf/builtin-evlist.c
+++ b/tools/perf/builtin-evlist.c
@@ -28,7 +28,7 @@ static int __cmd_evlist(const char *file_name, struct perf_attr_details *details
 
 	session = perf_session__new(&file, 0, NULL);
 	if (session == NULL)
-		return -ENOMEM;
+		return -1;
 
 	evlist__for_each(session->evlist, pos)
 		perf_evsel__fprintf(pos, details, stdout);
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 3a62b6b..de99ca1 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -460,7 +460,7 @@ int cmd_inject(int argc, const char **argv, const char *prefix __maybe_unused)
 	file.path = inject.input_name;
 	inject.session = perf_session__new(&file, true, &inject.tool);
 	if (inject.session == NULL)
-		return -ENOMEM;
+		return -1;
 
 	if (symbol__init(&inject.session->header.env) < 0)
 		return -1;
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 2376218..f295141 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -698,7 +698,7 @@ int cmd_kmem(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	session = perf_session__new(&file, false, &perf_kmem);
 	if (session == NULL)
-		return -ENOMEM;
+		return -1;
 
 	symbol__init(&session->header.env);
 
diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index f5d3ae4..fd84d47 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1062,7 +1062,7 @@ static int read_events(struct perf_kvm_stat *kvm)
 	kvm->session = perf_session__new(&file, false, &kvm->tool);
 	if (!kvm->session) {
 		pr_err("Initializing perf session failed\n");
-		return -EINVAL;
+		return -1;
 	}
 
 	symbol__init(&kvm->session->header.env);
@@ -1365,7 +1365,7 @@ static int kvm_events_live(struct perf_kvm_stat *kvm,
 	 */
 	kvm->session = perf_session__new(&file, false, &kvm->tool);
 	if (kvm->session == NULL) {
-		err = -ENOMEM;
+		err = -1;
 		goto out;
 	}
 	kvm->session->evlist = kvm->evlist;
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 92790ed..e7ec715 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -862,7 +862,7 @@ static int __cmd_report(bool display_info)
 	session = perf_session__new(&file, false, &eops);
 	if (!session) {
 		pr_err("Initializing perf session failed\n");
-		return -ENOMEM;
+		return -1;
 	}
 
 	symbol__init(&session->header.env);
diff --git a/tools/perf/builtin-mem.c b/tools/perf/builtin-mem.c
index 8b4a87f..24db6ff 100644
--- a/tools/perf/builtin-mem.c
+++ b/tools/perf/builtin-mem.c
@@ -124,7 +124,7 @@ static int report_raw_events(struct perf_mem *mem)
 							 &mem->tool);
 
 	if (session == NULL)
-		return -ENOMEM;
+		return -1;
 
 	if (mem->cpu_list) {
 		ret = perf_session__cpu_bitmap(session, mem->cpu_list,
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 8c0b3f2..ac145fa 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -720,7 +720,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 repeat:
 	session = perf_session__new(&file, false, &report.tool);
 	if (session == NULL)
-		return -ENOMEM;
+		return -1;
 
 	if (report.queue_size) {
 		ordered_events__set_alloc_size(&session->ordered_events,
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 02dce92..b9b9e58 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1744,7 +1744,7 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	session = perf_session__new(&file, false, &script.tool);
 	if (session == NULL)
-		return -ENOMEM;
+		return -1;
 
 	if (header || header_only) {
 		perf_session__fprintf_info(session, stdout, show_full_info);
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 48eea6c..35b425b 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -1605,7 +1605,7 @@ static int __cmd_timechart(struct timechart *tchart, const char *output_name)
 	int ret = -EINVAL;
 
 	if (session == NULL)
-		return -ENOMEM;
+		return -1;
 
 	symbol__init(&session->header.env);
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index e13864b..a70a551 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -929,7 +929,7 @@ static int __cmd_top(struct perf_top *top)
 
 	top->session = perf_session__new(NULL, false, NULL);
 	if (top->session == NULL)
-		return -ENOMEM;
+		return -1;
 
 	machines__set_symbol_filter(&top->session->machines, symbol_filter);
 
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index a9e96ff..aa5f1c9 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -2245,7 +2245,7 @@ static int trace__replay(struct trace *trace)
 
 	session = perf_session__new(&file, false, &trace->tool);
 	if (session == NULL)
-		return -ENOMEM;
+		return -1;
 
 	if (symbol__init(&session->header.env) < 0)
 		goto out;
-- 
1.8.3.2

