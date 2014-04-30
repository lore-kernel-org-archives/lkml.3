Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759016AbaD3Ny2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 09:54:28 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:40269 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758944AbaD3Ny1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 09:54:27 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        david.vrabel@citrix.com, boris.ostrovsky@oracle.com, jbeulich@suse.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v1 5/6] xen/pciback: Document the entry points for 'pcistub_put_pci_dev'
Date: Wed, 30 Apr 2014 09:54:10 -0400
Message-Id: <1398866051-32714-6-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398866051-32714-1-git-send-email-konrad.wilk@oracle.com>
References: <1398866051-32714-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

which are quite a few. It should be evident that dealing with that
many options is a bit complex.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/xen-pciback/pci_stub.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
index 1539bec..d57a173 100644
--- a/drivers/xen/xen-pciback/pci_stub.c
+++ b/drivers/xen/xen-pciback/pci_stub.c
@@ -242,6 +242,15 @@ struct pci_dev *pcistub_get_pci_dev(struct xen_pcibk_device *pdev,
 	return found_dev;
 }
 
+/*
+ * Called when:
+ *  - XenBus state has been reconfigure (pci unplug). See xen_pcibk_remove_device
+ *  - XenBus state has been disconnected (guest shutdown). See xen_pcibk_xenbus_remove
+ *  - 'echo BDF > unbind' on pciback module with no guest attached. See pcistub_remove
+ *  - 'echo BDF > unbind' with a guest still using it. See pcistub_remove
+ *
+ *  As such we have to be careful.
+ */
 void pcistub_put_pci_dev(struct pci_dev *dev)
 {
 	struct pcistub_device *psdev, *found_psdev = NULL;
-- 
1.8.5.3

