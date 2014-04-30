Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759080AbaD3Nya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 09:54:30 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:17015 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758974AbaD3Ny1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 09:54:27 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        david.vrabel@citrix.com, boris.ostrovsky@oracle.com, jbeulich@suse.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v1 1/6] xen-pciback: Cleanup up pcistub_put_pci_dev
Date: Wed, 30 Apr 2014 09:54:06 -0400
Message-Id: <1398866051-32714-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398866051-32714-1-git-send-email-konrad.wilk@oracle.com>
References: <1398866051-32714-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are using 'psdev->dev','found_psdev->dev', and 'dev' at the
same time - and they all point to the same structure.

To keep it straight lets just use one - 'dev'.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
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
1.8.5.3

