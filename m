Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934570Ab3FSJNG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 05:13:06 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:45906 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934321Ab3FSJJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 05:09:44 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH 4/7] KVM: MMU: document mmio page fault
Date: Wed, 19 Jun 2013 17:09:22 +0800
Message-Id: <1371632965-20077-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1371632965-20077-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1371632965-20077-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061909-5140-0000-0000-0000036649B9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Document it to Documentation/virtual/kvm/mmu.txt

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 Documentation/virtual/kvm/mmu.txt | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/Documentation/virtual/kvm/mmu.txt b/Documentation/virtual/kvm/mmu.txt
index 5a6b2e2..4fb442b 100644
--- a/Documentation/virtual/kvm/mmu.txt
+++ b/Documentation/virtual/kvm/mmu.txt
@@ -270,14 +270,21 @@ This is the most complicated event.  The cause of a page fault can be:
 
 Handling a page fault is performed as follows:
 
+ - if the RSV bit of the error code is set, the page fault is caused by guest
+   accessing MMIO, walk shadow page table to get the last spte where the mmio
+   information is stored and cache the information to vcpu->arch.mmio_gva,
+   vcpu->arch.access and vcpu->arch.mmio_gfn then call the emulator to emulate
+   the instruction who will get the benefit from the cached mmio info
  - if needed, walk the guest page tables to determine the guest translation
    (gva->gpa or ngpa->gpa)
    - if permissions are insufficient, reflect the fault back to the guest
  - determine the host page
-   - if this is an mmio request, there is no host page; call the emulator
-     to emulate the instruction instead
+   - if this is an mmio request, there is no host page; cache the info to
+     vcpu->arch.mmio_gva, vcpu->arch.access and vcpu->arch.mmio_gfn
  - walk the shadow page table to find the spte for the translation,
    instantiating missing intermediate page tables as necessary
+   - If this is an mmio request, cache the mmio info to the spte and set some
+     reserved bits on the spte
  - try to unsynchronize the page
    - if successful, we can let the guest continue and modify the gpte
  - emulate the instruction
-- 
1.8.1.4

