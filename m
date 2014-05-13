Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933335AbaEMKkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:40:22 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60771 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760045AbaEMJ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 007/182] arm64: Make DMA coherent and strongly ordered mappings not executable
Date: Tue, 13 May 2014 11:25:59 +0200
Message-Id: <440be9b7d31af62fbce959acbc3ac6ec909bd200.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Catalin Marinas <catalin.marinas@arm.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit de2db7432917a82b62d55bb59635586eeca6d1bd upstream.

pgprot_{dmacoherent,writecombine,noncached} don't need to generate
executable mappings with side-effects like __sync_icache_dcache() being
called when the mapping is in user space.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reported-by: Bharat Bhushan <Bharat.Bhushan@freescale.com>
Tested-by: Laura Abbott <lauraa@codeaurora.org>
Tested-by: Bharat Bhushan <Bharat.Bhushan@freescale.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm64/include/asm/pgtable.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 62713586d6e3..05fe332c1061 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -253,11 +253,11 @@ static inline int has_transparent_hugepage(void)
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
-- 
1.9.3

