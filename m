Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578Ab3HaSor (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 14:44:47 -0400
Received: from mga14.intel.com ([143.182.124.37]:30755 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754533Ab3HaSo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 14:44:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,998,1367996400"; 
   d="scan'208";a="289335848"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V2 1/3] perf: add a dummy software event to keep tracking
Date: Sat, 31 Aug 2013 21:50:51 +0300
Message-Id: <1377975053-3811-2-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1377975053-3811-1-git-send-email-adrian.hunter@intel.com>
References: <1377975053-3811-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When an event is disabled the "tracking" events
selected by the 'mmap', 'comm' and 'task' bits of
struct perf_event_attr, are also disabled.  However,
the information those events provide is necessary to
resolve symbols for when the main event is re-enabled.

The "tracking" events can be kept enabled by putting
them on another event, but that requires an event
that otherwise does nothing.  A new software event
PERF_COUNT_SW_DUMMY is added for that purpose.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
---
 include/uapi/linux/perf_event.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 42cb7b6..108c4bc 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -109,6 +109,7 @@ enum perf_sw_ids {
 	PERF_COUNT_SW_PAGE_FAULTS_MAJ		= 6,
 	PERF_COUNT_SW_ALIGNMENT_FAULTS		= 7,
 	PERF_COUNT_SW_EMULATION_FAULTS		= 8,
+	PERF_COUNT_SW_DUMMY			= 9,
 
 	PERF_COUNT_SW_MAX,			/* non-ABI */
 };
-- 
1.7.11.7

