Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018AbaDVUXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:23:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36527 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755287AbaDVUXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:23:34 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 061/133] arm64: Use Normal NonCacheable memory for writecombine
Date: Tue, 22 Apr 2014 13:13:19 -0700
Message-Id: <1398197671-12786-62-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398197671-12786-1-git-send-email-kamal@canonical.com>
References: <1398197671-12786-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.22 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

commit 4f00130b70e5eee813cc7bc298e0f3fdf79673cc upstream.

This provides better performance compared to Device GRE and also allows
unaligned accesses. Such memory is intended to be used with standard RAM
(e.g. framebuffers) and not I/O.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ kamal: 3.8-stable prereq for de2db74 "arm64: Make DMA coherent and strongly
  ordered mappings not executable" ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm64/include/asm/pgtable.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 72dd657..feb0684 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -184,7 +184,7 @@ static inline void set_pte_at(struct mm_struct *mm, unsigned long addr,
 #define pgprot_noncached(prot) \
 	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_DEVICE_nGnRnE))
 #define pgprot_writecombine(prot) \
-	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_DEVICE_GRE))
+	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_NORMAL_NC))
 #define pgprot_dmacoherent(prot) \
 	__pgprot_modify(prot, PTE_ATTRINDX_MASK, PTE_ATTRINDX(MT_NORMAL_NC))
 #define __HAVE_PHYS_MEM_ACCESS_PROT
-- 
1.9.1

