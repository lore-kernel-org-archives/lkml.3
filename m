Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934405AbaFTQRq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 12:17:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:25048 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756699AbaFTQRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 12:17:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,514,1400050800"; 
   d="scan'208";a="560784258"
Subject: [RFC][PATCH 3/3] x86: make MP  a required-feature on 64-bit
To: linux-kernel@vger.kernel.org
Cc: bp@alien8.de, x86@kernel.org, hpa@zytor.com, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Fri, 20 Jun 2014 09:17:40 -0700
References: <20140620161736.D6AC16FD@viggo.jf.intel.com>
In-Reply-To: <20140620161736.D6AC16FD@viggo.jf.intel.com>
Message-Id: <20140620161740.BFB00798@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Today, we assume that all 64-bit cpus have X86_FEATURE_MP.  It
should be in the REQUIRED_MASK so that we do not need the #undef
trick for it.

---

 b/arch/x86/include/asm/cpufeature.h        |    3 ---
 b/arch/x86/include/asm/required-features.h |    4 +++-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff -puN arch/x86/include/asm/cpufeature.h~x86-make-mp-required_feature arch/x86/include/asm/cpufeature.h
--- a/arch/x86/include/asm/cpufeature.h~x86-make-mp-required_feature	2014-06-20 09:16:10.180396969 -0700
+++ b/arch/x86/include/asm/cpufeature.h	2014-06-20 09:16:10.185397194 -0700
@@ -362,9 +362,6 @@ extern const char * const x86_power_flag
 #undef  cpu_has_pae
 #define cpu_has_pae		___BUG___
 
-#undef  cpu_has_mp
-#define cpu_has_mp		1
-
 #endif /* CONFIG_X86_64 */
 
 #if __GNUC__ >= 4
diff -puN arch/x86/include/asm/required-features.h~x86-make-mp-required_feature arch/x86/include/asm/required-features.h
--- a/arch/x86/include/asm/required-features.h~x86-make-mp-required_feature	2014-06-20 09:16:10.182397059 -0700
+++ b/arch/x86/include/asm/required-features.h	2014-06-20 09:16:10.186397240 -0700
@@ -67,6 +67,7 @@
 #define NEED_XMM	(1<<(X86_FEATURE_XMM & 31))
 #define NEED_XMM2	(1<<(X86_FEATURE_XMM2 & 31))
 #define NEED_LM		(1<<(X86_FEATURE_LM & 31))
+#define NEED_MP		(1<<(X86_FEATURE_MP & 31))
 #else
 #define NEED_PSE	0
 #define NEED_MSR	0
@@ -75,6 +76,7 @@
 #define NEED_XMM	0
 #define NEED_XMM2	0
 #define NEED_LM		0
+#define NEED_MP		0
 #endif
 
 #define REQUIRED_MASK0	(NEED_FPU|NEED_PSE|NEED_MSR|NEED_PAE|\
@@ -82,7 +84,7 @@
 			 NEED_XMM|NEED_XMM2)
 #define SSE_MASK	(NEED_XMM|NEED_XMM2)
 
-#define REQUIRED_MASK1	(NEED_LM|NEED_3DNOW)
+#define REQUIRED_MASK1	(NEED_LM|NEED_3DNOW|NEED_MP)
 
 #define REQUIRED_MASK2	0
 #define REQUIRED_MASK3	(NEED_NOPL)
_
