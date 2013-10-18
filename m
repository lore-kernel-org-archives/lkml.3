Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab3JRMam (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 08:30:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:2346 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004Ab3JRMaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 08:30:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,522,1378882800"; 
   d="scan'208";a="394936436"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 08/19] perf inject: Do not repipe attributes to a perf.data file
Date: Fri, 18 Oct 2013 15:29:05 +0300
Message-Id: <1382099356-4918-9-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1382099356-4918-1-git-send-email-adrian.hunter@intel.com>
References: <1382099356-4918-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf.data files contain the attributes separately, do not
put them in the event stream as well.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-inject.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index f51a963..2a88a72 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -71,12 +71,17 @@ static int perf_event__repipe_attr(struct perf_tool *tool,
 				   union perf_event *event,
 				   struct perf_evlist **pevlist)
 {
+	struct perf_inject *inject = container_of(tool, struct perf_inject,
+						  tool);
 	int ret;
 
 	ret = perf_event__process_attr(tool, event, pevlist);
 	if (ret)
 		return ret;
 
+	if (!inject->pipe_output)
+		return 0;
+
 	return perf_event__repipe_synth(tool, event);
 }
 
-- 
1.7.11.7

