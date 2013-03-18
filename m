Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab3CRVHA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:07:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45615 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755528Ab3CRVG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:06:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 38/75] powerpc: Make VSID_BITS* dependency explicit
Date: Mon, 18 Mar 2013 14:07:01 -0700
Message-Id: <20130318210512.957002428@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318210510.203500214@linuxfoundation.org>
References: <20130318210510.203500214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

commit e39d1a471484662620651cd9520250d33843f235 upstream.

VSID_BITS and VSID_BITS_1T depends on the context bits  and user esid
bits. Make the dependency explicit

Acked-by: Paul Mackerras <paulus@samba.org>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/mmu-hash64.h |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/arch/powerpc/include/asm/mmu-hash64.h
+++ b/arch/powerpc/include/asm/mmu-hash64.h
@@ -381,21 +381,22 @@ extern void slb_set_size(u16 size);
  * hash collisions.
  */
 
+#define CONTEXT_BITS		19
+#define USER_ESID_BITS		18
+#define USER_ESID_BITS_1T	6
+
 /*
  * This should be computed such that protovosid * vsid_mulitplier
  * doesn't overflow 64 bits. It should also be co-prime to vsid_modulus
  */
 #define VSID_MULTIPLIER_256M	ASM_CONST(12538073)	/* 24-bit prime */
-#define VSID_BITS_256M		38
+#define VSID_BITS_256M		(CONTEXT_BITS + USER_ESID_BITS + 1)
 #define VSID_MODULUS_256M	((1UL<<VSID_BITS_256M)-1)
 
 #define VSID_MULTIPLIER_1T	ASM_CONST(12538073)	/* 24-bit prime */
-#define VSID_BITS_1T		26
+#define VSID_BITS_1T		(CONTEXT_BITS + USER_ESID_BITS_1T + 1)
 #define VSID_MODULUS_1T		((1UL<<VSID_BITS_1T)-1)
 
-#define CONTEXT_BITS		19
-#define USER_ESID_BITS		18
-#define USER_ESID_BITS_1T	6
 
 #define USER_VSID_RANGE	(1UL << (USER_ESID_BITS + SID_SHIFT))
 


