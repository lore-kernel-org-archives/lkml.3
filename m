Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550Ab3KOH0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 02:26:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50371 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756250Ab3KOH0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 02:26:04 -0500
Date: Thu, 14 Nov 2013 23:25:18 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-d09l4lejp5427enuf3igpckw@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf evsel: Introduce perf_evsel__prev() method
Git-Commit-ID: d87fcb4a2d990ba2de9284ede84a816c5066d54b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 14 Nov 2013 23:25:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d87fcb4a2d990ba2de9284ede84a816c5066d54b
Gitweb:     http://git.kernel.org/tip/d87fcb4a2d990ba2de9284ede84a816c5066d54b
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 13 Nov 2013 15:56:40 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 14 Nov 2013 16:00:16 -0300

perf evsel: Introduce perf_evsel__prev() method

Just one use so far, on the hists browser, for completeness since there
we use perf_evlist__{first,last} and perf_evsel__next() for handling the
TAB and UNTAB keys.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-d09l4lejp5427enuf3igpckw@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/hists.c | 2 +-
 tools/perf/util/evsel.h        | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 089fd37..a440e03 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1855,7 +1855,7 @@ browse_hists:
 				if (pos->node.prev == &evlist->entries)
 					pos = perf_evlist__last(evlist);
 				else
-					pos = list_entry(pos->node.prev, struct perf_evsel, node);
+					pos = perf_evsel__prev(pos);
 				goto browse_hists;
 			case K_ESC:
 				if (!ui_browser__dialog_yesno(&menu->b,
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index f502965..1ea7c92 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -279,6 +279,11 @@ static inline struct perf_evsel *perf_evsel__next(struct perf_evsel *evsel)
 	return list_entry(evsel->node.next, struct perf_evsel, node);
 }
 
+static inline struct perf_evsel *perf_evsel__prev(struct perf_evsel *evsel)
+{
+	return list_entry(evsel->node.prev, struct perf_evsel, node);
+}
+
 /**
  * perf_evsel__is_group_leader - Return whether given evsel is a leader event
  *
