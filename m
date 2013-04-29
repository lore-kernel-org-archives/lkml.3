Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758639Ab3D2QyL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 12:54:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757469Ab3D2QyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 12:54:09 -0400
Subject: [PATCH] kvm: KVM_CAP_IOMMU only available with device assignment
To: gleb@redhat.com, kvm@vger.kernel.org
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 29 Apr 2013 10:54:08 -0600
Message-ID: <20130429165334.19404.54557.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix build with CONFIG_PCI unset by linking KVM_CAP_IOMMU to
device assignment config option.  It has no purpose otherwise.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 arch/ia64/kvm/kvm-ia64.c |    2 ++
 arch/x86/kvm/x86.c       |    2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
index dcc5607..5b2dc0d 100644
--- a/arch/ia64/kvm/kvm-ia64.c
+++ b/arch/ia64/kvm/kvm-ia64.c
@@ -204,9 +204,11 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_COALESCED_MMIO:
 		r = KVM_COALESCED_MMIO_PAGE_OFFSET;
 		break;
+#ifdef CONFIG_KVM_DEVICE_ASSIGNMENT
 	case KVM_CAP_IOMMU:
 		r = iommu_present(&pci_bus_type);
 		break;
+#endif
 	default:
 		r = 0;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 73e443f..f83a8e0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2543,9 +2543,11 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_PV_MMU:	/* obsolete */
 		r = 0;
 		break;
+#ifdef CONFIG_KVM_DEVICE_ASSIGNMENT
 	case KVM_CAP_IOMMU:
 		r = iommu_present(&pci_bus_type);
 		break;
+#endif
 	case KVM_CAP_MCE:
 		r = KVM_MAX_MCE_BANKS;
 		break;

