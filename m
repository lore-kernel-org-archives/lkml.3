Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965108Ab3HHL2E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 07:28:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:35773 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965262Ab3HHL0c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 07:26:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,838,1367996400"; 
   d="scan'208";a="383802801"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 2/8] perf top: set the machines symbol filter
Date: Thu,  8 Aug 2013 14:32:21 +0300
Message-Id: <1375961547-30267-3-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1375961547-30267-1-git-send-email-adrian.hunter@intel.com>
References: <1375961547-30267-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Take into use the machines symbol filter member.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-top.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 440c3b3..a63ade2 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -717,7 +717,7 @@ static void perf_event__process_sample(struct perf_tool *tool,
 		top->exact_samples++;
 
 	if (perf_event__preprocess_sample(event, machine, &al, sample,
-					  symbol_filter) < 0 ||
+					  machine->symbol_filter) < 0 ||
 	    al.filtered)
 		return;
 
@@ -938,6 +938,8 @@ static int __cmd_top(struct perf_top *top)
 	if (top->session == NULL)
 		return -ENOMEM;
 
+	machines__set_symbol_filter(&top->session->machines, symbol_filter);
+
 	if (!objdump_path) {
 		ret = perf_session_env__lookup_objdump(&top->session->header.env);
 		if (ret)
-- 
1.7.11.7

