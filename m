Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbaJVP3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:29:45 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:38796 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611AbaJVP3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:29:39 -0400
From: Robert Bragg <robert@sixbynine.org>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Rob Clark <robdclark@gmail.com>,
        Samuel Pitoiset <samuel.pitoiset@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>, Robert Bragg <robert@sixbynine.org>
Subject: [RFC PATCH 1/3] perf: export perf_event_overflow
Date: Wed, 22 Oct 2014 16:28:49 +0100
Message-Id: <1413991731-20628-2-git-send-email-robert@sixbynine.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1413991731-20628-1-git-send-email-robert@sixbynine.org>
References: <1413991731-20628-1-git-send-email-robert@sixbynine.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To support pmu drivers in loadable modules, such as the i915 driver

Signed-off-by: Robert Bragg <robert@sixbynine.org>
---
 kernel/events/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 1cf24b3..9449180 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5478,6 +5478,7 @@ int perf_event_overflow(struct perf_event *event,
 {
 	return __perf_event_overflow(event, 1, data, regs);
 }
+EXPORT_SYMBOL_GPL(perf_event_overflow);
 
 /*
  * Generic software event infrastructure
-- 
2.1.2

