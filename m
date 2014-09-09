Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781AbaIIO6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 10:58:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41115 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932575AbaIIOy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 10:54:29 -0400
Date: Tue, 9 Sep 2014 07:53:39 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-a08b6769d4c5e8d2a3192a45e40b3cdcca0da6a1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, ak@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1409332858-29039-1-git-send-email-andi@firstfloor.org>
References: <1409332858-29039-1-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86:
  Fix section mismatch in split uncore driver
Git-Commit-ID: a08b6769d4c5e8d2a3192a45e40b3cdcca0da6a1
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

Commit-ID:  a08b6769d4c5e8d2a3192a45e40b3cdcca0da6a1
Gitweb:     http://git.kernel.org/tip/a08b6769d4c5e8d2a3192a45e40b3cdcca0da6a1
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Fri, 29 Aug 2014 10:20:58 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 9 Sep 2014 06:53:08 +0200

perf/x86: Fix section mismatch in split uncore driver

The new split Intel uncore driver code that recently went
into tip added a section mismatch, which the build process
complains about.

uncore_pmu_register() can be called from uncore_pci_probe,()
which is not __init and can be called from pci driver ->probe.
I'm not fully sure if it's actually possible to call the probe
function later, but it seems safer to mark uncore_pmu_register
not __init.

This also fixes the warning.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1409332858-29039-1-git-send-email-andi@firstfloor.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 4785ee8..812ec5d 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -661,7 +661,7 @@ static struct attribute_group uncore_pmu_attr_group = {
 	.attrs = uncore_pmu_attrs,
 };
 
-static int __init uncore_pmu_register(struct intel_uncore_pmu *pmu)
+static int uncore_pmu_register(struct intel_uncore_pmu *pmu)
 {
 	int ret;
 
