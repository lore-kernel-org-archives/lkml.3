Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab3J3RCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 13:02:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37326 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812Ab3J3RCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 13:02:16 -0400
Subject: [PATCH v2 0/3] KVM noncoherent DMA registration and VFIO pseudo
 device
To: pbonzini@redhat.com, kvm@vger.kernel.org, gleb@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: aik@ozlabs.ru, linux-kernel@vger.kernel.org
Date: Wed, 30 Oct 2013 11:02:09 -0600
Message-ID: <20131030165234.31949.70266.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2:
  - Drop KVM device changes
  - Add kfree(dev) in destroy function
  - Add atomic_set(,0) in kvm_arch init

As described in v1 and discussion, this adds a VFIO pseudo device to
KVM through which userspace can register VFIO groups.  The initial use
of this interface is to enable emulation of coherency instructions on
x86 when a VFIO group is attached.  Future patches will allow KVM to
query the coherency state of the IOMMU domain used by the group to
avoid unnecessarily enabling this emulation.  Thanks,

Alex

---

Alex Williamson (3):
      kvm: Add VFIO device
      kvm/x86: Convert iommu_flags to iommu_noncoherent
      kvm: Create non-coherent DMA registeration


 Documentation/virtual/kvm/devices/vfio.txt |   22 ++
 arch/ia64/include/asm/kvm_host.h           |    2 
 arch/x86/include/asm/kvm_host.h            |    4 
 arch/x86/kvm/Kconfig                       |    1 
 arch/x86/kvm/Makefile                      |    2 
 arch/x86/kvm/vmx.c                         |    3 
 arch/x86/kvm/x86.c                         |   22 ++
 include/linux/kvm_host.h                   |   23 ++
 include/uapi/linux/kvm.h                   |    4 
 virt/kvm/Kconfig                           |    3 
 virt/kvm/iommu.c                           |   22 +-
 virt/kvm/kvm_main.c                        |    5 +
 virt/kvm/vfio.c                            |  264 ++++++++++++++++++++++++++++
 13 files changed, 359 insertions(+), 18 deletions(-)
 create mode 100644 Documentation/virtual/kvm/devices/vfio.txt
 create mode 100644 virt/kvm/vfio.c
