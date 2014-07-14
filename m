Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296AbaGNKO6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 06:14:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:41894 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754489AbaGNKFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 06:05:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,657,1400050800"; 
   d="scan'208";a="561434376"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 19/41] perf tools: Do not attempt to read data from kallsyms
Date: Mon, 14 Jul 2014 13:02:43 +0300
Message-Id: <1405332185-4050-20-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
References: <1405332185-4050-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Record kallsyms binary type so that tools will not
attempt to read binary data from it.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/symbol.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index be7b0df..21b2e45 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1663,6 +1663,7 @@ do_kallsyms:
 	free(kallsyms_allocated_filename);
 
 	if (err > 0 && !dso__is_kcore(dso)) {
+		dso->binary_type = DSO_BINARY_TYPE__KALLSYMS;
 		dso__set_long_name(dso, "[kernel.kallsyms]", false);
 		map__fixup_start(map);
 		map__fixup_end(map);
@@ -1710,6 +1711,7 @@ static int dso__load_guest_kernel_sym(struct dso *dso, struct map *map,
 	if (err > 0)
 		pr_debug("Using %s for symbols\n", kallsyms_filename);
 	if (err > 0 && !dso__is_kcore(dso)) {
+		dso->binary_type = DSO_BINARY_TYPE__GUEST_KALLSYMS;
 		machine__mmap_name(machine, path, sizeof(path));
 		dso__set_long_name(dso, strdup(path), true);
 		map__fixup_start(map);
-- 
1.8.3.2

