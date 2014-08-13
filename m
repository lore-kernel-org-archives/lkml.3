Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbaHMIZw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 04:25:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52111 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbaHMIZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 04:25:46 -0400
Date: Wed, 13 Aug 2014 01:25:14 -0700
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-85a16ef66cc8a053de80aadf13722a2c1254d346@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, acme@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
        acme@kernel.org
In-Reply-To: <20140812060031.GA25239@quad>
References: <20140812060031.GA25239@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/uncore:
  Export basic memory events for IVT IMC PMU
Git-Commit-ID: 85a16ef66cc8a053de80aadf13722a2c1254d346
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

Commit-ID:  85a16ef66cc8a053de80aadf13722a2c1254d346
Gitweb:     http://git.kernel.org/tip/85a16ef66cc8a053de80aadf13722a2c1254d346
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Tue, 12 Aug 2014 08:00:31 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 13 Aug 2014 07:51:17 +0200

perf/x86/uncore: Export basic memory events for IVT IMC PMU

This patch exposes two basic events for Ivytown IMC uncore PMU:

- cas_count_read: number of full-cache line reads to memory controller
- cas_count_write: number of full-cache line writes to memory controller

Those events use the same encoding as for SNB-EP, so reuse the same
event table. See specification in:

http://www.intel.com/content/dam/www/public/us/en/documents/manuals/xeon-e5-2600-v2-uncore-manual.pdf

By aggregating all the read and write events from all the memory controllers
of each processor socket, one can determine the total memory bandwidth utilization.

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20140812060031.GA25239@quad
Cc: zheng.z.yan@intel.com
Cc: ak@linux.intel.com
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c b/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
index 30468f4..00bd048 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore_snbep.c
@@ -1422,6 +1422,7 @@ static struct intel_uncore_type ivt_uncore_imc = {
 	.fixed_ctr_bits	= 48,
 	.fixed_ctr	= SNBEP_MC_CHy_PCI_PMON_FIXED_CTR,
 	.fixed_ctl	= SNBEP_MC_CHy_PCI_PMON_FIXED_CTL,
+	.event_descs	= snbep_uncore_imc_events,
 	IVT_UNCORE_PCI_COMMON_INIT(),
 };
 
