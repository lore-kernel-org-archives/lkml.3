Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab3LBKWR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 05:22:17 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:63634 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab3LBKWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 05:22:16 -0500
From: Zhouyi Zhou <zhouzhouyi@gmail.com>
To: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <kvm-ppc@vger.kernel.org>, Alexander Graf <agraf@suse.de>,
        <paulus@samba.org>
Cc: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Subject: [PATCH] KVM: NULL return of kvmppc_mmu_hpte_cache_next should be handled
Date: Mon,  2 Dec 2013 18:21:58 +0800
Message-Id: <1385979718-26218-1-git-send-email-yizhouzhou@ict.ac.cn>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NULL return of kvmppc_mmu_hpte_cache_next should be handled

Signed-off-by: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
---
 arch/powerpc/kvm/book3s_32_mmu_host.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_32_mmu_host.c b/arch/powerpc/kvm/book3s_32_mmu_host.c
index 3a0abd2..5fac89d 100644
--- a/arch/powerpc/kvm/book3s_32_mmu_host.c
+++ b/arch/powerpc/kvm/book3s_32_mmu_host.c
@@ -243,6 +243,11 @@ next_pteg:
 	/* Now tell our Shadow PTE code about the new page */
 
 	pte = kvmppc_mmu_hpte_cache_next(vcpu);
+	if (!pte) {
+		kvm_release_pfn_clean(hpaddr >> PAGE_SHIFT);
+		r = -EAGAIN;
+		goto out;
+	}
 
 	dprintk_mmu("KVM: %c%c Map 0x%llx: [%lx] 0x%llx (0x%llx) -> %lx\n",
 		    orig_pte->may_write ? 'w' : '-',
-- 
1.7.10.4

