Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab3JVOeh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 10:34:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53892 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670Ab3JVO2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 10:28:51 -0400
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
Subject: [PATCH 16/26] perf evlist: Fix perf_evlist__mmap comments
Date: Tue, 22 Oct 2013 11:28:24 -0300
Message-Id: <1382452114-1243-17-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382452114-1243-1-git-send-email-acme@infradead.org>
References: <1382452114-1243-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Put the comments into the correct kernel-doc format and correct
reference to perf_evlist__read_on_cpu() which should be
perf_evlist__mmap_read().

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
Link: http://lkml.kernel.org/r/1382099356-4918-16-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 07ba0a43afd2..acef94a5ff9e 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -738,20 +738,17 @@ int perf_evlist__parse_mmap_pages(const struct option *opt, const char *str,
 	return 0;
 }
 
-/** perf_evlist__mmap - Create per cpu maps to receive events
- *
- * @evlist - list of events
- * @pages - map length in pages
- * @overwrite - overwrite older events?
- *
- * If overwrite is false the user needs to signal event consuption using:
- *
- *	struct perf_mmap *m = &evlist->mmap[cpu];
- *	unsigned int head = perf_mmap__read_head(m);
+/**
+ * perf_evlist__mmap - Create mmaps to receive events.
+ * @evlist: list of events
+ * @pages: map length in pages
+ * @overwrite: overwrite older events?
  *
- *	perf_mmap__write_tail(m, head)
+ * If @overwrite is %false the user needs to signal event consumption using
+ * perf_mmap__write_tail().  Using perf_evlist__mmap_read() does this
+ * automatically.
  *
- * Using perf_evlist__read_on_cpu does this automatically.
+ * Return: %0 on success, negative error code otherwise.
  */
 int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
 		      bool overwrite)
-- 
1.8.1.4

