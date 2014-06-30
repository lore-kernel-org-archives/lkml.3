Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021AbaF3Oqa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 10:46:30 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:36298 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbaF3Oq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 10:46:29 -0400
Date: Mon, 30 Jun 2014 16:46:24 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com,
        zheng.z.yan@intel.com
Subject: [PATCH] perf/x86/uncore: fix SNB-EP/IVT Cbox filter mappings
Message-ID: <20140630144624.GA2604@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixes the SNB-EP and IVT Cbox filter mapping
table. The table controls which filters are supported by
which events. There were several mistakes in those tables
causing some filters to be ignored, such as NID on
TOR_INSERTS.

Signed-off-by: Stephane Eranian <eranian@google.com>
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
-- 
1.8.3.2

