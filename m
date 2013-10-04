Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab3JDReD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 13:34:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58776 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606Ab3JDRd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 13:33:59 -0400
Date: Fri, 4 Oct 2013 10:32:58 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-0126d493b62e1306db09e1019c05e0bfe84ae8e7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, ak@linux.intel.com, tglx@linutronix.de,
        jolsa@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, ak@linux.intel.com, tglx@linutronix.de,
        jolsa@redhat.com
In-Reply-To: <1379688044-14173-5-git-send-email-andi@firstfloor.org>
References: <1379688044-14173-5-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools/perf/record: Add abort_tx,no_tx,
 in_tx branch filter options to perf record -j
Git-Commit-ID: 0126d493b62e1306db09e1019c05e0bfe84ae8e7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 04 Oct 2013 10:33:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0126d493b62e1306db09e1019c05e0bfe84ae8e7
Gitweb:     http://git.kernel.org/tip/0126d493b62e1306db09e1019c05e0bfe84ae8e7
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Fri, 20 Sep 2013 07:40:42 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 4 Oct 2013 10:06:10 +0200

tools/perf/record: Add abort_tx,no_tx,in_tx branch filter options to perf record -j

Make perf record -j aware of the new in_tx,no_tx,abort_tx branch qualifiers.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1379688044-14173-5-git-send-email-andi@firstfloor.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
 
