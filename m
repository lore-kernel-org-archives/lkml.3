Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934850AbaGPSUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 14:20:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934606AbaGPSUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 14:20:10 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Arvind Kumar <arvindkumar@vmware.com>, pv-drivers@vmware.com,
        linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH v2 RESEND 23/23] vmw_pvscsi: Use pci_enable_msix_exact() instead of pci_enable_msix()
Date: Wed, 16 Jul 2014 20:05:27 +0200
Message-Id: <c27a72eaa07631ca182bfdb71d0d3d7f9f280b26.1405533479.git.agordeev@redhat.com>
In-Reply-To: <cover.1405533479.git.agordeev@redhat.com>
References: <cover.1405533479.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range()  or pci_enable_msi_exact()
and pci_enable_msix_range() or pci_enable_msix_exact()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Arvind Kumar <arvindkumar@vmware.com>
Cc: pv-drivers@vmware.com
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
Acked-by: Arvind Kumar <arvindkumar@vmware.com>
---
 drivers/scsi/vmw_pvscsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index c88e146..598f65e 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -1194,7 +1194,7 @@ static int pvscsi_setup_msix(const struct pvscsi_adapter *adapter,
 	struct msix_entry entry = { 0, PVSCSI_VECTOR_COMPLETION };
 	int ret;
 
-	ret = pci_enable_msix(adapter->dev, &entry, 1);
+	ret = pci_enable_msix_exact(adapter->dev, &entry, 1);
 	if (ret)
 		return ret;
 
-- 
1.7.7.6

