Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301AbaHLF7t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 01:59:49 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:52168 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbaHLF7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 01:59:48 -0400
Date: Tue, 12 Aug 2014 08:00:31 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com,
        zheng.z.yan@intel.com
Subject: [PATCH] perf/x86/uncore: export basic memory events for IVT IMC PMU
Message-ID: <20140812060031.GA25239@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch exposes two basic events for Ivytown IMC uncore PMU:

- cas_count_read: number of full-cache line reads to memory controller
- cas_count_write: number of full-cache line writes to memory controller

Those events use the same encoding as for SNB-EP, so reuse the same
event table. See specification in:

http://www.intel.com/content/dam/www/public/us/en/documents/manuals/xeon-e5-2600-v2-uncore-manual.pdf

By aggregating all the read and write events from all the memory controllers
of each processor socket, one can determine the total memory bandwidth utilization.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index cfc6f9d..800e087 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -1391,6 +1391,7 @@ static struct intel_uncore_type ivt_uncore_imc = {
 	.fixed_ctr_bits	= 48,
 	.fixed_ctr	= SNBEP_MC_CHy_PCI_PMON_FIXED_CTR,
 	.fixed_ctl	= SNBEP_MC_CHy_PCI_PMON_FIXED_CTL,
+	.event_descs	= snbep_uncore_imc_events,
 	IVT_UNCORE_PCI_COMMON_INIT(),
 };
 
-- 
1.7.9.5

