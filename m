Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495AbaBJRor (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:44:47 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:63563 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753423AbaBJRon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:44:43 -0500
From: Mark Rutland <mark.rutland@arm.com>
To: linux-kernel@vger.kernel.org
Cc: will.deacon@arm.com, dave.martin@arm.com,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 1/7] perf: fix prototype of find_pmu_context
Date: Mon, 10 Feb 2014 17:44:18 +0000
Message-Id: <1392054264-23570-2-git-send-email-mark.rutland@arm.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1392054264-23570-1-git-send-email-mark.rutland@arm.com>
References: <1392054264-23570-1-git-send-email-mark.rutland@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For some reason find_pmu_context is defined as returning void* rather
than a __percpu struct perf_cpu_context*. As all the requisite types are
defined in advance there's no reason to keep it that way.

This patch modifies the prototype of pmu_find_context to return a
__percpu struct perf_cpu_context*.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Dave Martin <Dave.Martin@arm.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 56003c6..08659d1 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6294,7 +6294,7 @@ static int perf_event_idx_default(struct perf_event *event)
  * Ensures all contexts with the same task_ctx_nr have the same
  * pmu_cpu_context too.
  */
-static void *find_pmu_context(int ctxn)
+static struct perf_cpu_context __percpu *find_pmu_context(int ctxn)
 {
 	struct pmu *pmu;
 
-- 
1.8.1.1

