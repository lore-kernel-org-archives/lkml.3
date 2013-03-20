Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab3CTIJD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 04:09:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:11990 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750928Ab3CTII7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 04:08:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,876,1355126400"; 
   d="scan'208";a="309334753"
From: Youquan Song <youquan.song@intel.com>
To: tzanussi@gmail.com, a.p.zijlstra@chello.nl, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Cc: Youquan Song <youquan.song@linux.intel.com>,
        Youquan Song <youquan.song@intel.com>
Subject: [PATCH] perf: Fix parameter type mismatch
Date: Wed, 20 Mar 2013 16:18:03 -0400
Message-Id: <1363810683-23344-1-git-send-email-youquan.song@intel.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When build the tools/perf, encounter a block issue:
cc1: warnings being treated as errors
util/scripting-engines/trace-event-perl.c: In function ‘perl_process_tracepoint’:
util/scripting-engines/trace-event-perl.c:285: error: format ‘%lu’ expects type ‘long unsigned int’, but argument 2 has type ‘__u64’
make: *** [util/scripting-engines/trace-event-perl.o] Error 1

Signed-off-by: Youquan Song <youquan.song@intel.com>
---
 .../perf/util/scripting-engines/trace-event-perl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index f80605e..b2b3bdb 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -282,7 +282,7 @@ static void perl_process_tracepoint(union perf_event *perf_event __maybe_unused,
 
 	event = find_cache_event(evsel);
 	if (!event)
-		die("ug! no event found for type %" PRIu64, evsel->attr.config);
+		die("ug! no event found for type %" PRIu64, (u64)(evsel->attr.config));
 
 	pid = raw_field_value(event, "common_pid", data);
 
-- 
1.7.7.4

