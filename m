Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411AbaGNKFi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:05:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:40395 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754153AbaGNKEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:04:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,657,1400050800"; 
   d="scan'208";a="561434215"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 10/41] perf inject: Fix build id injection
Date: Mon, 14 Jul 2014 13:02:34 +0300
Message-Id: <1405332185-4050-11-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Build Ids won't be injected unless the build id
feature flag is set.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-inject.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 16c7c11..cf6a605 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -389,6 +389,9 @@ static int __cmd_inject(struct perf_inject *inject)
 	ret = perf_session__process_events(session, &inject->tool);
 
 	if (!file_out->is_pipe) {
+		if (inject->build_ids)
+			perf_header__set_feat(&session->header,
+					      HEADER_BUILD_ID);
 		session->header.data_size = inject->bytes_written;
 		perf_session__write_header(session, session->evlist, file_out->fd, true);
 	}
-- 
1.8.3.2

