Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab3K0NzT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 08:55:19 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55047 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750953Ab3K0NzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 08:55:16 -0500
From: Will Deacon <will.deacon@arm.com>
To: linux-kernel@vger.kernel.org
Cc: Will Deacon <will.deacon@arm.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 2/2] Revert "ARM: 7556/1: perf: fix updated event period in response to PERF_EVENT_IOC_PERIOD"
Date: Wed, 27 Nov 2013 13:54:39 +0000
Message-Id: <1385560479-11014-2-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1385560479-11014-1-git-send-email-will.deacon@arm.com>
References: <1385560479-11014-1-git-send-email-will.deacon@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 3581fe0ef37ce12ac7a4f74831168352ae848edc.

Updates to the handling of PERF_EVENT_IOC_PERIOD in the core code mean
we no longer have to play this horrible game.

Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 arch/arm/kernel/perf_event.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index bc3f2efa0d86..789d846a9184 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -99,10 +99,6 @@ int armpmu_event_set_period(struct perf_event *event)
 	s64 period = hwc->sample_period;
 	int ret = 0;
 
-	/* The period may have been changed by PERF_EVENT_IOC_PERIOD */
-	if (unlikely(period != hwc->last_period))
-		left = period - (hwc->last_period - left);
-
 	if (unlikely(left <= -period)) {
 		left = period;
 		local64_set(&hwc->period_left, left);
-- 
1.8.2.2

