Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935061AbaGPTUT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:20:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44277 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760456AbaGPTUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:20:10 -0400
Date: Wed, 16 Jul 2014 12:19:39 -0700
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-7711fe4fc2606712125cff1a55ce00df2ae0f1fb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        acme@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, acme@kernel.org, tglx@linutronix.de
In-Reply-To: <20140630144624.GA2604@quad>
References: <20140630144624.GA2604@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86/intel/uncore: Fix SNB-EP/
 IVT Cbox filter mappings
Git-Commit-ID: 7711fe4fc2606712125cff1a55ce00df2ae0f1fb
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

Commit-ID:  7711fe4fc2606712125cff1a55ce00df2ae0f1fb
Gitweb:     http://git.kernel.org/tip/7711fe4fc2606712125cff1a55ce00df2ae0f1fb
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Mon, 30 Jun 2014 16:46:24 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 16 Jul 2014 13:18:41 +0200

perf/x86/intel/uncore: Fix SNB-EP/IVT Cbox filter mappings

This patch fixes the SNB-EP and IVT Cbox filter mapping
table. The table controls which filters are supported by
which events. There were several mistakes in those tables
causing some filters to be ignored, such as NID on
TOR_INSERTS.

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: zheng.z.yan@intel.com
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140630144624.GA2604@quad
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 65bbbea..ae6552a 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -550,16 +550,16 @@ static struct extra_reg snbep_uncore_cbox_extra_regs[] = {
 	SNBEP_CBO_EVENT_EXTRA_REG(0x4134, 0xffff, 0x6),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x0135, 0xffff, 0x8),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x0335, 0xffff, 0x8),
-	SNBEP_CBO_EVENT_EXTRA_REG(0x4135, 0xffff, 0xc),
-	SNBEP_CBO_EVENT_EXTRA_REG(0x4335, 0xffff, 0xc),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4135, 0xffff, 0xa),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4335, 0xffff, 0xa),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x4435, 0xffff, 0x2),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x4835, 0xffff, 0x2),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x4a35, 0xffff, 0x2),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x5035, 0xffff, 0x2),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x0136, 0xffff, 0x8),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x0336, 0xffff, 0x8),
-	SNBEP_CBO_EVENT_EXTRA_REG(0x4136, 0xffff, 0xc),
-	SNBEP_CBO_EVENT_EXTRA_REG(0x4336, 0xffff, 0xc),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4136, 0xffff, 0xa),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4336, 0xffff, 0xa),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x4436, 0xffff, 0x2),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x4836, 0xffff, 0x2),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x4a36, 0xffff, 0x2),
@@ -1222,6 +1222,7 @@ static struct extra_reg ivt_uncore_cbox_extra_regs[] = {
 	SNBEP_CBO_EVENT_EXTRA_REG(SNBEP_CBO_PMON_CTL_TID_EN,
 				  SNBEP_CBO_PMON_CTL_TID_EN, 0x1),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x1031, 0x10ff, 0x2),
+
 	SNBEP_CBO_EVENT_EXTRA_REG(0x1134, 0xffff, 0x4),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x4134, 0xffff, 0xc),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x5134, 0xffff, 0xc),
@@ -1245,7 +1246,7 @@ static struct extra_reg ivt_uncore_cbox_extra_regs[] = {
 	SNBEP_CBO_EVENT_EXTRA_REG(0x8335, 0xffff, 0x10),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x0136, 0xffff, 0x10),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x0336, 0xffff, 0x10),
-	SNBEP_CBO_EVENT_EXTRA_REG(0x2336, 0xffff, 0x10),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x2136, 0xffff, 0x10),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x2336, 0xffff, 0x10),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x4136, 0xffff, 0x18),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x4336, 0xffff, 0x18),
