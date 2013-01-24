Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630Ab3AXAZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 19:25:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319Ab3AXAZq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 19:25:46 -0500
Subject: [PATCH] vfio-pci: Enable PCIe extended capabilities on v1
To: alex.williamson@redhat.com, kvm@vger.kernel.org
From: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 23 Jan 2013 17:25:45 -0700
Message-ID: <20130124002535.2830.40861.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even PCIe 1.x had extended config space.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/vfio/pci/vfio_pci_config.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 6985149..f1dde2c 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -985,12 +985,12 @@ static int vfio_cap_len(struct vfio_pci_device *vdev, u8 cap, u8 pos)
 		if (ret)
 			return pcibios_err_to_errno(ret);
 
+		vdev->extended_caps = true;
+
 		if ((word & PCI_EXP_FLAGS_VERS) == 1)
 			return PCI_CAP_EXP_ENDPOINT_SIZEOF_V1;
-		else {
-			vdev->extended_caps = true;
+		else
 			return PCI_CAP_EXP_ENDPOINT_SIZEOF_V2;
-		}
 	case PCI_CAP_ID_HT:
 		ret = pci_read_config_byte(pdev, pos + 3, &byte);
 		if (ret)

