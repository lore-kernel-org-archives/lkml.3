Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbaHHFhK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 01:37:10 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:17343 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937AbaHHFhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 01:37:08 -0400
From: Ethan Zhao <ethan.zhao@oracle.com>
To: bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, gleb@kernel.org, pbonzini@redhat.com,
        kvm@vger.kernel.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        xen-devel@lists.xenproject.org
Cc: alex.williamson@redhat.com, alexander.h.duyck@intel.com,
        ethan.kernel@gmail.com
Subject: [PATCH v3 0/4 resend] Introduce device assignment flag operation helper function 
Date: Fri,  8 Aug 2014 13:36:03 +0800
Message-Id: <1407476167-18935-1-git-send-email-ethan.zhao@oracle.com>
X-Mailer: git-send-email 1.7.1
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set introduces three PCI device flag operation helper functions
when set pci device PF/VF to assigned or deassigned status also check it.
and patch 2,3,4 apply these helper functions to KVM,XEN and PCI.

v2: simplify unnecessory ternary operation in function pci_is_dev_assigned().
v3: amend helper function naming.

Appreciate suggestion from
alex.williamson@redhat.com,
david.vrabel@citrix.com,
alexander.h.duyck@intel.com

Resend for v3.16 building.

Thanks,
Ethan
---
Ethan Zhao (4):
  PCI: introduce helper functions for device flag operation
  KVM: use pci device flag operation helper functions
  xen-pciback: use pci device flag operation helper function
  PCI: use device flag operation helper function in iov.c

 drivers/pci/iov.c                  |    2 +-
 drivers/xen/xen-pciback/pci_stub.c |    4 ++--
 include/linux/pci.h                |   13 +++++++++++++
 virt/kvm/assigned-dev.c            |    2 +-
 virt/kvm/iommu.c                   |    4 ++--
 5 files changed, 19 insertions(+), 6 deletions(-)

