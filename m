Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005AbaIEKx0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 06:53:26 -0400
Received: from 8bytes.org ([81.169.241.247]:37800 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756899AbaIEKxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 06:53:13 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 09/12] kvm: iommu: Convert to use new iommu_capable() API function
Date: Fri,  5 Sep 2014 12:53:01 +0200
Message-Id: <1409914384-21191-10-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409914384-21191-1-git-send-email-joro@8bytes.org>
References: <1409914384-21191-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Cc: Gleb Natapov <gleb@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 virt/kvm/iommu.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
index 714b949..45ee080 100644
--- a/virt/kvm/iommu.c
+++ b/virt/kvm/iommu.c
@@ -191,8 +191,7 @@ int kvm_assign_device(struct kvm *kvm,
 		return r;
 	}
 
-	noncoherent = !iommu_domain_has_cap(kvm->arch.iommu_domain,
-					    IOMMU_CAP_CACHE_COHERENCY);
+	noncoherent = !iommu_capable(&pci_bus_type, IOMMU_CAP_CACHE_COHERENCY);
 
 	/* Check if need to update IOMMU page table for guest memory */
 	if (noncoherent != kvm->arch.iommu_noncoherent) {
@@ -254,8 +253,7 @@ int kvm_iommu_map_guest(struct kvm *kvm)
 	}
 
 	if (!allow_unsafe_assigned_interrupts &&
-	    !iommu_domain_has_cap(kvm->arch.iommu_domain,
-				  IOMMU_CAP_INTR_REMAP)) {
+	    !iommu_capable(&pci_bus_type, IOMMU_CAP_INTR_REMAP)) {
 		printk(KERN_WARNING "%s: No interrupt remapping support,"
 		       " disallowing device assignment."
 		       " Re-enble with \"allow_unsafe_assigned_interrupts=1\""
-- 
1.9.1

