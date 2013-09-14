Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab3INHBX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 03:01:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54993 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab3INHBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 03:01:21 -0400
Date: Sat, 14 Sep 2013 00:00:59 -0700
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-9d8e3f9693245415db0b7c58551a91fa9fd1f9c7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <20130913201646.GA23981@google.com>
References: <20130913201646.GA23981@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] perf/x86/intel:
  Mark MEM_LOAD_UOPS_MISS_RETIRED as precise on SNB
Git-Commit-ID: 9d8e3f9693245415db0b7c58551a91fa9fd1f9c7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 14 Sep 2013 00:01:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9d8e3f9693245415db0b7c58551a91fa9fd1f9c7
Gitweb:     http://git.kernel.org/tip/9d8e3f9693245415db0b7c58551a91fa9fd1f9c7
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Fri, 13 Sep 2013 13:16:46 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 14 Sep 2013 08:00:18 +0200

perf/x86/intel: Mark MEM_LOAD_UOPS_MISS_RETIRED as precise on SNB

On Intel SNB (SNB, SNB-EP), the event MEM_LOAD_UOPS_MISS_RETIRED
supports PEBS. It was missing for the SNB PEBS event constraint
table thereby preventing any measurement with PEBS for it.

This patch adds the event to the PEBS table for SNB.

WARNING: it should be noted that this event like a few others
are subject to the erratum BT241 for Xeon E5 (SNB-EP). As such,
the event may undercount when used with PEBS unless the
workaround is implemented. But without this patch and just the
workaround, the kernel would not allow precise sampling on this
event. BT241 is documented in:

  http://www.intel.com/content/dam/www/public/us/en/documents/specification-updates/xeon-e5-family-spec-update.pdf

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: peterz@infradead.org
Cc: ak@linux.intel.com
Cc: zheng.z.yan@intel.com
Link: http://lkml.kernel.org/r/20130913201646.GA23981@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 3065c57..4ab70ac 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -558,6 +558,7 @@ struct event_constraint intel_snb_pebs_event_constraints[] = {
 	INTEL_EVENT_CONSTRAINT(0xd0, 0xf),    /* MEM_UOP_RETIRED.* */
 	INTEL_EVENT_CONSTRAINT(0xd1, 0xf),    /* MEM_LOAD_UOPS_RETIRED.* */
 	INTEL_EVENT_CONSTRAINT(0xd2, 0xf),    /* MEM_LOAD_UOPS_LLC_HIT_RETIRED.* */
+	INTEL_EVENT_CONSTRAINT(0xd3, 0xf),    /* MEM_LOAD_UOPS_LLC_MISS_RETIRED.* */
 	INTEL_UEVENT_CONSTRAINT(0x02d4, 0xf), /* MEM_LOAD_UOPS_MISC_RETIRED.LLC_MISS */
 	EVENT_CONSTRAINT_END
 };
