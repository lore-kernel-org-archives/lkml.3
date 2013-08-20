Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751887Ab3HTRj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 13:39:28 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:33027 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751266Ab3HTRj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 13:39:26 -0400
X-Greylist: delayed 572 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Aug 2013 13:39:26 EDT
From: Andy King <acking@vmware.com>
To: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Cc: gregkh@linuxfoundation.org, pv-drivers@vmware.com,
        Andy King <acking@vmware.com>
Subject: [PATCH 0/2] VMCI: Add support for virtual IOMMU
Date: Tue, 20 Aug 2013 10:30:01 -0700
Message-Id: <1377019803-1490-1-git-send-email-acking@vmware.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds support for virtual IOMMU to the VMCI module.  We switch to
DMA consistent mappings for queuepair and doorbell pages that are passed to the
device, which allows the module to work in the presence of vIOMMU/VT-d.

Andy King (2):
  VMCI: Remove non-blocking/pinned queuepair support
  VMCI: Add support for virtual IOMMU

 drivers/misc/vmw_vmci/vmci_driver.c     |    2 +-
 drivers/misc/vmw_vmci/vmci_driver.h     |    7 +
 drivers/misc/vmw_vmci/vmci_guest.c      |   21 ++-
 drivers/misc/vmw_vmci/vmci_queue_pair.c |  312 ++++++++++++-------------------
 drivers/misc/vmw_vmci/vmci_queue_pair.h |   18 --
 5 files changed, 140 insertions(+), 220 deletions(-)

-- 
1.7.4.1

