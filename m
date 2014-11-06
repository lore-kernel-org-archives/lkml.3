Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866AbaKFRla (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:41:30 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:45174 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbaKFRk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 12:40:58 -0500
From: dirk.brandewie@gmail.com
X-Google-Original-From: dirk.j.brandewie@intel.com
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: rjw@rjwysocki.net, dirk.brandweie@gmail.com, robert.a.kasten@intel.com,
        charles.d.prestopine@intel.com, x86@kernel.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>
Subject: [PATCH 1/2] x86: Add support for Intel HWP feature detection.
Date: Thu,  6 Nov 2014 09:40:46 -0800
Message-Id: <1415295647-4063-2-git-send-email-dirk.j.brandewie@intel.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1415295647-4063-1-git-send-email-dirk.j.brandewie@intel.com>
References: <1415295647-4063-1-git-send-email-dirk.j.brandewie@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

Add support of Hardware Managed Performance States (HWP) described in Volume 3
section 14.4 of the SDM.

One bit CPUID.06H:EAX[bit 7] expresses the presence of the HWP feature on
the processor. The remaining bits CPUID.06H:EAX[bit 8-11] denote the
presense of various HWP features.

Cc: x86@kernel.org
Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
---
 arch/x86/include/asm/cpufeature.h | 5 +++++
 arch/x86/kernel/cpu/scattered.c   | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 0bb1335..aede2c3 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -189,6 +189,11 @@
 #define X86_FEATURE_DTHERM	( 7*32+ 7) /* Digital Thermal Sensor */
 #define X86_FEATURE_HW_PSTATE	( 7*32+ 8) /* AMD HW-PState */
 #define X86_FEATURE_PROC_FEEDBACK ( 7*32+ 9) /* AMD ProcFeedbackInterface */
+#define X86_FEATURE_HWP		( 7*32+ 10) /* "hwp" Intel HWP */
+#define X86_FEATURE_HWP_NOITFY	( 7*32+ 11) /* Intel HWP_NOTIFY */
+#define X86_FEATURE_HWP_ACT_WINDOW ( 7*32+ 12) /* Intel HWP_ACT_WINDOW */
+#define X86_FEATURE_HWP_EPP	( 7*32+13) /* Intel HWP_EPP */
+#define X86_FEATURE_HWP_PKG_REQ ( 7*32+14) /* Intel HWP_PKG_REQ */
 
 /* Virtualization flags: Linux defined, word 8 */
 #define X86_FEATURE_TPR_SHADOW  ( 8*32+ 0) /* Intel TPR Shadow */
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index 4a8013d..6063909 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -36,6 +36,11 @@ void init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 		{ X86_FEATURE_ARAT,		CR_EAX, 2, 0x00000006, 0 },
 		{ X86_FEATURE_PLN,		CR_EAX, 4, 0x00000006, 0 },
 		{ X86_FEATURE_PTS,		CR_EAX, 6, 0x00000006, 0 },
+		{ X86_FEATURE_HWP,		CR_EAX, 7, 0x00000006, 0 },
+		{ X86_FEATURE_HWP_NOITFY,	CR_EAX, 8, 0x00000006, 0 },
+		{ X86_FEATURE_HWP_ACT_WINDOW,	CR_EAX, 9, 0x00000006, 0 },
+		{ X86_FEATURE_HWP_EPP,		CR_EAX,10, 0x00000006, 0 },
+		{ X86_FEATURE_HWP_PKG_REQ,	CR_EAX,11, 0x00000006, 0 },
 		{ X86_FEATURE_APERFMPERF,	CR_ECX, 0, 0x00000006, 0 },
 		{ X86_FEATURE_EPB,		CR_ECX, 3, 0x00000006, 0 },
 		{ X86_FEATURE_HW_PSTATE,	CR_EDX, 7, 0x80000007, 0 },
-- 
1.9.3

