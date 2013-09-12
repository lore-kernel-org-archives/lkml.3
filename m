Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158Ab3ILVXE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 17:23:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757087Ab3ILVXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 17:23:00 -0400
Subject: [RFC PATCH 0/3] kvm/vfio: Manage KVM IOMMU coherency with virtual
 VFIO device
To: kvm@vger.kernel.org, gleb@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: aik@ozlabs.ru, benh@kernel.crashing.org, bsd@redhat.com,
        linux-kernel@vger.kernel.org, mst@redhat.com
Date: Thu, 12 Sep 2013 15:22:55 -0600
Message-ID: <20130912211401.8542.82932.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

See patch 3/3 for a description of exactly why we need this.  I know
POWER folks are also interested in making use of VFIO's external user
interface from KVM and Alexey's proposed patches have a similar device
tailored for SPAPR use there.  I'm hoping that we can make the base
device common and extend it for each architecture.  The problem we're
solving on x86 may or may not be architecture specific.  It has to do
with how the IOMMU handles No-Snoop transactions on PCIe in relation
to how KVM handles vCPU cache operations.

Appreciate any feedback and suggestions on how to make this more
palatable for sharing with POWER.  I'll also send a QEMU RFC which
makes use of this.  Thanks,

Alex

---

Alex Williamson (3):
      kvm: Destroy & free KVM devices on release
      vfio: Add check extension interface to external user support
      kvm: Add VFIO device for handling IOMMU cache coherency


 Documentation/virtual/kvm/devices/vfio.txt |   22 +++
 arch/powerpc/kvm/book3s_xics.c             |    1 
 arch/x86/include/asm/kvm_host.h            |    1 
 arch/x86/kvm/Makefile                      |    2 
 arch/x86/kvm/vmx.c                         |    5 -
 arch/x86/kvm/x86.c                         |    5 -
 drivers/vfio/vfio.c                        |    8 +
 drivers/vfio/vfio_iommu_type1.c            |    4 
 include/linux/kvm_host.h                   |    1 
 include/linux/vfio.h                       |    2 
 include/uapi/linux/kvm.h                   |    4 
 include/uapi/linux/vfio.h                  |    1 
 virt/kvm/kvm_main.c                        |    8 +
 virt/kvm/vfio.c                            |  237 ++++++++++++++++++++++++++++
 14 files changed, 295 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/virtual/kvm/devices/vfio.txt
 create mode 100644 virt/kvm/vfio.c
