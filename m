Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbaLEXJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:09:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54770 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbaLEXGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 18:06:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 09/45] sparc64: Fix constraints on swab helpers.
Date: Fri,  5 Dec 2014 14:44:52 -0800
Message-Id: <20141205223318.196237614@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223316.738290875@linuxfoundation.org>
References: <20141205223316.738290875@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

[ Upstream commit 5a2b59d3993e8ca4f7788a48a23e5cb303f26954 ]

We are reading the memory location, so we have to have a memory
constraint in there purely for the sake of showing the data flow
to the compiler.

Reported-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/include/uapi/asm/swab.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/sparc/include/uapi/asm/swab.h
+++ b/arch/sparc/include/uapi/asm/swab.h
@@ -9,9 +9,9 @@ static inline __u16 __arch_swab16p(const
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
@@ -20,9 +20,9 @@ static inline __u32 __arch_swab32p(const
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
@@ -31,9 +31,9 @@ static inline __u64 __arch_swab64p(const
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


