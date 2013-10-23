Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775Ab3JWHyg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 03:54:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55934 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab3JWHyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 03:54:32 -0400
Date: Wed, 23 Oct 2013 00:54:12 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-c83fa7f2549cb60bc4d429de31096546f659ce6d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1382099356-4918-16-git-send-email-adrian.hunter@intel.com>
References: <1382099356-4918-16-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evlist: Fix perf_evlist__mmap comments
Git-Commit-ID: c83fa7f2549cb60bc4d429de31096546f659ce6d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 23 Oct 2013 00:54:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c83fa7f2549cb60bc4d429de31096546f659ce6d
Gitweb:     http://git.kernel.org/tip/c83fa7f2549cb60bc4d429de31096546f659ce6d
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Fri, 18 Oct 2013 15:29:12 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 21 Oct 2013 11:19:43 -0300

perf evlist: Fix perf_evlist__mmap comments

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
index 07ba0a4..acef94a 100644
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
