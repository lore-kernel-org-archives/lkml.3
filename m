Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab3KDSCP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 13:02:15 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37931 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825Ab3KDR72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 12:59:28 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 13/29] perf evsel: Always use perf_evsel__set_sample_bit()
Date: Mon,  4 Nov 2013 14:58:51 -0300
Message-Id: <1383587947-17419-14-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1383587947-17419-1-git-send-email-acme@infradead.org>
References: <1383587947-17419-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Always use perf_evsel__set_sample_bit() rather than just setting the
bit.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1383313899-15987-8-git-send-email-adrian.hunter@intel.com
[ Cope with 3090ffb "perf: Disable PERF_RECORD_MMAP2 support" ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index f0e65dec66a5..47bbf03aa7ef 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -663,7 +663,7 @@ void perf_evsel__config(struct perf_evsel *evsel,
 	}
 
 	if (opts->sample_address)
-		attr->sample_type	|= PERF_SAMPLE_DATA_SRC;
+		perf_evsel__set_sample_bit(evsel, DATA_SRC);
 
 	if (opts->no_delay) {
 		attr->watermark = 0;
@@ -675,13 +675,13 @@ void perf_evsel__config(struct perf_evsel *evsel,
 	}
 
 	if (opts->sample_weight)
-		attr->sample_type	|= PERF_SAMPLE_WEIGHT;
+		perf_evsel__set_sample_bit(evsel, WEIGHT);
 
 	attr->mmap  = track;
 	attr->comm  = track;
 
 	if (opts->sample_transaction)
-		attr->sample_type	|= PERF_SAMPLE_TRANSACTION;
+		perf_evsel__set_sample_bit(evsel, TRANSACTION);
 
 	/*
 	 * XXX see the function comment above
-- 
1.8.1.4

