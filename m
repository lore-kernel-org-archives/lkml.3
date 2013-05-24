Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab3EXLRM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 07:17:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767Ab3EXLRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
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
Subject: [PATCH 1/5] perf tests: Fix attr test for record -d option
Date: Fri, 24 May 2013 13:16:37 +0200
Message-Id: <1369394201-20044-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1369394201-20044-1-git-send-email-jolsa@redhat.com>
References: <1369394201-20044-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sample type for '-d' option is changed, because
of the memory profiling patches from Stephane. The
'-d' now adds PERF_SAMPLE_DATA_SRC sample_type.

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
 tools/perf/tests/attr/test-record-data | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/perf/tests/attr/test-record-data b/tools/perf/tests/attr/test-record-data
index 6627c3e..716e143 100644
--- a/tools/perf/tests/attr/test-record-data
+++ b/tools/perf/tests/attr/test-record-data
@@ -4,5 +4,8 @@ args    = -d kill >/dev/null 2>&1
 
 [event:base-record]
 sample_period=4000
-sample_type=271
+
+# sample_type = PERF_SAMPLE_IP | PERF_SAMPLE_TID | PERF_SAMPLE_TIME |
+# PERF_SAMPLE_ADDR | PERF_SAMPLE_PERIOD | PERF_SAMPLE_DATA_SRC
+sample_type=33039
 mmap_data=1
-- 
1.7.11.7

