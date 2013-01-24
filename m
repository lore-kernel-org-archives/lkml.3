Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab3AXTGr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 14:06:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33220 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab3AXTGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 14:06:44 -0500
Date: Thu, 24 Jan 2013 11:06:18 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-ujpujgscq2f2oodxuso5nobc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel:
  No need to always ask for PERF_FORMAT_TOTAL_TIME_{ENABLED,RUNNING}
Git-Commit-ID: 62b807f64948f55776b1cc57298966d915b1a402
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 11:06:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  62b807f64948f55776b1cc57298966d915b1a402
Gitweb:     http://git.kernel.org/tip/62b807f64948f55776b1cc57298966d915b1a402
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 10 Dec 2012 16:04:40 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 11 Dec 2012 17:17:17 -0300

perf evsel: No need to always ask for PERF_FORMAT_TOTAL_TIME_{ENABLED,RUNNING}

This is needed, so far, just in 'perf stat', to scale counters, so don't
unconditionally ask for them in the perf_evsel__config() method.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-ujpujgscq2f2oodxuso5nobc@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/attr/base-record        | 2 +-
 tools/perf/tests/attr/test-record-group  | 4 ++--
 tools/perf/tests/attr/test-record-group1 | 4 ++--
 tools/perf/util/evsel.c                  | 2 --
 4 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/tools/perf/tests/attr/base-record b/tools/perf/tests/attr/base-record
index f9d0464..5bc3880 100644
--- a/tools/perf/tests/attr/base-record
+++ b/tools/perf/tests/attr/base-record
@@ -7,7 +7,7 @@ size=96
 config=0
 sample_period=4000
 sample_type=263
-read_format=3
+read_format=0
 disabled=1
 inherit=1
 pinned=0
diff --git a/tools/perf/tests/attr/test-record-group b/tools/perf/tests/attr/test-record-group
index 0df34ca..57739ca 100644
--- a/tools/perf/tests/attr/test-record-group
+++ b/tools/perf/tests/attr/test-record-group
@@ -6,14 +6,14 @@ args    = --group -e cycles,instructions kill >/dev/null 2>&1
 fd=1
 group_fd=-1
 sample_type=327
-read_format=7
+read_format=4
 
 [event-2:base-record]
 fd=2
 group_fd=1
 config=1
 sample_type=327
-read_format=7
+read_format=4
 mmap=0
 comm=0
 enable_on_exec=0
diff --git a/tools/perf/tests/attr/test-record-group1 b/tools/perf/tests/attr/test-record-group1
index 18bd926..4d688a1 100644
--- a/tools/perf/tests/attr/test-record-group1
+++ b/tools/perf/tests/attr/test-record-group1
@@ -6,7 +6,7 @@ args    = -e '{cycles,instructions}' kill >/tmp/krava 2>&1
 fd=1
 group_fd=-1
 sample_type=327
-read_format=7
+read_format=4
 
 [event-2:base-record]
 fd=2
@@ -14,7 +14,7 @@ group_fd=1
 type=0
 config=1
 sample_type=327
-read_format=7
+read_format=4
 mmap=0
 comm=0
 enable_on_exec=0
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index e62d3ae..2492d32 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -465,8 +465,6 @@ void perf_evsel__config(struct perf_evsel *evsel,
 
 	attr->sample_id_all = opts->sample_id_all_missing ? 0 : 1;
 	attr->inherit	    = !opts->no_inherit;
-	attr->read_format   = PERF_FORMAT_TOTAL_TIME_ENABLED |
-			      PERF_FORMAT_TOTAL_TIME_RUNNING;
 
 	perf_evsel__set_sample_bit(evsel, IP);
 	perf_evsel__set_sample_bit(evsel, TID);
