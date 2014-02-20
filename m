Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015AbaBTV1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 16:27:50 -0500
Received: from mga09.intel.com ([134.134.136.24]:31960 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbaBTV1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 16:27:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,514,1389772800"; 
   d="scan'208";a="459078457"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Asit K Mallick" <asit.k.mallick@intel.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>, "x86" <x86@kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 2/2] x86/AVX-512: Enable AVX-512 States Context Switch
Date: Thu, 20 Feb 2014 13:24:51 -0800
Message-Id: <1392931491-33237-2-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1392931491-33237-1-git-send-email-fenghua.yu@intel.com>
References: <1392931491-33237-1-git-send-email-fenghua.yu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

This patch enables Opmask, ZMM_Hi256, and Hi16_ZMM AVX-512 states for
xstate context switch.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
---
 arch/x86/include/asm/xsave.h | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index 5547389..82173f6 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -6,11 +6,14 @@
 
 #define XSTATE_CPUID		0x0000000d
 
-#define XSTATE_FP	0x1
-#define XSTATE_SSE	0x2
-#define XSTATE_YMM	0x4
-#define XSTATE_BNDREGS	0x8
-#define XSTATE_BNDCSR	0x10
+#define XSTATE_FP		0x1
+#define XSTATE_SSE		0x2
+#define XSTATE_YMM		0x4
+#define XSTATE_BNDREGS		0x8
+#define XSTATE_BNDCSR		0x10
+#define XSTATE_OPMASK		0x20
+#define XSTATE_ZMM_Hi256	0x40
+#define XSTATE_Hi16_ZMM		0x80
 
 #define XSTATE_FPSSE	(XSTATE_FP | XSTATE_SSE)
 
@@ -23,7 +26,8 @@
 #define XSAVE_YMM_OFFSET    (XSAVE_HDR_SIZE + XSAVE_HDR_OFFSET)
 
 /* Supported features which support lazy state saving */
-#define XSTATE_LAZY	(XSTATE_FP | XSTATE_SSE | XSTATE_YMM)
+#define XSTATE_LAZY	(XSTATE_FP | XSTATE_SSE | XSTATE_YMM		      \
+			| XSTATE_OPMASK | XSTATE_ZMM_Hi256 | XSTATE_Hi16_ZMM)
 
 /* Supported features which require eager state saving */
 #define XSTATE_EAGER	(XSTATE_BNDREGS | XSTATE_BNDCSR)
-- 
1.8.1.2

