Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab3EaAh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 20:37:57 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:59471 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab3EaAgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 20:36:51 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v8 07/11] KVM: MMU: do not reuse the obsolete page
Date: Fri, 31 May 2013 08:36:26 +0800
Message-Id: <1369960590-14138-8-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1369960590-14138-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1369960590-14138-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13053100-6102-0000-0000-0000039CF5EF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The obsolete page will be zapped soon, do not reuse it to
reduce future page fault

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 3fd060a..0880b9b4 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -1875,6 +1875,9 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
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

