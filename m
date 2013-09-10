Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180Ab3IJSMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 14:12:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53802 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab3IJSMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 14:12:19 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/5] perf kvm: Fix sample_type manipulation
Date: Tue, 10 Sep 2013 15:12:00 -0300
Message-Id: <1378836722-31326-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378836722-31326-1-git-send-email-acme@infradead.org>
References: <1378836722-31326-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Manipulating the sample_type of an evsel requires the use of:

	perf_evsel__set_sample_bit()
and	perf_evsel__reset_sample_bit()

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Tested-by: David Ahern <dsahern@gmail.com>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1378496412-2424-3-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 47b3540..935d522 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1165,16 +1165,16 @@ static int kvm_live_open_events(struct perf_kvm_stat *kvm)
 		struct perf_event_attr *attr = &pos->attr;
 
 		/* make sure these *are* set */
-		attr->sample_type |= PERF_SAMPLE_TID;
-		attr->sample_type |= PERF_SAMPLE_TIME;
-		attr->sample_type |= PERF_SAMPLE_CPU;
-		attr->sample_type |= PERF_SAMPLE_RAW;
+		perf_evsel__set_sample_bit(pos, TID);
+		perf_evsel__set_sample_bit(pos, TIME);
+		perf_evsel__set_sample_bit(pos, CPU);
+		perf_evsel__set_sample_bit(pos, RAW);
 		/* make sure these are *not*; want as small a sample as possible */
-		attr->sample_type &= ~PERF_SAMPLE_PERIOD;
-		attr->sample_type &= ~PERF_SAMPLE_IP;
-		attr->sample_type &= ~PERF_SAMPLE_CALLCHAIN;
-		attr->sample_type &= ~PERF_SAMPLE_ADDR;
-		attr->sample_type &= ~PERF_SAMPLE_READ;
+		perf_evsel__reset_sample_bit(pos, PERIOD);
+		perf_evsel__reset_sample_bit(pos, IP);
+		perf_evsel__reset_sample_bit(pos, CALLCHAIN);
+		perf_evsel__reset_sample_bit(pos, ADDR);
+		perf_evsel__reset_sample_bit(pos, READ);
 		attr->mmap = 0;
 		attr->comm = 0;
 		attr->task = 0;
-- 
1.8.1.4

