Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab3FGVWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 17:22:16 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:40470 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999Ab3FGVWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 17:22:15 -0400
Date: Fri, 7 Jun 2013 23:22:10 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, dzickus@redhat.com,
        ak@linux.intel.com, jolsa@redhat.com
Subject: [PATCH] perf,x86: fix broken PEBS-LL support on SNB-EP/IVB-EP
Message-ID: <20130607212210.GA11849@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixes broken support of PEBS-LL on SNB-EP/IVB-EP.
For some reason, the LDLAT extra reg definition for snb_ep
showed up as duplicate in the snb table.

This patch moves the definition of LDLAT back into the
snb_ep table.

Thanks to Don Zickus for tracking this one down.

Signed-off-by: Stephane Eranian <eranian@google.com>
---

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
 
