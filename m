Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab3K3Mtq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 07:49:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59488 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab3K3Mtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 07:49:43 -0500
Date: Sat, 30 Nov 2013 04:49:29 -0800
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-bf80669e4f689f181f23a54dfe2a0f264147ad67@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1384487490-6865-1-git-send-email-dsahern@gmail.com>
References: <1384487490-6865-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf top: Make -g refer to callchains
Git-Commit-ID: bf80669e4f689f181f23a54dfe2a0f264147ad67
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 30 Nov 2013 04:49:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bf80669e4f689f181f23a54dfe2a0f264147ad67
Gitweb:     http://git.kernel.org/tip/bf80669e4f689f181f23a54dfe2a0f264147ad67
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Thu, 14 Nov 2013 20:51:30 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 27 Nov 2013 14:58:35 -0300

perf top: Make -g refer to callchains

In most commands -g is used for callchains. Make perf-top follow suit.
Move group to just --group with no short cut making it similar to
perf-record.

Signed-off-by: David Ahern <dsahern@gmail.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1384487490-6865-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-top.txt | 5 ++---
 tools/perf/builtin-top.c              | 4 ++--
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index 7de01dd..cdd8d49 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -50,7 +50,6 @@ Default is to monitor all CPUS.
 --count-filter=<count>::
 	Only display functions with more events than this.
 
--g::
 --group::
         Put the counters into a counter group.
 
@@ -143,12 +142,12 @@ Default is to monitor all CPUS.
 --asm-raw::
 	Show raw instruction encoding of assembly instructions.
 
--G::
+-g::
 	Enables call-graph (stack chain/backtrace) recording.
 
 --call-graph::
 	Setup and enable call-graph (stack chain/backtrace) recording,
-	implies -G.
+	implies -g.
 
 --max-stack::
 	Set the stack depth limit when parsing the callchain, anything
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 71e6402..531522d 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1084,7 +1084,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 			    "dump the symbol table used for profiling"),
 	OPT_INTEGER('f', "count-filter", &top.count_filter,
 		    "only display functions with more events than this"),
-	OPT_BOOLEAN('g', "group", &opts->group,
+	OPT_BOOLEAN(0, "group", &opts->group,
 			    "put the counters into a counter group"),
 	OPT_BOOLEAN('i', "no-inherit", &opts->no_inherit,
 		    "child tasks do not inherit counters"),
@@ -1105,7 +1105,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 		   " abort, in_tx, transaction"),
 	OPT_BOOLEAN('n', "show-nr-samples", &symbol_conf.show_nr_samples,
 		    "Show a column with the number of samples"),
-	OPT_CALLBACK_NOOPT('G', NULL, &top.record_opts,
+	OPT_CALLBACK_NOOPT('g', NULL, &top.record_opts,
 			   NULL, "enables call-graph recording",
 			   &callchain_opt),
 	OPT_CALLBACK(0, "call-graph", &top.record_opts,
