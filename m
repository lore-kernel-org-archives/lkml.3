Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933689Ab3LINK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 08:10:58 -0500
Received: from mga02.intel.com ([134.134.136.20]:55833 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933607Ab3LINKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 08:10:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,857,1378882800"; 
   d="scan'208";a="449172884"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/4] perf tools: Fix max mmap_pages
Date: Mon,  9 Dec 2013 15:18:38 +0200
Message-Id: <1386595120-22978-3-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1386595120-22978-1-git-send-email-adrian.hunter@intel.com>
References: <1386595120-22978-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'SIZE_MAX / page_size' is an upper limit for
the maximum number of mmap pages, not a lower
limit.  Change the condition accordingly.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/evlist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 4d0945c..98ec96b 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -754,7 +754,7 @@ int perf_evlist__parse_mmap_pages(const struct option *opt, const char *str,
 	unsigned long max = UINT_MAX;
 	long pages;
 
-	if (max < SIZE_MAX / page_size)
+	if (max > SIZE_MAX / page_size)
 		max = SIZE_MAX / page_size;
 
 	pages = parse_pages_arg(str, 1, max);
-- 
1.7.11.7

