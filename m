Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbaIICXb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 22:23:31 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:51143 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755965AbaIICX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 22:23:29 -0400
From: Ethan Zhao <ethan.zhao@oracle.com>
To: bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, gleb@kernel.org, pbonzini@redhat.com,
        kvm@vger.kernel.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com
Cc: alex.williamson@redhat.com, alexander.h.duyck@intel.com,
        ethan.kernel@gmail.com, Ethan Zhao <ethan.zhao@oracle.com>
Subject: [PATCH V4 4/4 resend] PCI: use device flag operation helper function in iov.c
Date: Tue,  9 Sep 2014 10:21:28 +0800
Message-Id: <1410229288-31829-5-git-send-email-ethan.zhao@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1410229288-31829-1-git-send-email-ethan.zhao@oracle.com>
References: <1410229288-31829-1-git-send-email-ethan.zhao@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
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

