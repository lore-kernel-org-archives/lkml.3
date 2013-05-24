Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab3EXLRV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 07:17:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296Ab3EXLRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 07:17:20 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 2/5] perf tests: Fix exclude_guest|exclude_host checking for attr tests
Date: Fri, 24 May 2013 13:16:38 +0200
Message-Id: <1369394201-20044-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1369394201-20044-1-git-send-email-jolsa@redhat.com>
References: <1369394201-20044-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have a one of the event open fallback case in __perf_evsel__open
where we zero exclude_guest|exclude_host fields.

This means there's no way for attr tests to find out what's the right
value for those fields, so we need to check for both 0 and 1. Luckily
we still have other event parsing tests for those fields.

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
1.7.11.7

