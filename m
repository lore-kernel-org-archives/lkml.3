Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757395Ab3FSSjD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:39:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40022 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756845Ab3FSSjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:39:01 -0400
Date: Wed, 19 Jun 2013 11:38:32 -0700
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-f1a527899ef0a8a241eb3bea619eb2e29d797f44@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <20130607212210.GA11849@quad>
References: <20130607212210.GA11849@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86: Fix broken PEBS-LL support on SNB-EP/
 IVB-EP
Git-Commit-ID: f1a527899ef0a8a241eb3bea619eb2e29d797f44
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 19 Jun 2013 11:38:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f1a527899ef0a8a241eb3bea619eb2e29d797f44
Gitweb:     http://git.kernel.org/tip/f1a527899ef0a8a241eb3bea619eb2e29d797f44
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Fri, 7 Jun 2013 23:22:10 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 19 Jun 2013 12:44:16 +0200

perf/x86: Fix broken PEBS-LL support on SNB-EP/IVB-EP

This patch fixes broken support of PEBS-LL on SNB-EP/IVB-EP.
For some reason, the LDLAT extra reg definition for snb_ep
showed up as duplicate in the snb table.

This patch moves the definition of LDLAT back into the
snb_ep table.

Thanks to Don Zickus for tracking this one down.

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20130607212210.GA11849@quad
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index f60d41f..a9e2207 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -165,13 +165,13 @@ static struct extra_reg intel_snb_extra_regs[] __read_mostly = {
 	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0x3f807f8fffull, RSP_0),
 	INTEL_EVENT_EXTRA_REG(0xbb, MSR_OFFCORE_RSP_1, 0x3f807f8fffull, RSP_1),
 	INTEL_UEVENT_PEBS_LDLAT_EXTRA_REG(0x01cd),
-	INTEL_UEVENT_PEBS_LDLAT_EXTRA_REG(0x01cd),
 	EVENT_EXTRA_END
 };
 
 static struct extra_reg intel_snbep_extra_regs[] __read_mostly = {
 	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0x3fffff8fffull, RSP_0),
 	INTEL_EVENT_EXTRA_REG(0xbb, MSR_OFFCORE_RSP_1, 0x3fffff8fffull, RSP_1),
+	INTEL_UEVENT_PEBS_LDLAT_EXTRA_REG(0x01cd),
 	EVENT_EXTRA_END
 };
 
