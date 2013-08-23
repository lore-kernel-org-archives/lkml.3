Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815Ab3HWQWJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 12:22:09 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:39251 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754323Ab3HWQWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 12:22:07 -0400
From: Andy King <acking@vmware.com>
To: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Cc: gregkh@linuxfoundation.org, pv-drivers@vmware.com,
        Andy King <acking@vmware.com>
Subject: [PATCH 0/2] VMCI: Add support for virtual IOMMU
Date: Fri, 23 Aug 2013 09:22:12 -0700
Message-Id: <1377274934-12223-1-git-send-email-acking@vmware.com>
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
 drivers/misc/vmw_vmci/vmci_guest.c      |   22 ++-
 drivers/misc/vmw_vmci/vmci_queue_pair.c |  313 ++++++++++++-------------------
 drivers/misc/vmw_vmci/vmci_queue_pair.h |   18 --
 5 files changed, 142 insertions(+), 220 deletions(-)

-- 
1.7.4.1

