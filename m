Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475Ab3ILLLs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 07:11:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34441 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab3ILLLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 07:11:43 -0400
Date: Thu, 12 Sep 2013 04:11:27 -0700
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-6113af14c82726d5a2993a7ba238df24c990a5ee@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <20130911152222.GA28761@google.com>
References: <20130911152222.GA28761@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86: Add constraint for IVB CYCLE_ACTIVITY
 :CYCLES_LDM_PENDING
Git-Commit-ID: 6113af14c82726d5a2993a7ba238df24c990a5ee
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 12 Sep 2013 04:11:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6113af14c82726d5a2993a7ba238df24c990a5ee
Gitweb:     http://git.kernel.org/tip/6113af14c82726d5a2993a7ba238df24c990a5ee
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Wed, 11 Sep 2013 08:22:22 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 12 Sep 2013 07:58:26 +0200

perf/x86: Add constraint for IVB CYCLE_ACTIVITY:CYCLES_LDM_PENDING

The IvyBridge event CYCLE_ACTIVITY:CYCLES_LDM_PENDING can only
be measured on counters 0-3 when HT is off. When HT is on, you
only have counters 0-3.

If you program it on the eight counters for 1s on a 3GHz
IVB laptop running a noploop, you see:

           2 747 527 CYCLE_ACTIVITY:CYCLES_LDM_PENDING
           2 747 527 CYCLE_ACTIVITY:CYCLES_LDM_PENDING
           2 747 527 CYCLE_ACTIVITY:CYCLES_LDM_PENDING
           2 747 527 CYCLE_ACTIVITY:CYCLES_LDM_PENDING
       3 280 563 608 CYCLE_ACTIVITY:CYCLES_LDM_PENDING
       3 280 563 608 CYCLE_ACTIVITY:CYCLES_LDM_PENDING
       3 280 563 608 CYCLE_ACTIVITY:CYCLES_LDM_PENDING
       3 280 563 608 CYCLE_ACTIVITY:CYCLES_LDM_PENDING

Clearly the last 4 values are bogus.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: peterz@infradead.org
Cc: ak@linux.intel.com
Cc: zheng.z.yan@intel.com
Cc: dhsharp@google.com
Link: http://lkml.kernel.org/r/20130911152222.GA28761@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 0abf674..c62d883 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -124,6 +124,7 @@ static struct event_constraint intel_ivb_event_constraints[] __read_mostly =
 	INTEL_UEVENT_CONSTRAINT(0x0148, 0x4), /* L1D_PEND_MISS.PENDING */
 	INTEL_UEVENT_CONSTRAINT(0x0279, 0xf), /* IDQ.EMTPY */
 	INTEL_UEVENT_CONSTRAINT(0x019c, 0xf), /* IDQ_UOPS_NOT_DELIVERED.CORE */
+	INTEL_UEVENT_CONSTRAINT(0x02a3, 0xf), /* CYCLE_ACTIVITY.CYCLES_LDM_PENDING */
 	INTEL_UEVENT_CONSTRAINT(0x04a3, 0xf), /* CYCLE_ACTIVITY.CYCLES_NO_EXECUTE */
 	INTEL_UEVENT_CONSTRAINT(0x05a3, 0xf), /* CYCLE_ACTIVITY.STALLS_L2_PENDING */
 	INTEL_UEVENT_CONSTRAINT(0x06a3, 0xf), /* CYCLE_ACTIVITY.STALLS_LDM_PENDING */
