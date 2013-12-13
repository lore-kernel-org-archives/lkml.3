Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab3LMQZF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 11:25:05 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:38253 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab3LMQZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 11:25:01 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        gordan@bobich.net
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [RFC PATCH 1/5] xen-pciback: Cleanup up pcistub_put_pci_dev
Date: Fri, 13 Dec 2013 11:09:34 -0500
Message-Id: <1386950978-8628-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1386950978-8628-1-git-send-email-konrad.wilk@oracle.com>
References: <1386950978-8628-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are using both psdev->dev and dev and both are the same.
To keep it straight lets just use one - dev.

This will also make it easier in the patch:
"xen/pciback: When reconfiguring an PCIe device, FLR it"
and "xen/pciback: PCI reset slot or bus" to use it.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/xen-pciback/pci_stub.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
index 62fcd48..5300a21 100644
--- a/drivers/xen/xen-pciback/pci_stub.c
+++ b/drivers/xen/xen-pciback/pci_stub.c
@@ -272,16 +272,16 @@ void pcistub_put_pci_dev(struct pci_dev *dev)
 	 * and want to inhibit the user from fiddling with 'reset'
 	 */
 	pci_reset_function(dev);
-	pci_restore_state(psdev->dev);
+	pci_restore_state(dev);
 
 	/* This disables the device. */
-	xen_pcibk_reset_device(found_psdev->dev);
+	xen_pcibk_reset_device(dev);
 
 	/* And cleanup up our emulated fields. */
-	xen_pcibk_config_free_dyn_fields(found_psdev->dev);
-	xen_pcibk_config_reset_dev(found_psdev->dev);
+	xen_pcibk_config_free_dyn_fields(dev);
+	xen_pcibk_config_reset_dev(dev);
 
-	xen_unregister_device_domain_owner(found_psdev->dev);
+	xen_unregister_device_domain_owner(dev);
 
 	spin_lock_irqsave(&found_psdev->lock, flags);
 	found_psdev->pdev = NULL;
-- 
1.8.3.1

