Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbaJOKGE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 06:06:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54477 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbaJOKGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 06:06:00 -0400
Date: Wed, 15 Oct 2014 03:05:21 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-ne3g4any7q6ty5d6yv8t1wws@git.kernel.org>
Cc: efault@gmx.de, dzickus@redhat.com, acme@redhat.com, paulus@samba.org,
        adrian.hunter@intel.com, mingo@kernel.org, eranian@google.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, bp@suse.de,
        peterz@infradead.org, tglx@linutronix.de, namhyung@kernel.org,
        fweisbec@gmail.com, jolsa@redhat.com, dsahern@gmail.com,
        jean.pihet@linaro.org
Reply-To: jean.pihet@linaro.org, dsahern@gmail.com, tglx@linutronix.de,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        eranian@google.com, mingo@kernel.org, bp@suse.de,
        linux-kernel@vger.kernel.org, hpa@zytor.com, peterz@infradead.org,
        efault@gmx.de, paulus@samba.org, acme@redhat.com, dzickus@redhat.com,
        adrian.hunter@intel.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf evsel: Make some exit routines static
Git-Commit-ID: 8885846fc4b708f543fe1dd3ef7402417d2d4151
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8885846fc4b708f543fe1dd3ef7402417d2d4151
Gitweb:     http://git.kernel.org/tip/8885846fc4b708f543fe1dd3ef7402417d2d4151
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 13 Oct 2014 13:30:27 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 14 Oct 2014 17:32:55 -0300

perf evsel: Make some exit routines static

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
index 7a3c4c4..d1ecde0 100644
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
index 5c80cf0..1d5c754 100644
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
 
