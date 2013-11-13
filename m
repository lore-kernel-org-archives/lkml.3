Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759240Ab3KMPGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 10:06:23 -0500
Received: from us01smtp3.synopsys.com ([198.182.44.81]:64554 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755066Ab3KMPGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 10:06:20 -0500
From: Mischa Jonker <Mischa.Jonker@synopsys.com>
To: linux-kernel@vger.kernel.org
Cc: Mischa Jonker <Mischa.Jonker@synopsys.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH] ARC: perf: ARC 700 PMU doesn't support sampling events
Date: Wed, 13 Nov 2013 16:06:06 +0100
Message-Id: <1384355166-21409-1-git-send-email-mjonker@synopsys.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ARC 700 does not have an interrupt associated with it, and as
such it cannot trigger when a counter overflows. As the counters are
48 bit, it will usually take at least 100 days before a counter
overflows, so for mere counting of events, there is no problem.
Sampling is not supported though.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Mischa Jonker <mjonker@synopsys.com>
---
 arch/arc/kernel/perf_event.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arc/kernel/perf_event.c b/arch/arc/kernel/perf_event.c
index 759e5f3..e46d81f 100644
--- a/arch/arc/kernel/perf_event.c
+++ b/arch/arc/kernel/perf_event.c
@@ -99,6 +99,10 @@ static int arc_pmu_event_init(struct perf_event *event)
 	struct hw_perf_event *hwc = &event->hw;
 	int ret;
 
+	/* ARC 700 PMU does not support sampling events */
+	if (is_sampling_event(event))
+		return -ENOENT;
+
 	switch (event->attr.type) {
 	case PERF_TYPE_HARDWARE:
 		if (event->attr.config >= PERF_COUNT_HW_MAX)
-- 
1.7.9.5

