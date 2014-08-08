Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932851AbaHHV7A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:59:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60547 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933175AbaHHVg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 17:36:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 23/39] sparc64: Dont use _PAGE_PRESENT in pte_modify() mask.
Date: Fri,  8 Aug 2014 14:35:09 -0700
Message-Id: <20140808213355.966347319@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140808213354.980430919@linuxfoundation.org>
References: <20140808213354.980430919@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit eaf85da82669b057f20c4e438dc2566b51a83af6 ]

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/include/asm/pgtable_64.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -258,8 +258,8 @@ static inline pte_t pte_modify(pte_t pte
 {
 	unsigned long mask, tmp;
 
-	/* SUN4U: 0x630107ffffffecb8 (negated == 0x9cfef80000001347)
-	 * SUN4V: 0x33ffffffffffee17 (negated == 0xcc000000000011e8)
+	/* SUN4U: 0x630107ffffffec38 (negated == 0x9cfef800000013c7)
+	 * SUN4V: 0x33ffffffffffee07 (negated == 0xcc000000000011f8)
 	 *
 	 * Even if we use negation tricks the result is still a 6
 	 * instruction sequence, so don't try to play fancy and just
@@ -289,10 +289,10 @@ static inline pte_t pte_modify(pte_t pte
 	"	.previous\n"
 	: "=r" (mask), "=r" (tmp)
 	: "i" (_PAGE_PADDR_4U | _PAGE_MODIFIED_4U | _PAGE_ACCESSED_4U |
-	       _PAGE_CP_4U | _PAGE_CV_4U | _PAGE_E_4U | _PAGE_PRESENT_4U |
+	       _PAGE_CP_4U | _PAGE_CV_4U | _PAGE_E_4U |
 	       _PAGE_SPECIAL | _PAGE_PMD_HUGE | _PAGE_SZALL_4U),
 	  "i" (_PAGE_PADDR_4V | _PAGE_MODIFIED_4V | _PAGE_ACCESSED_4V |
-	       _PAGE_CP_4V | _PAGE_CV_4V | _PAGE_E_4V | _PAGE_PRESENT_4V |
+	       _PAGE_CP_4V | _PAGE_CV_4V | _PAGE_E_4V |
 	       _PAGE_SPECIAL | _PAGE_PMD_HUGE | _PAGE_SZALL_4V));
 
 	return __pte((pte_val(pte) & mask) | (pgprot_val(prot) & ~mask));


