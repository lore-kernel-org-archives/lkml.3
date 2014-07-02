Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270AbaGBQaL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:30:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:54950 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753937AbaGBQaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:30:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,589,1400050800"; 
   d="scan'208";a="452593480"
Subject: [PATCH 4/4] x86: add MPX to disaabled features
To: bp@alien8.de
Cc: x86@kernel.org, hpa@zytor.com, qiaowei.ren@intel.com,
        linux-kernel@vger.kernel.org, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Wed, 02 Jul 2014 09:29:30 -0700
References: <20140702162925.B07A3AB9@viggo.jf.intel.com>
In-Reply-To: <20140702162925.B07A3AB9@viggo.jf.intel.com>
Message-Id: <20140702162930.6209A1AA@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

This will go in to the MPX patch set, but I'm posting it here so
folk can see how it will work since it was the original
motivation for this work.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 b/arch/x86/include/asm/disabled-features.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff -puN arch/x86/include/asm/disabled-features.h~x86-diabled-features-mpx arch/x86/include/asm/disabled-features.h
--- a/arch/x86/include/asm/disabled-features.h~x86-diabled-features-mpx	2014-07-02 09:16:34.368863016 -0700
+++ b/arch/x86/include/asm/disabled-features.h	2014-07-02 09:16:34.371863152 -0700
@@ -10,6 +10,12 @@
  * cpu_feature_enabled().
  */
 
+#ifdef CONFIG_X86_INTEL_MPX
+# define DISABLE_MPX	0
+#else
+# define DISABLE_MPX	(1<<(X86_FEATURE_MPX & 31))
+#endif
+
 #ifdef CONFIG_X86_64
 # define DISABLE_VME		(1<<(X86_FEATURE_VME & 31))
 # define DISABLE_K6_MTRR	(1<<(X86_FEATURE_K6_MTRR & 31))
@@ -34,6 +40,6 @@
 #define DISABLED_MASK6	0
 #define DISABLED_MASK7	0
 #define DISABLED_MASK8	0
-#define DISABLED_MASK9	0
+#define DISABLED_MASK9	(DISABLE_MPX)
 
 #endif /* _ASM_X86_DISABLED_FEATURES_H */
_
