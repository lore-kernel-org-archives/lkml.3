Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbaEDPlg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:41:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36036 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884AbaEDPle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 3.14 058/158] x86, AVX-512: Enable AVX-512 States Context Switch
Date: Sun,  4 May 2014 11:39:27 -0400
Message-Id: <20140504154037.847898707@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fenghua Yu <fenghua.yu@intel.com>

commit c2bc11f10a39527cd1bb252097b5525664560956 upstream.

This patch enables Opmask, ZMM_Hi256, and Hi16_ZMM AVX-512 states for
xstate context switch.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1392931491-33237-2-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/xsave.h |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

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


