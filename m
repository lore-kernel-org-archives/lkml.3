Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934462Ab3CTIbF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 04:31:05 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:44919 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934434Ab3CTIbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 04:31:01 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: mtosatti@redhat.com
Cc: gleb@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v2 7/7] KVM: MMU: drop unnecessary kvm_reload_remote_mmus after kvm_mmu_zap_all
Date: Wed, 20 Mar 2013 16:30:27 +0800
Message-Id: <1363768227-4782-8-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1363768227-4782-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1363768227-4782-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032008-0260-0000-0000-000002B1C8AA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is the responsibility of kvm_mmu_zap_all that keeps the consistent
of mmu and tlbs

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/x86.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 87d27a8..5bae962 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7047,7 +7047,6 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 void kvm_arch_flush_shadow_all(struct kvm *kvm)
 {
 	kvm_mmu_zap_all(kvm);
-	kvm_reload_remote_mmus(kvm);
 }
 
 void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
-- 
1.7.7.6

