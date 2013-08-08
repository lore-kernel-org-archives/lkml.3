Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965289Ab3HHL0i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 07:26:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:35773 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965259Ab3HHL0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 07:26:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,838,1367996400"; 
   d="scan'208";a="383802863"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 3/8] perf report: set the machines symbol filter
Date: Thu,  8 Aug 2013 14:32:22 +0300
Message-Id: <1375961547-30267-4-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375961547-30267-1-git-send-email-adrian.hunter@intel.com>
References: <1375961547-30267-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Take into use the machines' symbol filter member.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
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
1.7.11.7

