Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922AbaJNVGb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 17:06:31 -0400
Received: from mail.kernel.org ([198.145.19.201]:45010 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755911AbaJNVG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 17:06:27 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jean Pihet <jean.pihet@linaro.org>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 19/24] perf evsel: Make some exit routines static
Date: Tue, 14 Oct 2014 18:04:28 -0300
Message-Id: <1413320673-5784-20-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413320673-5784-1-git-send-email-acme@kernel.org>
References: <1413320673-5784-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Since they are automatically called by other methods used by tools.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-ne3g4any7q6ty5d6yv8t1wws@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c | 6 +++---
 tools/perf/util/evsel.h | 3 ---
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 7a3c4c47ceda..d1ecde0fd56c 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -725,7 +725,7 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
 	}
 }
 
-int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads)
+static int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads)
 {
 	int cpu, thread;
 
@@ -813,13 +813,13 @@ int perf_evsel__alloc_counts(struct perf_evsel *evsel, int ncpus)
 	return evsel->counts != NULL ? 0 : -ENOMEM;
 }
 
-void perf_evsel__free_fd(struct perf_evsel *evsel)
+static void perf_evsel__free_fd(struct perf_evsel *evsel)
 {
 	xyarray__delete(evsel->fd);
 	evsel->fd = NULL;
 }
 
-void perf_evsel__free_id(struct perf_evsel *evsel)
+static void perf_evsel__free_id(struct perf_evsel *evsel)
 {
 	xyarray__delete(evsel->sample_id);
 	evsel->sample_id = NULL;
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 5c80cf037e50..1d5c754aebc4 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -154,12 +154,9 @@ const char *perf_evsel__name(struct perf_evsel *evsel);
 const char *perf_evsel__group_name(struct perf_evsel *evsel);
 int perf_evsel__group_desc(struct perf_evsel *evsel, char *buf, size_t size);
 
-int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
 int perf_evsel__alloc_id(struct perf_evsel *evsel, int ncpus, int nthreads);
 int perf_evsel__alloc_counts(struct perf_evsel *evsel, int ncpus);
 void perf_evsel__reset_counts(struct perf_evsel *evsel, int ncpus);
-void perf_evsel__free_fd(struct perf_evsel *evsel);
-void perf_evsel__free_id(struct perf_evsel *evsel);
 void perf_evsel__free_counts(struct perf_evsel *evsel);
 void perf_evsel__close_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
 
-- 
1.9.3

