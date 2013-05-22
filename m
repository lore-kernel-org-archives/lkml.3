Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab3EVFs0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 01:48:26 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:44399 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab3EVFsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 01:48:21 -0400
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Cc: michael@ellerman.id.au, mikey@neuling.org
Subject: [PATCH 2/2] powerpc, perf: BHRB filter configuration should follow the task
Date: Wed, 22 May 2013 11:17:47 +0530
Message-Id: <1369201667-9048-3-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1369201667-9048-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1369201667-9048-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052205-8878-0000-0000-000007356063
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the task moves around the system, the corresponding cpuhw
per cpu strcuture should be popullated with the BHRB filter
request value so that PMU could be configured appropriately with
that during the next call into power_pmu_enable().

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 arch/powerpc/perf/core-book3s.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
index 426180b..48c68a8 100644
--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -1122,8 +1122,11 @@ nocheck:
 
 	ret = 0;
  out:
-	if (has_branch_stack(event))
+	if (has_branch_stack(event)) {
 		power_pmu_bhrb_enable(event);
+		cpuhw->bhrb_filter = ppmu->bhrb_filter_map(
+					event->attr.branch_sample_type);
+	}
 
 	perf_pmu_enable(event->pmu);
 	local_irq_restore(flags);
-- 
1.7.11.7

