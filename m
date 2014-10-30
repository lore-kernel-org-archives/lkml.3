Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758844AbaJ3Gsy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 02:48:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38218 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757506AbaJ3Gsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 02:48:51 -0400
Date: Wed, 29 Oct 2014 23:48:10 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-v4fw80flg25nkl8jgeod3ot9@git.kernel.org>
Cc: acme@redhat.com, dzickus@redhat.com, jolsa@redhat.com, eranian@google.com,
        namhyung@kernel.org, fweisbec@gmail.com, efault@gmx.de, bp@suse.de,
        adrian.hunter@intel.com, mingo@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, hpa@zytor.com, paulus@samba.org, dsahern@gmail.com,
        linux-kernel@vger.kernel.org
Reply-To: namhyung@kernel.org, efault@gmx.de, fweisbec@gmail.com, bp@suse.de,
        adrian.hunter@intel.com, mingo@kernel.org, peterz@infradead.org,
        acme@redhat.com, dzickus@redhat.com, jolsa@redhat.com,
        eranian@google.com, paulus@samba.org, linux-kernel@vger.kernel.org,
        dsahern@gmail.com, tglx@linutronix.de, hpa@zytor.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Use evlist__for_each in a few remaining places
Git-Commit-ID: cba9b847f649af350809d8ff4119e84b0466c1d9
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

Commit-ID:  cba9b847f649af350809d8ff4119e84b0466c1d9
Gitweb:     http://git.kernel.org/tip/cba9b847f649af350809d8ff4119e84b0466c1d9
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 29 Oct 2014 11:31:54 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 29 Oct 2014 11:31:54 -0200

perf tools: Use evlist__for_each in a few remaining places

Where direct use of the longer form using list_for_entry() was being
used.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-v4fw80flg25nkl8jgeod3ot9@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c  | 2 +-
 tools/perf/util/session.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 0babd39..7e23dae 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -413,7 +413,7 @@ int perf_evlist__alloc_pollfd(struct perf_evlist *evlist)
 	int nfds = 0;
 	struct perf_evsel *evsel;
 
-	list_for_each_entry(evsel, &evlist->entries, node) {
+	evlist__for_each(evlist, evsel) {
 		if (evsel->system_wide)
 			nfds += nr_cpus;
 		else
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 27a0049..58dd5ce 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1662,7 +1662,7 @@ int perf_event__synthesize_id_index(struct perf_tool *tool,
 	max_nr = (UINT16_MAX - sizeof(struct id_index_event)) /
 		 sizeof(struct id_index_entry);
 
-	list_for_each_entry(evsel, &evlist->entries, node)
+	evlist__for_each(evlist, evsel)
 		nr += evsel->ids;
 
 	n = nr > max_nr ? max_nr : nr;
@@ -1675,7 +1675,7 @@ int perf_event__synthesize_id_index(struct perf_tool *tool,
 	ev->id_index.header.size = sz;
 	ev->id_index.nr = n;
 
-	list_for_each_entry(evsel, &evlist->entries, node) {
+	evlist__for_each(evlist, evsel) {
 		u32 j;
 
 		for (j = 0; j < evsel->ids; j++) {
