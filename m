Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab3IMUQu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 16:16:50 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:35567 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777Ab3IMUQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 16:16:48 -0400
Date: Fri, 13 Sep 2013 13:16:46 -0700
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com,
        zheng.z.yan@intel.com
Subject: [PATCH] perf,x86: mark MEM_LOAD_UOPS_MISS_RETIRED as precise on SNB
Message-ID: <20130913201646.GA23981@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Intel SNB (SNB, SNB-EP), the event MEM_LOAD_UOPS_MISS_RETIRED
supports PEBS. It was missing for the SNB PEBS event constraint
table thereby preventing any measurement with PEBS for it.

This patch adds the event to the PEBS table for SNB.

WARNING: it should be noted that this event like a few others are subject
to the erratum BT241 for Xeon E5 (SNB-EP). As such, the event may undercount
when used with PEBS unless the workaround is implemented. But without this
patch and just the workaround, the kernel would not allow precise sampling
on this event. BT241 is documented in:
http://www.intel.com/content/dam/www/public/us/en/documents/specification-updates/xeon-e5-family-spec-update.pdf

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index f364c13..63f3f01 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -596,6 +596,7 @@ struct event_constraint intel_snb_pebs_event_constraints[] = {
 	INTEL_EVENT_CONSTRAINT(0xd0, 0xf),    /* MEM_UOP_RETIRED.* */
 	INTEL_EVENT_CONSTRAINT(0xd1, 0xf),    /* MEM_LOAD_UOPS_RETIRED.* */
 	INTEL_EVENT_CONSTRAINT(0xd2, 0xf),    /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xd3, 0xf),    /* MEM_LOAD_UOPS_LLC_MISS_RETIRED.* */
 	INTEL_UEVENT_CONSTRAINT(0x02d4, 0xf), /* MEM_LOAD_UOPS_MISC_RETIRED.LLC_MISS */
 	EVENT_CONSTRAINT_END
 };
