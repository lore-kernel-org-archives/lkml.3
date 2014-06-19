Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183AbaFSMiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 08:38:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57576 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458AbaFSMiR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 08:38:17 -0400
Date: Thu, 19 Jun 2014 05:37:09 -0700
From: tip-bot for Vince Weaver <tipbot@zytor.com>
Message-ID: <tip-2cc9e588b0ff80c209c59a3e369c73e591535ba8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, grant.likely@linaro.org,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org, acme@kernel.org,
        vincent.weaver@maine.edu, vgupta@synopsys.com, robh+dt@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, grant.likely@linaro.org,
        paulus@samba.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
        acme@kernel.org, vgupta@synopsys.com, vincent.weaver@maine.edu,
        robh+dt@kernel.org, tglx@linutronix.de
In-Reply-To: <alpine.DEB.2.10.1406150159280.16738@vincent-weaver-1.umelst.maine.edu>
References: <alpine.DEB.2.10.1406150159280.16738@vincent-weaver-1.umelst.maine.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] arc, perf: Use common PMU interrupt disabled code
Git-Commit-ID: 2cc9e588b0ff80c209c59a3e369c73e591535ba8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2cc9e588b0ff80c209c59a3e369c73e591535ba8
Gitweb:     http://git.kernel.org/tip/2cc9e588b0ff80c209c59a3e369c73e591535ba8
Author:     Vince Weaver <vincent.weaver@maine.edu>
AuthorDate: Sun, 15 Jun 2014 02:00:18 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 18 Jun 2014 18:43:44 +0200

arc, perf: Use common PMU interrupt disabled code

Transition to using the new generic PERF_PMU_CAP_NO_INTERRUPT method for
failing a sampling event when no PMU interrupt is available.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
Acked-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Rob Herring <robh+dt@kernel.org>
Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1406150159280.16738@vincent-weaver-1.umelst.maine.edu
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/arc/kernel/perf_event.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/arc/kernel/perf_event.c b/arch/arc/kernel/perf_event.c
index 63177e4..b9a5685 100644
--- a/arch/arc/kernel/perf_event.c
+++ b/arch/arc/kernel/perf_event.c
@@ -99,10 +99,6 @@ static int arc_pmu_event_init(struct perf_event *event)
 	struct hw_perf_event *hwc = &event->hw;
 	int ret;
 
-	/* ARC 700 PMU does not support sampling events */
-	if (is_sampling_event(event))
-		return -ENOENT;
-
 	switch (event->attr.type) {
 	case PERF_TYPE_HARDWARE:
 		if (event->attr.config >= PERF_COUNT_HW_MAX)
@@ -298,6 +294,9 @@ static int arc_pmu_device_probe(struct platform_device *pdev)
 		.read		= arc_pmu_read,
 	};
 
+	/* ARC 700 PMU does not support sampling events */
+	arc_pmu->pmu.capabilities |= PERF_PMU_CAP_NO_INTERRUPT;
+
 	ret = perf_pmu_register(&arc_pmu->pmu, pdev->name, PERF_TYPE_RAW);
 
 	return ret;
