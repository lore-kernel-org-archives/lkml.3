Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbaHLPH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 11:07:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:20192 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753190AbaHLPG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 11:06:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,849,1400050800"; 
   d="scan'208";a="575603042"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/4] perf tools: Fix CLOEXEC probe for perf_event_paranoid == 2
Date: Tue, 12 Aug 2014 18:04:28 +0300
Message-Id: <1407855871-15024-2-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1407855871-15024-1-git-send-email-adrian.hunter@intel.com>
References: <1407855871-15024-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With /proc/sys/kernel/perf_event_paranoid set to 2, the
probe of PERF_FLAG_FD_CLOEXEC would fail.  Fix by excluding
kernel profiling from the probe event.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/cloexec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/cloexec.c b/tools/perf/util/cloexec.c
index 5073c01..000047c 100644
--- a/tools/perf/util/cloexec.c
+++ b/tools/perf/util/cloexec.c
@@ -11,6 +11,7 @@ static int perf_flag_probe(void)
 	struct perf_event_attr attr = {
 		.type = PERF_TYPE_SOFTWARE,
 		.config = PERF_COUNT_SW_CPU_CLOCK,
+		.exclude_kernel = 1,
 	};
 	int fd;
 	int err;
-- 
1.8.3.2

