Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab3F1Ims (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 04:42:48 -0400
Received: from mga14.intel.com ([143.182.124.37]:5632 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755159Ab3F1Iho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 04:37:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,957,1363158000"; 
   d="scan'208";a="323821218"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH V3 04/15] perf tools: fix parse_events_terms() segfault on error path
Date: Fri, 28 Jun 2013 11:43:15 +0300
Message-Id: <1372409006-8431-5-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1372409006-8431-1-git-send-email-adrian.hunter@intel.com>
References: <1372409006-8431-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On the error path, 'data.terms' may not have been
initialised.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/parse-events.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 6c8bb0f..d8dcb8d 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -860,7 +860,8 @@ int parse_events_terms(struct list_head *terms, const char *str)
 		return 0;
 	}
 
-	parse_events__free_terms(data.terms);
+	if (data.terms)
+		parse_events__free_terms(data.terms);
 	return ret;
 }
 
-- 
1.7.11.7

