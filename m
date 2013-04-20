Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552Ab3DTTXG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 15:23:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:30110 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780Ab3DTTT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 15:19:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,515,1363158000"; 
   d="scan'208";a="298141405"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu
Cc: acme@redhat.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 05/15] perf, tools: Add abort_tx,no_tx,in_tx branch filter options to perf record -j v3
Date: Sat, 20 Apr 2013 12:19:13 -0700
Message-Id: <1366485563-16209-6-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1366485563-16209-1-git-send-email-andi@firstfloor.org>
References: <1366485563-16209-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Make perf record -j aware of the new in_tx,no_tx,abort_tx branch qualifiers.

v2: ABORT -> ABORTTX
v3: Add more _
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Documentation/perf-record.txt |    3 +++
 tools/perf/builtin-record.c              |    3 +++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index d4da111..6f3405e 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -172,6 +172,9 @@ following filters are defined:
         - u:  only when the branch target is at the user level
         - k: only when the branch target is in the kernel
         - hv: only when the target is at the hypervisor level
+	- in_tx: only when the target is in a hardware transaction
+	- no_tx: only when the target is not in a hardware transaction
+	- abort_tx: only when the target is a hardware transaction abort
 
 +
 The option requires at least one branch type among any, any_call, any_ret, ind_call.
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index cdf58ec..1c46dd0 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -676,6 +676,9 @@ static const struct branch_mode branch_modes[] = {
 	BRANCH_OPT("any_call", PERF_SAMPLE_BRANCH_ANY_CALL),
 	BRANCH_OPT("any_ret", PERF_SAMPLE_BRANCH_ANY_RETURN),
 	BRANCH_OPT("ind_call", PERF_SAMPLE_BRANCH_IND_CALL),
+	BRANCH_OPT("abort_tx", PERF_SAMPLE_BRANCH_ABORT_TX),
+	BRANCH_OPT("in_tx", PERF_SAMPLE_BRANCH_IN_TX),
+	BRANCH_OPT("no_tx", PERF_SAMPLE_BRANCH_NO_TX),
 	BRANCH_END
 };
 
-- 
1.7.7.6

