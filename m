Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbaEHKlr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:41:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33061 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233AbaEHKlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:41:45 -0400
Date: Thu, 8 May 2014 03:40:50 -0700
From: "tip-bot for Yan, Zheng" <tipbot@zytor.com>
Message-ID: <tip-a4b4f11b2783ec678cccb4ce7e4ce9665aa04a24@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, acme@kernel.org,
        zheng.z.yan@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, acme@kernel.org,
        zheng.z.yan@intel.com, tglx@linutronix.de
In-Reply-To: <1398755081-12471-1-git-send-email-zheng.z.yan@intel.com>
References: <1398755081-12471-1-git-send-email-zheng.z.yan@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86/intel: Fix Silvermont'
 s event constraints
Git-Commit-ID: a4b4f11b2783ec678cccb4ce7e4ce9665aa04a24
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

Commit-ID:  a4b4f11b2783ec678cccb4ce7e4ce9665aa04a24
Gitweb:     http://git.kernel.org/tip/a4b4f11b2783ec678cccb4ce7e4ce9665aa04a24
Author:     Yan, Zheng <zheng.z.yan@intel.com>
AuthorDate: Tue, 29 Apr 2014 15:04:41 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 7 May 2014 11:33:16 +0200

perf/x86/intel: Fix Silvermont's event constraints

Event 0x013c is not the same as fixed counter2, remove it from
Silvermont's event constraints.

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1398755081-12471-1-git-send-email-zheng.z.yan@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index aa333d9..adb02aa 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -169,7 +169,6 @@ static struct event_constraint intel_slm_event_constraints[] __read_mostly =
 {
 	FIXED_EVENT_CONSTRAINT(0x00c0, 0), /* INST_RETIRED.ANY */
 	FIXED_EVENT_CONSTRAINT(0x003c, 1), /* CPU_CLK_UNHALTED.CORE */
-	FIXED_EVENT_CONSTRAINT(0x013c, 2), /* CPU_CLK_UNHALTED.REF */
 	FIXED_EVENT_CONSTRAINT(0x0300, 2), /* pseudo CPU_CLK_UNHALTED.REF */
 	EVENT_CONSTRAINT_END
 };
