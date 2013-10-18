Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753854Ab3JRMad (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 08:30:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:48657 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018Ab3JRMab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 08:30:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,522,1378882800"; 
   d="scan'208";a="394936373"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 01/19] perf evsel: Add missing 'mmap2' from debug print
Date: Fri, 18 Oct 2013 15:28:58 +0300
Message-Id: <1382099356-4918-2-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1382099356-4918-1-git-send-email-adrian.hunter@intel.com>
References: <1382099356-4918-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct perf_event_attr now has 'mmap2'.  Add it to
perf_event_attr__fprintf().

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/evsel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index bfebc1e..291b18a 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -986,6 +986,7 @@ static size_t perf_event_attr__fprintf(struct perf_event_attr *attr, FILE *fp)
 	ret += PRINT_ATTR2(exclude_host, exclude_guest);
 	ret += PRINT_ATTR2N("excl.callchain_kern", exclude_callchain_kernel,
 			    "excl.callchain_user", exclude_callchain_user);
+	ret += PRINT_ATTR_U32(mmap2);
 
 	ret += PRINT_ATTR_U32(wakeup_events);
 	ret += PRINT_ATTR_U32(wakeup_watermark);
-- 
1.7.11.7

