Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbaLOO1I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:27:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38138 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbaLOO1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:27:02 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 002/168] sparc64: Fix constraints on swab helpers.
Date: Mon, 15 Dec 2014 14:24:16 +0000
Message-Id: <1418653622-21105-3-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

commit 5a2b59d3993e8ca4f7788a48a23e5cb303f26954 upstream.

We are reading the memory location, so we have to have a memory
constraint in there purely for the sake of showing the data flow
to the compiler.

Reported-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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

