Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab3FGXF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 19:05:57 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:38274 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757705Ab3FGXDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 19:03:55 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org, kvm@vger.kernel.org,
        Sanjay Lal <sanjayl@kymasys.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH 27/31] mips/kvm: Gate the use of kvm_local_flush_tlb_all() by KVM_MIPSTE
Date: Fri,  7 Jun 2013 16:03:31 -0700
Message-Id: <1370646215-6543-28-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
References: <1370646215-6543-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

Only the trap-and-emulate KVM code needs a Special tlb flusher.  All
other configurations should use the regular version.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/include/asm/mmu_context.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/mmu_context.h b/arch/mips/include/asm/mmu_context.h
index 5609a32..04d0b74 100644
--- a/arch/mips/include/asm/mmu_context.h
+++ b/arch/mips/include/asm/mmu_context.h
@@ -117,7 +117,7 @@ get_new_asid(unsigned long cpu)
 	if (! ((asid += ASID_INC) & ASID_MASK) ) {
 		if (cpu_has_vtag_icache)
 			flush_icache_all();
-#ifdef CONFIG_VIRTUALIZATION
+#if IS_ENABLED(CONFIG_KVM_MIPSTE)
 		kvm_local_flush_tlb_all();      /* start new asid cycle */
 #else
 		local_flush_tlb_all();	/* start new asid cycle */
-- 
1.7.11.7

