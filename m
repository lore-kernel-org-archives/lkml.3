Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbaEDPli (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:41:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36053 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711AbaEDPld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:33 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 3.14 057/158] x86, AVX-512: AVX-512 Feature Detection
Date: Sun,  4 May 2014 11:39:26 -0400
Message-Id: <20140504154037.711981794@linuxfoundation.org>
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

commit 8e5780fdeef7dc490b3f0b3a62704593721fa4f3 upstream.

AVX-512 is an extention of AVX2. Its spec can be found at:
http://download-software.intel.com/sites/default/files/managed/71/2e/319433-017.pdf

This patch detects AVX-512 features by CPUID.

Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Link: http://lkml.kernel.org/r/1392931491-33237-1-git-send-email-fenghua.yu@intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/cpufeature.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -217,9 +217,13 @@
 #define X86_FEATURE_INVPCID	(9*32+10) /* Invalidate Processor Context ID */
 #define X86_FEATURE_RTM		(9*32+11) /* Restricted Transactional Memory */
 #define X86_FEATURE_MPX		(9*32+14) /* Memory Protection Extension */
+#define X86_FEATURE_AVX512F	(9*32+16) /* AVX-512 Foundation */
 #define X86_FEATURE_RDSEED	(9*32+18) /* The RDSEED instruction */
 #define X86_FEATURE_ADX		(9*32+19) /* The ADCX and ADOX instructions */
 #define X86_FEATURE_SMAP	(9*32+20) /* Supervisor Mode Access Prevention */
+#define X86_FEATURE_AVX512PF	(9*32+26) /* AVX-512 Prefetch */
+#define X86_FEATURE_AVX512ER	(9*32+27) /* AVX-512 Exponential and Reciprocal */
+#define X86_FEATURE_AVX512CD	(9*32+28) /* AVX-512 Conflict Detection */
 
 /*
  * BUG word(s)


