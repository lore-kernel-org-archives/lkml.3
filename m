Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbaJVTNo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 15:13:44 -0400
Received: from mga01.intel.com ([192.55.52.88]:48854 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755079AbaJVTN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 15:13:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,770,1406617200"; 
   d="scan'208";a="618699236"
From: kan.liang@intel.com
To: acme@kernel.org
Cc: linux-kernel@vger.kernel.org, Kan Liang <kan.liang@intel.com>
Subject: [PATCH 1/1] perf tool: add hists__init for perf diff
Date: Wed, 22 Oct 2014 15:02:41 -0400
Message-Id: <1414004561-22096-1-git-send-email-kan.liang@intel.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kan Liang <kan.liang@intel.com>

perf diff also uses hists/hist_entries, hists__init() should be called
before creating any evsels.

Signed-off-by: Kan Liang <kan.liang@intel.com>
---
 tools/perf/builtin-diff.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 8c5c11c..25114c9 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -1142,6 +1142,11 @@ static int data_init(int argc, const char **argv)
 
 int cmd_diff(int argc, const char **argv, const char *prefix __maybe_unused)
 {
+	int ret = hists__init();
+
+	if (ret < 0)
+		return ret;
+
 	perf_config(perf_default_config, NULL);
 
 	argc = parse_options(argc, argv, options, diff_usage, 0);
-- 
1.8.3.2

