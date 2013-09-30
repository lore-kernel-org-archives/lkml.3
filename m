Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171Ab3I3WAF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 18:00:05 -0400
Received: from mga03.intel.com ([143.182.124.21]:32199 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756408Ab3I3V7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 17:59:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1010,1371106800"; 
   d="scan'208";a="367935971"
From: Andi Kleen <andi@firstfloor.org>
To: acma@infradead.org
Cc: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        jolsa@redhat.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 4/6] perf, tools: Add abort_tx,no_tx,in_tx branch filter options to perf record -j v3
Date: Mon, 30 Sep 2013 14:59:01 -0700
Message-Id: <1380578343-31301-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380578343-31301-1-git-send-email-andi@firstfloor.org>
References: <1380578343-31301-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Make perf record -j aware of the new in_tx,no_tx,abort_tx branch qualifiers.

v2: ABORT -> ABORTTX
v3: Add more _
Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Documentation/perf-record.txt | 3 +++
 tools/perf/builtin-record.c              | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index e297b74..6bec1c9 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -166,6 +166,9 @@ following filters are defined:
         - u:  only when the branch target is at the user level
         - k: only when the branch target is in the kernel
         - hv: only when the target is at the hypervisor level
+	- in_tx: only when the target is in a hardware transaction
+	- no_tx: only when the target is not in a hardware transaction
+	- abort_tx: only when the target is a hardware transaction abort
 
 +
 The option requires at least one branch type among any, any_call, any_ret, ind_call.
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index a41ac415..8384b54 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -618,6 +618,9 @@ static const struct branch_mode branch_modes[] = {
 	BRANCH_OPT("any_call", PERF_SAMPLE_BRANCH_ANY_CALL),
 	BRANCH_OPT("any_ret", PERF_SAMPLE_BRANCH_ANY_RETURN),
 	BRANCH_OPT("ind_call", PERF_SAMPLE_BRANCH_IND_CALL),
+	BRANCH_OPT("abort_tx", PERF_SAMPLE_BRANCH_ABORT_TX),
+	BRANCH_OPT("in_tx", PERF_SAMPLE_BRANCH_IN_TX),
+	BRANCH_OPT("no_tx", PERF_SAMPLE_BRANCH_NO_TX),
 	BRANCH_END
 };
 
-- 
1.8.3.1

