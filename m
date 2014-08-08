Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbaHHFh1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 01:37:27 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:19237 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755860AbaHHFhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 01:37:19 -0400
From: Ethan Zhao <ethan.zhao@oracle.com>
To: bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, gleb@kernel.org, pbonzini@redhat.com,
        kvm@vger.kernel.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        xen-devel@lists.xenproject.org
Cc: alex.williamson@redhat.com, alexander.h.duyck@intel.com,
        ethan.kernel@gmail.com
Subject: [PATCH 4/4] PCI: use device flag operation helper function in iov.c
Date: Fri,  8 Aug 2014 13:36:07 +0800
Message-Id: <1407476167-18935-5-git-send-email-ethan.zhao@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1407476167-18935-1-git-send-email-ethan.zhao@oracle.com>
References: <1407476167-18935-1-git-send-email-ethan.zhao@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use device flag operation helper functions when check device
assignment status.

Signed-off-by: Ethan Zhao <ethan.zhao@oracle.com>
---
 drivers/pci/iov.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index cb6f247..4d109c0 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -633,7 +633,7 @@ int pci_vfs_assigned(struct pci_dev *dev)
 		 * our dev as the physical function and the assigned bit is set
 		 */
 		if (vfdev->is_virtfn && (vfdev->physfn == dev) &&
-		    (vfdev->dev_flags & PCI_DEV_FLAGS_ASSIGNED))
+			pci_is_dev_assigned(vfdev))
 			vfs_assigned++;
 
 		vfdev = pci_get_device(dev->vendor, dev_id, vfdev);
-- 
1.7.1

