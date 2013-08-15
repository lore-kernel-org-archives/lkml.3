Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760619Ab3HOH5q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 03:57:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53993 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318Ab3HOH5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 03:57:43 -0400
Date: Thu, 15 Aug 2013 00:57:02 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-476d35c2f3a48f81691daad06bc9668c516428d9@git.kernel.org>
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
In-Reply-To: <1375961547-30267-6-git-send-email-adrian.hunter@intel.com>
References: <1375961547-30267-6-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate: Set the machines symbol filter
Git-Commit-ID: 476d35c2f3a48f81691daad06bc9668c516428d9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 15 Aug 2013 00:57:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  476d35c2f3a48f81691daad06bc9668c516428d9
Gitweb:     http://git.kernel.org/tip/476d35c2f3a48f81691daad06bc9668c516428d9
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Thu, 8 Aug 2013 14:32:24 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 12 Aug 2013 10:31:11 -0300

perf annotate: Set the machines symbol filter

Take into use the machines symbol filter member.

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
Link: http://lkml.kernel.org/r/1375961547-30267-6-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index db491e9..9754cb1 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -91,7 +91,7 @@ static int process_sample_event(struct perf_tool *tool,
 	struct addr_location al;
 
 	if (perf_event__preprocess_sample(event, machine, &al, sample,
-					  symbol__annotate_init) < 0) {
+					  machine->symbol_filter) < 0) {
 		pr_warning("problem processing %d event, skipping it.\n",
 			   event->header.type);
 		return -1;
@@ -195,6 +195,8 @@ static int __cmd_annotate(struct perf_annotate *ann)
 	if (session == NULL)
 		return -ENOMEM;
 
+	machines__set_symbol_filter(&session->machines, symbol__annotate_init);
+
 	if (ann->cpu_list) {
 		ret = perf_session__cpu_bitmap(session, ann->cpu_list,
 					       ann->cpu_bitmap);
