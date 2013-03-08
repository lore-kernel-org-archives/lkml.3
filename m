Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759556Ab3CHXYe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 18:24:34 -0500
Received: from mga09.intel.com ([134.134.136.24]:54889 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754510Ab3CHXYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 18:24:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,810,1355126400"; 
   d="scan'208";a="274492723"
From: Andi Kleen <andi@firstfloor.org>
To: a.p.zijlstra@chello.nl
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] perf, x86: Allow setting period 1
Date: Fri,  8 Mar 2013 15:24:30 -0800
Message-Id: <1362785070-12860-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

I had some requests for setting period 1, so that every event of something
is caught.  To my knowledge there is no limit to 1 on Intel hardware.
Just remove the check for minimum 2

If specific CPUs have problems we can black list them.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index bf0f01a..2b394ae 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -946,11 +946,6 @@ int x86_perf_event_set_period(struct perf_event *event)
 		hwc->last_period = period;
 		ret = 1;
 	}
-	/*
-	 * Quirk: certain CPUs dont like it if just 1 hw_event is left:
-	 */
-	if (unlikely(left < 2))
-		left = 2;
 
 	if (left > x86_pmu.max_period)
 		left = x86_pmu.max_period;
-- 
1.7.7.6

