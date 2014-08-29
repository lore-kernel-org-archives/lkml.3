Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbaH2RXg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 13:23:36 -0400
Received: from mga14.intel.com ([192.55.52.115]:25994 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753268AbaH2RXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 13:23:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,425,1406617200"; 
   d="scan'208";a="583540254"
From: Andi Kleen <andi@firstfloor.org>
To: peterz@infradead.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        tglx@linutronix.de, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] perf, x86: Fix section mismatch in split uncore driver
Date: Fri, 29 Aug 2014 10:20:58 -0700
Message-Id: <1409332858-29039-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The new split Intel uncore driver code that recently went
into tip added a section mismatch, which the build process
complains about.

uncore_pmu_register can be called from uncore_pci_probe,
which is not __init and can be called from pci driver ->probe.
I'm not fully sure if it's actually possible to call the probe
function later, but it seems safer to mark uncore_pmu_register
not __init.

This also fixes the warning.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index b0c48bf..42d00e5 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -661,7 +661,7 @@ static struct attribute_group uncore_pmu_attr_group = {
 	.attrs = uncore_pmu_attrs,
 };
 
-static int __init uncore_pmu_register(struct intel_uncore_pmu *pmu)
+static int uncore_pmu_register(struct intel_uncore_pmu *pmu)
 {
 	int ret;
 
-- 
1.9.3

