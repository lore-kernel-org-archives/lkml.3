Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912AbaEDQTw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:19:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36387 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498AbaEDPmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Bharat Bhushan <Bharat.Bhushan@freescale.com>,
        Laura Abbott <lauraa@codeaurora.org>
Subject: [PATCH 3.10 02/86] arm64: Make DMA coherent and strongly ordered mappings not executable
Date: Sun,  4 May 2014 11:40:37 -0400
Message-Id: <20140504154140.774832671@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154140.444932005@linuxfoundation.org>
References: <20140504154140.444932005@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

commit de2db7432917a82b62d55bb59635586eeca6d1bd upstream.

pgprot_{dmacoherent,writecombine,noncached} don't need to generate
executable mappings with side-effects like __sync_icache_dcache() being
called when the mapping is in user space.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Bharat Bhushan <Bharat.Bhushan@freescale.com>
Tested-by: Laura Abbott <lauraa@codeaurora.org>
Tested-by: Bharat Bhushan <Bharat.Bhushan@freescale.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/pgtable.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -182,11 +182,11 @@ static inline void set_pte_at(struct mm_
  * Mark the prot value as uncacheable and unbufferable.
  */
 #define pgprot_noncached(prot) \
-	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_DEVICE_nGnRnE))
+	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_DEVICE_nGnRnE) | PTE_PXN | PTE_UXN)
 #define pgprot_writecombine(prot) \
-	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_NORMAL_NC))
+	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_NORMAL_NC) | PTE_PXN | PTE_UXN)
 #define pgprot_dmacoherent(prot) \
-	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_NORMAL_NC))
+	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_NORMAL_NC) | PTE_PXN | PTE_UXN)
 #define __HAVE_PHYS_MEM_ACCESS_PROT
 struct file;
 extern pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,


