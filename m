Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbaBSNKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 08:10:16 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:60250 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbaBSNKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 08:10:14 -0500
Date: Wed, 19 Feb 2014 14:10:18 +0100
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com,
        zheng.z.yan@intel.com
Subject: [PATCH] perf/x86/uncore: Fix IVT/SNB-EP uncore CBOX NID filter table
Message-ID: <20140219131018.GA24475@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch updates the CBOX PMU filters mapping tables for SNB-EP
and IVT (model 45 and 62 respectively).

The NID umask always comes in addition to another umask.
When set, the NID filter is applied.

The current mapping tables were missing some code/umask
combinations to account for the NID umask. This patch
fixes that.
    
Signed-off-by: Stephane Eranian <eranian@google.com>

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -501,8 +501,11 @@ static struct extra_reg snbep_uncore_cbox_extra_regs[] = {
 	SNBEP_CBO_EVENT_EXTRA_REG(SNBEP_CBO_PMON_CTL_TID_EN,
 				  SNBEP_CBO_PMON_CTL_TID_EN, 0x1),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x0334, 0xffff, 0x4),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4334, 0xffff, 0x6),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x0534, 0xffff, 0x4),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4534, 0xffff, 0x6),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x0934, 0xffff, 0x4),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4934, 0xffff, 0x6),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x4134, 0xffff, 0x6),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x0135, 0xffff, 0x8),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x0335, 0xffff, 0x8),
@@ -1178,10 +1181,15 @@ static struct extra_reg ivt_uncore_cbox_extra_regs[] = {
 	SNBEP_CBO_EVENT_EXTRA_REG(SNBEP_CBO_PMON_CTL_TID_EN,
 				  SNBEP_CBO_PMON_CTL_TID_EN, 0x1),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x1031, 0x10ff, 0x2),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x1134, 0xffff, 0x4),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4134, 0xffff, 0xc),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x5134, 0xffff, 0xc),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x0334, 0xffff, 0x4),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4334, 0xffff, 0xc),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x0534, 0xffff, 0x4),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4534, 0xffff, 0xc),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x0934, 0xffff, 0x4),
-	SNBEP_CBO_EVENT_EXTRA_REG(0x4134, 0xffff, 0xc),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4934, 0xffff, 0xc),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x0135, 0xffff, 0x10),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x0335, 0xffff, 0x10),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x2135, 0xffff, 0x10),
