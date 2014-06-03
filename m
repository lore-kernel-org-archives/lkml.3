Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933184AbaFCLom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:44:42 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:64808 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933038AbaFCLoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:44:37 -0400
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH] KVM: add missing cleanup_srcu_struct
Date: Tue,  3 Jun 2014 13:44:27 +0200
Message-Id: <1401795867-28050-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: hrg <hrgstephen@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/kvm_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 95b4c2b3906a..c86be0f983db 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -608,6 +608,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	kvm_arch_destroy_vm(kvm);
 	kvm_destroy_devices(kvm);
 	kvm_free_physmem(kvm);
+	cleanup_srcu_struct(&kvm->irq_srcu);
 	cleanup_srcu_struct(&kvm->srcu);
 	kvm_arch_free_vm(kvm);
 	hardware_disable_all();
-- 
1.8.3.1

