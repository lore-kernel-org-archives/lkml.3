Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935371Ab3E3QET (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 12:04:19 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50823 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934377Ab3E3QCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 12:02:06 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 51/66] perf tests: Fix exclude_guest|exclude_host checking for attr tests
Date: Thu, 30 May 2013 19:01:24 +0300
Message-Id: <1369929699-8724-52-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369929699-8724-1-git-send-email-acme@infradead.org>
References: <1369929699-8724-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

We have a one of the event open fallback case in __perf_evsel__open
where we zero exclude_guest|exclude_host fields.

This means there's no way for attr tests to find out what's the right
value for those fields, so we need to check for both 0 and 1. Luckily we
still have other event parsing tests for those fields.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1369394201-20044-3-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/attr/base-record | 4 ++--
 tools/perf/tests/attr/base-stat   | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/tests/attr/base-record b/tools/perf/tests/attr/base-record
index b4fc835..e9bd639 100644
--- a/tools/perf/tests/attr/base-record
+++ b/tools/perf/tests/attr/base-record
@@ -27,8 +27,8 @@ watermark=0
 precise_ip=0
 mmap_data=0
 sample_id_all=1
-exclude_host=0
-exclude_guest=1
+exclude_host=0|1
+exclude_guest=0|1
 exclude_callchain_kernel=0
 exclude_callchain_user=0
 wakeup_events=0
diff --git a/tools/perf/tests/attr/base-stat b/tools/perf/tests/attr/base-stat
index 748ee94..91cd48b 100644
--- a/tools/perf/tests/attr/base-stat
+++ b/tools/perf/tests/attr/base-stat
@@ -27,8 +27,8 @@ watermark=0
 precise_ip=0
 mmap_data=0
 sample_id_all=0
-exclude_host=0
-exclude_guest=1
+exclude_host=0|1
+exclude_guest=0|1
 exclude_callchain_kernel=0
 exclude_callchain_user=0
 wakeup_events=0
-- 
1.8.1.4

