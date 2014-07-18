Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030839AbaGRNSP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:18:15 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17948 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030817AbaGRNSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:18:12 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 047/170] powerpc: Add AT_HWCAP2 to indicate V.CRYPTO category support
Date: Fri, 18 Jul 2014 14:10:52 +0200
Message-Id: <9994e2c2687395f69e86e744f0143a9eb540df1e.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit dd58a092c4202f2bd490adab7285b3ff77f8e467 upstream.

The Vector Crypto category instructions are supported by current POWER8
chips, advertise them to userspace using a specific bit to properly
differentiate with chips of the same architecture level that might not
have them.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
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
index 597d954e5860..c5d3d023363a 100644
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
2.0.0

