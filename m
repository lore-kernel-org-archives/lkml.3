Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760647AbaGDWQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 18:16:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57103 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760578AbaGDWQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:16:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3.15 50/66] powerpc: Add AT_HWCAP2 to indicate V.CRYPTO category support
Date: Fri,  4 Jul 2014 15:14:49 -0700
Message-Id: <20140704221425.086507736@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140704221422.813435485@linuxfoundation.org>
References: <20140704221422.813435485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit dd58a092c4202f2bd490adab7285b3ff77f8e467 upstream.

The Vector Crypto category instructions are supported by current POWER8
chips, advertise them to userspace using a specific bit to properly
differentiate with chips of the same architecture level that might not
have them.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/uapi/asm/cputable.h |    1 +
 arch/powerpc/kernel/cputable.c           |    3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/arch/powerpc/include/uapi/asm/cputable.h
+++ b/arch/powerpc/include/uapi/asm/cputable.h
@@ -41,5 +41,6 @@
 #define PPC_FEATURE2_EBB		0x10000000
 #define PPC_FEATURE2_ISEL		0x08000000
 #define PPC_FEATURE2_TAR		0x04000000
+#define PPC_FEATURE2_VEC_CRYPTO		0x02000000
 
 #endif /* _UAPI__ASM_POWERPC_CPUTABLE_H */
--- a/arch/powerpc/kernel/cputable.c
+++ b/arch/powerpc/kernel/cputable.c
@@ -109,7 +109,8 @@ extern void __restore_cpu_e6500(void);
 				 PPC_FEATURE_PSERIES_PERFMON_COMPAT)
 #define COMMON_USER2_POWER8	(PPC_FEATURE2_ARCH_2_07 | \
 				 PPC_FEATURE2_HTM_COMP | PPC_FEATURE2_DSCR | \
-				 PPC_FEATURE2_ISEL | PPC_FEATURE2_TAR)
+				 PPC_FEATURE2_ISEL | PPC_FEATURE2_TAR | \
+				 PPC_FEATURE2_VEC_CRYPTO)
 #define COMMON_USER_PA6T	(COMMON_USER_PPC64 | PPC_FEATURE_PA6T |\
 				 PPC_FEATURE_TRUE_LE | \
 				 PPC_FEATURE_HAS_ALTIVEC_COMP)


