Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab3JRMat (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 08:30:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:2346 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925Ab3JRMaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 08:30:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,522,1378882800"; 
   d="scan'208";a="394936462"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 10/19] perf evlist: Fix 32-bit build error
Date: Fri, 18 Oct 2013 15:29:07 +0300
Message-Id: <1382099356-4918-11-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1382099356-4918-1-git-send-email-adrian.hunter@intel.com>
References: <1382099356-4918-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

util/evlist.c: In function 'perf_evlist__mmap':
util/evlist.c:772:2: error: format '%lu' expects argument of type 'long unsigned int', but argument 3 has type 'size_t' [-Werror=format]
cc1: all warnings being treated as errors

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/evlist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 0b5425b..07ba0a4 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -769,7 +769,7 @@ int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
 
 	evlist->overwrite = overwrite;
 	evlist->mmap_len = perf_evlist__mmap_size(pages);
-	pr_debug("mmap size %luB\n", evlist->mmap_len);
+	pr_debug("mmap size %zuB\n", evlist->mmap_len);
 	mask = evlist->mmap_len - page_size - 1;
 
 	list_for_each_entry(evsel, &evlist->entries, node) {
-- 
1.7.11.7

