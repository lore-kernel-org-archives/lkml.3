Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901AbaGQIo5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 04:44:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:30622 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754728AbaGQIoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 04:44:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,676,1400050800"; 
   d="scan'208";a="544670571"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] perf tools: Fix incorrect fd error comparison
Date: Thu, 17 Jul 2014 11:43:09 +0300
Message-Id: <1405586590-13657-2-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405586590-13657-1-git-send-email-adrian.hunter@intel.com>
References: <20140716142031.GD9441@krava.redhat.com>
 <1405586590-13657-1-git-send-email-adrian.hunter@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zero is a valid fd.  Error comparison should check
for negative fd.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/dso.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index fc006fe..28cf747 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -216,7 +216,7 @@ static int open_dso(struct dso *dso, struct machine *machine)
 {
 	int fd = __open_dso(dso, machine);
 
-	if (fd > 0) {
+	if (fd >= 0) {
 		dso__list_add(dso);
 		/*
 		 * Check if we crossed the allowed number
-- 
1.8.3.2

