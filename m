Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbaBTWTi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 17:19:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45126 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbaBTWTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 17:19:35 -0500
Date: Thu, 20 Feb 2014 14:19:22 -0800
From: tip-bot for Fenghua Yu <tipbot@zytor.com>
Message-ID: <tip-c2bc11f10a39527cd1bb252097b5525664560956@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1392931491-33237-2-git-send-email-fenghua.yu@intel.com>
References: <1392931491-33237-2-git-send-email-fenghua.yu@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpufeature] x86, AVX-512:
  Enable AVX-512 States Context Switch
Git-Commit-ID: c2bc11f10a39527cd1bb252097b5525664560956
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

Commit-ID:  c2bc11f10a39527cd1bb252097b5525664560956
Gitweb:     http://git.kernel.org/tip/c2bc11f10a39527cd1bb252097b5525664560956
Author:     Fenghua Yu <fenghua.yu@intel.com>
AuthorDate: Thu, 20 Feb 2014 13:24:51 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 20 Feb 2014 13:56:55 -0800

x86, AVX-512: Enable AVX-512 States Context Switch

This patch enables Opmask, ZMM_Hi256, and Hi16_ZMM AVX-512 states for
xstate context switch.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1392931491-33237-2-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: <stable@vger.kernel.org> # hw enabling
---
 arch/x86/include/asm/xsave.h | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index 5547389..6c1d741 100644
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
