Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965179Ab3IEK3i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 06:29:38 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:51740 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965115Ab3IEK3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 06:29:34 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v2 01/15] KVM: MMU: fix the count of spte number
Date: Thu,  5 Sep 2013 18:29:04 +0800
Message-Id: <1378376958-27252-2-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378376958-27252-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1378376958-27252-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090510-1396-0000-0000-0000038264AF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the desc is the last one and it is full, its sptes is not counted

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 6e2d2c8..7714fd8 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -948,6 +948,7 @@ static int pte_list_add(struct kvm_vcpu *vcpu, u64 *spte,
 			count += PTE_LIST_EXT;
 		}
 		if (desc->sptes[PTE_LIST_EXT-1]) {
+			count += PTE_LIST_EXT;
 			desc->more = mmu_alloc_pte_list_desc(vcpu);
 			desc = desc->more;
 		}
-- 
1.8.1.4

