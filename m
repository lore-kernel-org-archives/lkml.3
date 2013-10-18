Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415Ab3JRMbI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 08:31:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:2346 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754392Ab3JRMbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 08:31:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,522,1378882800"; 
   d="scan'208";a="394936580"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 15/19] perf tools: fix perf_evlist__mmap comments
Date: Fri, 18 Oct 2013 15:29:12 +0300
Message-Id: <1382099356-4918-16-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1382099356-4918-1-git-send-email-adrian.hunter@intel.com>
References: <1382099356-4918-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Put the comments into the correct kernel-doc format and
correct reference to perf_evlist__read_on_cpu() which
should be perf_evlist__mmap_read().

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/evlist.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 52e434a..a4529af 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -739,20 +739,17 @@ int perf_evlist__parse_mmap_pages(const struct option *opt, const char *str,
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
1.7.11.7

