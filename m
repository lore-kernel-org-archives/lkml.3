Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbaLCL1y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:27:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54701 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300AbaLCL1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:27:41 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 089/101] sparc64: Fix constraints on swab helpers.
Date: Wed,  3 Dec 2014 12:26:51 +0100
Message-Id: <0bdeed7d131bf61214dbce110959925c13ac7be5.1417605922.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
References: <f9a3dbb8fd1853c16930b2c95eefa34a324eca19.1417605922.git.jslaby@suse.cz>
In-Reply-To: <cover.1417605922.git.jslaby@suse.cz>
References: <cover.1417605922.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David S. Miller" <davem@davemloft.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 5a2b59d3993e8ca4f7788a48a23e5cb303f26954 ]

We are reading the memory location, so we have to have a memory
constraint in there purely for the sake of showing the data flow
to the compiler.

Reported-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/sparc/include/uapi/asm/swab.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/sparc/include/uapi/asm/swab.h b/arch/sparc/include/uapi/asm/swab.h
index a34ad079487e..4c7c12d69bea 100644
--- a/arch/sparc/include/uapi/asm/swab.h
+++ b/arch/sparc/include/uapi/asm/swab.h
@@ -9,9 +9,9 @@ static inline __u16 __arch_swab16p(const __u16 *addr)
 {
 	__u16 ret;
 
-	__asm__ __volatile__ ("lduha [%1] %2, %0"
+	__asm__ __volatile__ ("lduha [%2] %3, %0"
 			      : "=r" (ret)
-			      : "r" (addr), "i" (ASI_PL));
+			      : "m" (*addr), "r" (addr), "i" (ASI_PL));
 	return ret;
 }
 #define __arch_swab16p __arch_swab16p
@@ -20,9 +20,9 @@ static inline __u32 __arch_swab32p(const __u32 *addr)
 {
 	__u32 ret;
 
-	__asm__ __volatile__ ("lduwa [%1] %2, %0"
+	__asm__ __volatile__ ("lduwa [%2] %3, %0"
 			      : "=r" (ret)
-			      : "r" (addr), "i" (ASI_PL));
+			      : "m" (*addr), "r" (addr), "i" (ASI_PL));
 	return ret;
 }
 #define __arch_swab32p __arch_swab32p
@@ -31,9 +31,9 @@ static inline __u64 __arch_swab64p(const __u64 *addr)
 {
 	__u64 ret;
 
-	__asm__ __volatile__ ("ldxa [%1] %2, %0"
+	__asm__ __volatile__ ("ldxa [%2] %3, %0"
 			      : "=r" (ret)
-			      : "r" (addr), "i" (ASI_PL));
+			      : "m" (*addr), "r" (addr), "i" (ASI_PL));
 	return ret;
 }
 #define __arch_swab64p __arch_swab64p
-- 
2.1.3

