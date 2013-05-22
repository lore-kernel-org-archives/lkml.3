Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210Ab3EVT5E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 15:57:04 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:48622 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757168Ab3EVT4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 15:56:24 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v7 08/11] KVM: MMU: do not reuse the obsolete page
Date: Thu, 23 May 2013 03:55:57 +0800
Message-Id: <1369252560-11611-9-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1369252560-11611-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1369252560-11611-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052219-5564-0000-0000-0000080A13DF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The obsolete page will be zapped soon, do not resue it to
reduce future page fault

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 3a3e6c5..9b57faa 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1869,6 +1869,9 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 		role.quadrant = quadrant;
 	}
 	for_each_gfn_sp(vcpu->kvm, sp, gfn) {
+		if (is_obsolete_sp(vcpu->kvm, sp))
+			continue;
+
 		if (!need_sync && sp->unsync)
 			need_sync = true;
 
-- 
1.7.7.6

