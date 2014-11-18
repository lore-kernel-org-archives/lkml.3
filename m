Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbaKRB7E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 20:59:04 -0500
Received: from mga11.intel.com ([192.55.52.93]:10994 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524AbaKRB7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 20:59:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="417896460"
From: Andi Kleen <andi@firstfloor.org>
To: acme@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/2] perf, tools: In branch stack mode use address history sorting
Date: Mon, 17 Nov 2014 17:58:54 -0800
Message-Id: <1416275935-20971-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Enable CCKEY_ADDRESS address history sorting with --branch-history.
This makes get_srcline display the source lines correctly,
otherwise all history entries for a function a hunked into one.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/builtin-report.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index fb272ff..3936760 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -761,6 +761,7 @@ repeat:
 		symbol_conf.cumulate_callchain = false;
 	}
 	if (branch_call_mode) {
+		callchain_param.key = CCKEY_ADDRESS;
 		callchain_param.branch_callstack = 1;
 		symbol_conf.use_callchain = true;
 		callchain_register_param(&callchain_param);
-- 
1.9.3

