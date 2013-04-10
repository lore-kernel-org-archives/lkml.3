Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936673Ab3DJNz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 09:55:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59524 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760323Ab3DJNz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 09:55:57 -0400
Date: Wed, 10 Apr 2013 06:55:45 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-f8378f5259647710f0b4ecb814b0a1b0d9040de0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, ak@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1362784968-12542-1-git-send-email-andi@firstfloor.org>
References: <1362784968-12542-1-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86:
  Add Sandy Bridge constraints for CYCLE_ACTIVITY.*
Git-Commit-ID: f8378f5259647710f0b4ecb814b0a1b0d9040de0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 10 Apr 2013 06:55:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f8378f5259647710f0b4ecb814b0a1b0d9040de0
Gitweb:     http://git.kernel.org/tip/f8378f5259647710f0b4ecb814b0a1b0d9040de0
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Fri, 8 Mar 2013 15:22:48 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 10 Apr 2013 15:00:07 +0200

perf/x86: Add Sandy Bridge constraints for CYCLE_ACTIVITY.*

Add CYCLE_ACTIVITY.CYCLES_NO_DISPATCH/CYCLES_L1D_PENDING constraints.

These recently documented events have restrictions to counter
0-3 and counter 2 respectively. The perf scheduler needs to know
that to schedule them correctly.

IvyBridge already has the necessary constraints.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: a.p.zijlstra@chello.nl
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1362784968-12542-1-git-send-email-andi@firstfloor.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index e84c4ba..2ad2374 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -109,6 +109,8 @@ static struct event_constraint intel_snb_event_constraints[] __read_mostly =
 	INTEL_EVENT_CONSTRAINT(0x48, 0x4), /* L1D_PEND_MISS.PENDING */
 	INTEL_UEVENT_CONSTRAINT(0x01c0, 0x2), /* INST_RETIRED.PREC_DIST */
 	INTEL_EVENT_CONSTRAINT(0xcd, 0x8), /* MEM_TRANS_RETIRED.LOAD_LATENCY */
+	INTEL_UEVENT_CONSTRAINT(0x04a3, 0xf), /* CYCLE_ACTIVITY.CYCLES_NO_DISPATCH */
+	INTEL_UEVENT_CONSTRAINT(0x02a3, 0x4), /* CYCLE_ACTIVITY.CYCLES_L1D_PENDING */
 	EVENT_CONSTRAINT_END
 };
 
