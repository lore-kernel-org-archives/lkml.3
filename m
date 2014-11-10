Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976AbaKJVQK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 16:16:10 -0500
Received: from mga11.intel.com ([192.55.52.93]:46712 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323AbaKJVQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 16:16:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,355,1413270000"; 
   d="scan'208";a="620185082"
From: kan.liang@intel.com
To: acme@kernel.org, jolsa@redhat.com, namhyung@kernel.org
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com,
        Kan Liang <kan.liang@intel.com>
Subject: [PATCH V2 1/3] perf tool: Fix perf diff symble sort issue
Date: Mon, 10 Nov 2014 16:01:18 -0500
Message-Id: <1415653280-1374-2-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1415653280-1374-1-git-send-email-kan.liang@intel.com>
References: <1415653280-1374-1-git-send-email-kan.liang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

This patch fixes a bug for perf diff.
Without mmap2, perf diff fails to find the symbol name. The default
symbol sort key doesn't work well.

Signed-off-by: Kan Liang <kan.liang@intel.com>
---
 tools/perf/builtin-diff.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 25114c9..1ce425d 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -357,6 +357,7 @@ static int diff__process_sample_event(struct perf_tool *tool __maybe_unused,
 static struct perf_tool tool = {
 	.sample	= diff__process_sample_event,
 	.mmap	= perf_event__process_mmap,
+	.mmap2	= perf_event__process_mmap2,
 	.comm	= perf_event__process_comm,
 	.exit	= perf_event__process_exit,
 	.fork	= perf_event__process_fork,
-- 
1.8.3.2

