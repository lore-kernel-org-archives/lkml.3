Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934AbaJ0PXN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:23:13 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:54128 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbaJ0PXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:23:11 -0400
From: Dominik Dingel <dingel@linux.vnet.ibm.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Gleb Natapov <gleb@kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Dominik Dingel <dingel@linux.vnet.ibm.com>
Subject: [PATCH] KVM: trivial fix comment regarding __kvm_set_memory_region
Date: Mon, 27 Oct 2014 16:22:56 +0100
Message-Id: <1414423376-64491-1-git-send-email-dingel@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.5.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102715-0029-0000-0000-00000160C550
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 72dc67a69690 ("KVM: remove the usage of the mmap_sem for the protection of the memory slots.")
changed the lock which will be taken. This should be reflected in the function
commentary.

Signed-off-by: Dominik Dingel <dingel@linux.vnet.ibm.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d82ec25..8b13607 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -738,7 +738,7 @@ static struct kvm_memslots *install_new_memslots(struct kvm *kvm,
  *
  * Discontiguous memory is allowed, mostly for framebuffers.
  *
- * Must be called holding mmap_sem for write.
+ * Must be called holding kvm->slots_lock for write.
  */
 int __kvm_set_memory_region(struct kvm *kvm,
 			    struct kvm_userspace_memory_region *mem)
-- 
1.8.5.5

