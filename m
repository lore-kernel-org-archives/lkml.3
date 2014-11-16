Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756AbaKPMfd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 07:35:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35622 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732AbaKPMfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 07:35:30 -0500
Date: Sun, 16 Nov 2014 04:34:52 -0800
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-7550ddffe4c8040db31c66e5bd64531e2916bbf1@git.kernel.org>
Cc: kan.liang@intel.com, maria.n.dimakopoulou@gmail.com,
        linux-kernel@vger.kernel.org, eranian@google.com, mingo@kernel.org,
        peterz@infradead.org, ak@linux.intel.com, junk@eslaf.co.uk,
        tglx@linutronix.de, hpa@zytor.com
Reply-To: ak@linux.intel.com, peterz@infradead.org, tglx@linutronix.de,
        junk@eslaf.co.uk, hpa@zytor.com, kan.liang@intel.com,
        linux-kernel@vger.kernel.org, maria.n.dimakopoulou@gmail.com,
        eranian@google.com, mingo@kernel.org
In-Reply-To: <1411569288-5627-1-git-send-email-andi@firstfloor.org>
References: <1411569288-5627-1-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86: Add INTEL_FLAGS_UEVENT_CONSTRAINT
Git-Commit-ID: 7550ddffe4c8040db31c66e5bd64531e2916bbf1
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

Commit-ID:  7550ddffe4c8040db31c66e5bd64531e2916bbf1
Gitweb:     http://git.kernel.org/tip/7550ddffe4c8040db31c66e5bd64531e2916bbf1
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Wed, 24 Sep 2014 07:34:46 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 16 Nov 2014 11:41:54 +0100

perf/x86: Add INTEL_FLAGS_UEVENT_CONSTRAINT

Add a FLAGS_UEVENT_CONSTRAINT macro that allows us to
match on event+umask, and in additional all flags.

This is needed to ensure the INV and CMASK fields
are zero for specific events, as this can cause undefined
behavior.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Kan Liang <kan.liang@intel.com>
Cc: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Cc: Mark Davies <junk@eslaf.co.uk>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1411569288-5627-1-git-send-email-andi@firstfloor.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index fc5eb39..4e6cdb0 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -253,6 +253,10 @@ struct cpu_hw_events {
 #define INTEL_UEVENT_CONSTRAINT(c, n)	\
 	EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK)
 
+/* Like UEVENT_CONSTRAINT, but match flags too */
+#define INTEL_FLAGS_UEVENT_CONSTRAINT(c, n)	\
+	EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK|X86_ALL_EVENT_FLAGS)
+
 #define INTEL_PLD_CONSTRAINT(c, n)	\
 	__EVENT_CONSTRAINT(c, n, INTEL_ARCH_EVENT_MASK|X86_ALL_EVENT_FLAGS, \
 			   HWEIGHT(n), 0, PERF_X86_EVENT_PEBS_LDLAT)
