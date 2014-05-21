Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362AbaEUKDw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 06:03:52 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:52241 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbaEUKBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 06:01:55 -0400
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, mpe@ellerman.id.au, benh@kernel.crashing.org
Subject: [V6 07/11] powerpc, perf: Change the name of HW PMU branch filter tracking variable
Date: Wed, 21 May 2014 15:29:52 +0530
Message-Id: <1400666396-1682-8-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1400666396-1682-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1400666396-1682-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052110-4790-0000-0000-0000018A105D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch simply changes the name of the variable from 'bhrb_filter' to
'bhrb_hw_filter' in order to add one more variable which will track SW
filters in generic powerpc book3s code which will be implemented in the
subsequent patch. This patch does not change any functionality.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 arch/powerpc/perf/core-book3s.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
index 66bea54..1d7e909 100644
--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -47,7 +47,7 @@ struct cpu_hw_events {
 	int n_txn_start;
 
 	/* BHRB bits */
-	u64				bhrb_filter;	/* BHRB HW branch filter */
+	u64				bhrb_hw_filter;	/* BHRB HW branch filter */
 	int				bhrb_users;
 	void				*bhrb_context;
 	struct	perf_branch_stack	bhrb_stack;
@@ -1298,7 +1298,7 @@ static void power_pmu_enable(struct pmu *pmu)
 
 	mb();
 	if (cpuhw->bhrb_users)
-		ppmu->config_bhrb(cpuhw->bhrb_filter);
+		ppmu->config_bhrb(cpuhw->bhrb_hw_filter);
 
 	write_mmcr0(cpuhw, mmcr0);
 
@@ -1405,7 +1405,7 @@ nocheck:
  out:
 	if (has_branch_stack(event)) {
 		power_pmu_bhrb_enable(event);
-		cpuhw->bhrb_filter = ppmu->bhrb_filter_map(
+		cpuhw->bhrb_hw_filter = ppmu->bhrb_filter_map(
 					event->attr.branch_sample_type);
 	}
 
@@ -1788,10 +1788,10 @@ static int power_pmu_event_init(struct perf_event *event)
 	err = power_check_constraints(cpuhw, events, cflags, n + 1);
 
 	if (has_branch_stack(event)) {
-		cpuhw->bhrb_filter = ppmu->bhrb_filter_map(
+		cpuhw->bhrb_hw_filter = ppmu->bhrb_filter_map(
 					event->attr.branch_sample_type);
 
-		if(cpuhw->bhrb_filter == -1)
+		if(cpuhw->bhrb_hw_filter == -1)
 			return -EOPNOTSUPP;
 	}
 
-- 
1.7.11.7

