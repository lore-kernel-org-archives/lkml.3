Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030819AbaGCJuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:50:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52158 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965119AbaGCJXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:23:35 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 117/198] powerpc: Add AT_HWCAP2 to indicate V.CRYPTO category support
Date: Thu,  3 Jul 2014 10:19:20 +0100
Message-Id: <1404379241-8590-118-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit dd58a092c4202f2bd490adab7285b3ff77f8e467 upstream.

The Vector Crypto category instructions are supported by current POWER8
chips, advertise them to userspace using a specific bit to properly
differentiate with chips of the same architecture level that might not
have them.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/powerpc/include/uapi/asm/cputable.h | 1 +
 arch/powerpc/kernel/cputable.c           | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/include/uapi/asm/cputable.h b/arch/powerpc/include/uapi/asm/cputable.h
index 5b7657959faa..de2c0e4ee1aa 100644
--- a/arch/powerpc/include/uapi/asm/cputable.h
+++ b/arch/powerpc/include/uapi/asm/cputable.h
@@ -41,5 +41,6 @@
 #define PPC_FEATURE2_EBB		0x10000000
 #define PPC_FEATURE2_ISEL		0x08000000
 #define PPC_FEATURE2_TAR		0x04000000
+#define PPC_FEATURE2_VEC_CRYPTO		0x02000000
 
 #endif /* _UAPI__ASM_POWERPC_CPUTABLE_H */
diff --git a/arch/powerpc/kernel/cputable.c b/arch/powerpc/kernel/cputable.c
index 22973a74df73..1c07f0eae495 100644
--- a/arch/powerpc/kernel/cputable.c
+++ b/arch/powerpc/kernel/cputable.c
@@ -105,7 +105,8 @@ extern void __restore_cpu_e6500(void);
 				 PPC_FEATURE_PSERIES_PERFMON_COMPAT)
 #define COMMON_USER2_POWER8	(PPC_FEATURE2_ARCH_2_07 | \
 				 PPC_FEATURE2_HTM_COMP | PPC_FEATURE2_DSCR | \
-				 PPC_FEATURE2_ISEL | PPC_FEATURE2_TAR)
+				 PPC_FEATURE2_ISEL | PPC_FEATURE2_TAR | \
+				 PPC_FEATURE2_VEC_CRYPTO)
 #define COMMON_USER_PA6T	(COMMON_USER_PPC64 | PPC_FEATURE_PA6T |\
 				 PPC_FEATURE_TRUE_LE | \
 				 PPC_FEATURE_HAS_ALTIVEC_COMP)
-- 
1.9.1

