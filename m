Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760589Ab3HOH5Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 03:57:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53965 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760575Ab3HOH5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 03:57:22 -0400
Date: Thu, 15 Aug 2013 00:56:43 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-b8681711271a0124d9495dae2e1ac0616b0ed47a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        efault@gmx.de, peterz@infradead.org, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1375961547-30267-4-git-send-email-adrian.hunter@intel.com>
References: <1375961547-30267-4-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf report: Set the machines symbol filter
Git-Commit-ID: b8681711271a0124d9495dae2e1ac0616b0ed47a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 15 Aug 2013 00:56:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b8681711271a0124d9495dae2e1ac0616b0ed47a
Gitweb:     http://git.kernel.org/tip/b8681711271a0124d9495dae2e1ac0616b0ed47a
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Thu, 8 Aug 2013 14:32:22 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 12 Aug 2013 10:31:10 -0300

perf report: Set the machines symbol filter

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
