Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab3FXNLN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 09:11:13 -0400
Received: from mga14.intel.com ([143.182.124.37]:25371 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807Ab3FXNLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 09:11:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,928,1363158000"; 
   d="scan'208";a="321686628"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 11/15] perf tools: fix symbol_conf.nr_events
Date: Mon, 24 Jun 2013 16:16:08 +0300
Message-Id: <1372079772-20803-12-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1372079772-20803-1-git-send-email-adrian.hunter@intel.com>
References: <1372079772-20803-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

symbol_conf.nr_events must be updated when processing
attribute events.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/header.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 4037b0a..81a3a0d 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2968,6 +2968,8 @@ int perf_event__process_attr(struct perf_tool *tool __maybe_unused,
 		perf_evlist__id_add(evlist, evsel, 0, i, event->attr.id[i]);
 	}
 
+	symbol_conf.nr_events = evlist->nr_entries;
+
 	return 0;
 }
 
-- 
1.7.11.7

