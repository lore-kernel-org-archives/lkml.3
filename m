Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab3AYWC1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 17:02:27 -0500
Received: from mga02.intel.com ([134.134.136.20]:16022 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307Ab3AYWAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 17:00:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,541,1355126400"; 
   d="scan'208";a="276757476"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@kernel.org
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        akpm@linux-foundation.org, acme@redhat.com, eranian@google.com,
        jolsa@redhat.com, namhyung@kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 12/12] perf, tools: Add abort_tx,no_tx,in_tx branch filter options to perf record -j v3
Date: Fri, 25 Jan 2013 14:00:45 -0800
Message-Id: <1359151245-13179-13-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1359151245-13179-1-git-send-email-andi@firstfloor.org>
References: <1359151245-13179-1-git-send-email-andi@firstfloor.org>
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
index 938e890..f7d74b2 100644
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
index 2ac690c..4bcfccd 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -671,6 +671,9 @@ static const struct branch_mode branch_modes[] = {
 	BRANCH_OPT("any_call", PERF_SAMPLE_BRANCH_ANY_CALL),
 	BRANCH_OPT("any_ret", PERF_SAMPLE_BRANCH_ANY_RETURN),
 	BRANCH_OPT("ind_call", PERF_SAMPLE_BRANCH_IND_CALL),
+	BRANCH_OPT("abort_tx", PERF_SAMPLE_BRANCH_ABORTTX),
+	BRANCH_OPT("in_tx", PERF_SAMPLE_BRANCH_INTX),
+	BRANCH_OPT("no_tx", PERF_SAMPLE_BRANCH_NOTX),
 	BRANCH_END
 };
 
-- 
1.7.7.6

