Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbaIXO7w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:59:52 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59800 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbaIXO7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:59:49 -0400
Date: Wed, 24 Sep 2014 07:58:58 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-b76146851eeba6ad9fef982e8cf7cd8ebd4d30e1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, ak@linux.intel.com, acme@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, ak@linux.intel.com, tglx@linutronix.de,
        acme@kernel.org
In-Reply-To: <1409683455-29168-1-git-send-email-andi@firstfloor.org>
References: <1409683455-29168-1-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/intel:
  Remove incorrect model number from Haswell perf
Git-Commit-ID: b76146851eeba6ad9fef982e8cf7cd8ebd4d30e1
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

Commit-ID:  b76146851eeba6ad9fef982e8cf7cd8ebd4d30e1
Gitweb:     http://git.kernel.org/tip/b76146851eeba6ad9fef982e8cf7cd8ebd4d30e1
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Tue, 2 Sep 2014 11:44:11 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Sep 2014 14:48:15 +0200

perf/x86/intel: Remove incorrect model number from Haswell perf

71 is a Broadwell, not a Haswell. The model number was added
by mistake earlier.

Remove it for now, until it can be re-added later with
real Broadwell support.

In practice it does not cause a lot of issues because the Broadwell
PMU is very similar to Haswell, but some details were wrong,
and it's better to handle it correctly.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: eranian@google.com
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Link: http://lkml.kernel.org/r/1409683455-29168-1-git-send-email-andi@firstfloor.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 89bc750..f962e26 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2544,7 +2544,6 @@ __init int intel_pmu_init(void)
 	case 63:
 	case 69:
 	case 70:
-	case 71:
 		x86_pmu.late_ack = true;
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids, sizeof(hw_cache_event_ids));
 		memcpy(hw_cache_extra_regs, snb_hw_cache_extra_regs, sizeof(hw_cache_extra_regs));
