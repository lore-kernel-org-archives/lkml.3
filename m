Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbaEBQZj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:25:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43688 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbaEBPjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:39:18 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Fenghua Yu <fenghua.yu@intel.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 018/151] x86, AVX-512: AVX-512 Feature Detection
Date: Fri,  2 May 2014 08:36:46 -0700
Message-Id: <1399045139-4531-19-git-send-email-kamal@canonical.com>
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

commit 8e5780fdeef7dc490b3f0b3a62704593721fa4f3 upstream.

AVX-512 is an extention of AVX2. Its spec can be found at:
http://download-software.intel.com/sites/default/files/managed/71/2e/319433-017.pdf

This patch detects AVX-512 features by CPUID.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1392931491-33237-1-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/include/asm/cpufeature.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 89270b4..1e49a03 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -216,9 +216,13 @@
 #define X86_FEATURE_ERMS	(9*32+ 9) /* Enhanced REP MOVSB/STOSB */
 #define X86_FEATURE_INVPCID	(9*32+10) /* Invalidate Processor Context ID */
 #define X86_FEATURE_RTM		(9*32+11) /* Restricted Transactional Memory */
+#define X86_FEATURE_AVX512F	(9*32+16) /* AVX-512 Foundation */
 #define X86_FEATURE_RDSEED	(9*32+18) /* The RDSEED instruction */
 #define X86_FEATURE_ADX		(9*32+19) /* The ADCX and ADOX instructions */
 #define X86_FEATURE_SMAP	(9*32+20) /* Supervisor Mode Access Prevention */
+#define X86_FEATURE_AVX512PF	(9*32+26) /* AVX-512 Prefetch */
+#define X86_FEATURE_AVX512ER	(9*32+27) /* AVX-512 Exponential and Reciprocal */
+#define X86_FEATURE_AVX512CD	(9*32+28) /* AVX-512 Conflict Detection */
 
 /*
  * BUG word(s)
-- 
1.9.1

