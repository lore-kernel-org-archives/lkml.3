Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155Ab3HaIPt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 04:15:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59739 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757091Ab3HaIPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 04:15:42 -0400
Date: Sat, 31 Aug 2013 01:15:06 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-a2f2804a7142b043dafd39f21b86777840e1a78c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1377750593-48046-2-git-send-email-dsahern@gmail.com>
References: <1377750593-48046-2-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist: Add tracepoint lookup by name
Git-Commit-ID: a2f2804a7142b043dafd39f21b86777840e1a78c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 31 Aug 2013 01:15:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a2f2804a7142b043dafd39f21b86777840e1a78c
Gitweb:     http://git.kernel.org/tip/a2f2804a7142b043dafd39f21b86777840e1a78c
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Wed, 28 Aug 2013 22:29:51 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 29 Aug 2013 17:41:02 -0300

perf evlist: Add tracepoint lookup by name

Will be used by upcoming perf-trace replay option.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1377750593-48046-2-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 15 +++++++++++++++
 tools/perf/util/evlist.h |  4 ++++
 2 files changed, 19 insertions(+)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 6a629af..5df4ca9 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -208,6 +208,21 @@ perf_evlist__find_tracepoint_by_id(struct perf_evlist *evlist, int id)
 	return NULL;
 }
 
+struct perf_evsel *
+perf_evlist__find_tracepoint_by_name(struct perf_evlist *evlist,
+				     const char *name)
+{
+	struct perf_evsel *evsel;
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		if ((evsel->attr.type == PERF_TYPE_TRACEPOINT) &&
+		    (strcmp(evsel->name, name) == 0))
+			return evsel;
+	}
+
+	return NULL;
+}
+
 int perf_evlist__add_newtp(struct perf_evlist *evlist,
 			   const char *sys, const char *name, void *handler)
 {
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index ab95d72..841a394 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -74,6 +74,10 @@ int perf_evlist__set_filter(struct perf_evlist *evlist, const char *filter);
 struct perf_evsel *
 perf_evlist__find_tracepoint_by_id(struct perf_evlist *evlist, int id);
 
+struct perf_evsel *
+perf_evlist__find_tracepoint_by_name(struct perf_evlist *evlist,
+				     const char *name);
+
 void perf_evlist__id_add(struct perf_evlist *evlist, struct perf_evsel *evsel,
 			 int cpu, int thread, u64 id);
 
