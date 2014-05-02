Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbaEBQZl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:25:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43687 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718AbaEBPjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:39:18 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Fenghua Yu <fenghua.yu@intel.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 019/151] x86, AVX-512: Enable AVX-512 States Context Switch
Date: Fri,  2 May 2014 08:36:47 -0700
Message-Id: <1399045139-4531-20-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fenghua Yu <fenghua.yu@intel.com>

commit c2bc11f10a39527cd1bb252097b5525664560956 upstream.

This patch enables Opmask, ZMM_Hi256, and Hi16_ZMM AVX-512 states for
xstate context switch.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1392931491-33237-2-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
[ Fenghua Yu: backport to 3.13-stable (apply new bits directly to XCNTXT_MASK) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/include/asm/xsave.h | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index 0415cda..0b651f9 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -6,9 +6,14 @@
 
 #define XSTATE_CPUID		0x0000000d
 
-#define XSTATE_FP	0x1
-#define XSTATE_SSE	0x2
-#define XSTATE_YMM	0x4
+#define XSTATE_FP		0x1
+#define XSTATE_SSE		0x2
+#define XSTATE_YMM		0x4
+#define XSTATE_BNDREGS		0x8
+#define XSTATE_BNDCSR		0x10
+#define XSTATE_OPMASK		0x20
+#define XSTATE_ZMM_Hi256	0x40
+#define XSTATE_Hi16_ZMM		0x80
 
 #define XSTATE_FPSSE	(XSTATE_FP | XSTATE_SSE)
 
@@ -23,7 +28,7 @@
 /*
  * These are the features that the OS can handle currently.
  */
-#define XCNTXT_MASK	(XSTATE_FP | XSTATE_SSE | XSTATE_YMM)
+#define XCNTXT_MASK	(XSTATE_FP | XSTATE_SSE | XSTATE_YMM | XSTATE_OPMASK | XSTATE_ZMM_Hi256 | XSTATE_Hi16_ZMM)
 
 #ifdef CONFIG_X86_64
 #define REX_PREFIX	"0x48, "
-- 
1.9.1

