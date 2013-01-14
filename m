Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558Ab3ANRlA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 12:41:00 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:35838 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756254Ab3ANRk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 12:40:59 -0500
Date: Mon, 14 Jan 2013 17:40:55 +0000
From: Cong Ding <dinggnu@gmail.com>
To: Will Deacon <will.deacon@arm.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] arm: kernel/perf_event_cpu.c: remove unnecessary null
 pointer dereference check
Message-ID: <20130114174055.GB917@gmail.com>
References: <1358183933-29160-1-git-send-email-dinggnu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358183933-29160-1-git-send-email-dinggnu@gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The NULL pointer check is not necessary.  cpu_pmu_init() is called
after cpu_pmu has already been dereferenced by its caller:

	cpu_pmu = pmu;
	cpu_pmu->plat_device = pdev;
	cpu_pmu_init(cpu_pmu);

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 arch/arm/kernel/perf_event_cpu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/kernel/perf_event_cpu.c b/arch/arm/kernel/perf_event_cpu.c
index efa5295..43496f6 100644
--- a/arch/arm/kernel/perf_event_cpu.c
+++ b/arch/arm/kernel/perf_event_cpu.c
@@ -147,7 +147,7 @@ static void cpu_pmu_init(struct arm_pmu *cpu_pmu)
 	cpu_pmu->free_irq	= cpu_pmu_free_irq;
 
 	/* Ensure the PMU has sane values out of reset. */
-	if (cpu_pmu && cpu_pmu->reset)
+	if (cpu_pmu->reset)
 		on_each_cpu(cpu_pmu->reset, cpu_pmu, 1);
 }
 
-- 
1.7.4.5

