Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095AbaBDLSB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 06:18:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4493 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214AbaBDLQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 06:16:07 -0500
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Arvind Kumar <arvindkumar@vmware.com>, pv-drivers@vmware.com,
        linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH 22/22] vmw_pvscsi: Use pci_enable_msix_range()
Date: Tue,  4 Feb 2014 12:17:08 +0100
Message-Id: <9a6fa1d91c1f23ee0bbde7c854ce03f22054345a.1391512266.git.agordeev@redhat.com>
In-Reply-To: <cover.1391512266.git.agordeev@redhat.com>
References: <cover.1391512266.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range() and pci_enable_msix_range()
interfaces.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Arvind Kumar <arvindkumar@vmware.com>
Cc: pv-drivers@vmware.com
Cc: linux-scsi@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/scsi/vmw_pvscsi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index b9755ec..c521f8e 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -1078,8 +1078,8 @@ static int pvscsi_setup_msix(const struct pvscsi_adapter *adapter,
 	struct msix_entry entry = { 0, PVSCSI_VECTOR_COMPLETION };
 	int ret;
 
-	ret = pci_enable_msix(adapter->dev, &entry, 1);
-	if (ret)
+	ret = pci_enable_msix_range(adapter->dev, &entry, 1, 1);
+	if (ret < 0)
 		return ret;
 
 	*irq = entry.vector;
-- 
1.7.7.6

