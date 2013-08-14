Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760287Ab3HNSZg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 14:25:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34385 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760267Ab3HNSZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 14:25:33 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 13/21] perf report: Set the machines symbol filter
Date: Wed, 14 Aug 2013 15:25:07 -0300
Message-Id: <1376504715-28107-14-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1376504715-28107-1-git-send-email-acme@infradead.org>
References: <1376504715-28107-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Take into use the machines' symbol filter member.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1375961547-30267-4-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-report.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index d785d89..f06a5a2 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -49,7 +49,6 @@ struct perf_report {
 	bool			mem_mode;
 	struct perf_read_values	show_threads_values;
 	const char		*pretty_printing_style;
-	symbol_filter_t		annotate_init;
 	const char		*cpu_list;
 	const char		*symbol_filter_str;
 	float			min_percent;
@@ -306,7 +305,7 @@ static int process_sample_event(struct perf_tool *tool,
 	int ret;
 
 	if (perf_event__preprocess_sample(event, machine, &al, sample,
-					  rep->annotate_init) < 0) {
+					  machine->symbol_filter) < 0) {
 		fprintf(stderr, "problem processing %d event, skipping it.\n",
 			event->header.type);
 		return -1;
@@ -924,7 +923,8 @@ repeat:
 	 */
 	if (use_browser == 1 && sort__has_sym) {
 		symbol_conf.priv_size = sizeof(struct annotation);
-		report.annotate_init  = symbol__annotate_init;
+		machines__set_symbol_filter(&session->machines,
+					    symbol__annotate_init);
 		/*
  		 * For searching by name on the "Browse map details".
  		 * providing it only in verbose mode not to bloat too
-- 
1.8.1.4

