Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759201AbaD3Nzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 09:55:45 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:16997 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758879AbaD3Ny0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 09:54:26 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        david.vrabel@citrix.com, boris.ostrovsky@oracle.com, jbeulich@suse.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH v1 2/6] xen-pciback: First reset, then free.
Date: Wed, 30 Apr 2014 09:54:07 -0400
Message-Id: <1398866051-32714-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398866051-32714-1-git-send-email-konrad.wilk@oracle.com>
References: <1398866051-32714-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We were doing the operations of freeing and reset in the wrong
order. Granted nothing broke because the reset functions just
set bar->which = 0.

But nonethless this was incorrect.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Reviewed-by: Jan Beulich <jbeulich@suse.com>
---
 drivers/xen/xen-pciback/pci_stub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
index 5300a21..36dd4f3 100644
--- a/drivers/xen/xen-pciback/pci_stub.c
+++ b/drivers/xen/xen-pciback/pci_stub.c
@@ -278,8 +278,8 @@ void pcistub_put_pci_dev(struct pci_dev *dev)
 	xen_pcibk_reset_device(dev);
 
 	/* And cleanup up our emulated fields. */
-	xen_pcibk_config_free_dyn_fields(dev);
 	xen_pcibk_config_reset_dev(dev);
+	xen_pcibk_config_free_dyn_fields(dev);
 
 	xen_unregister_device_domain_owner(dev);
 
-- 
1.8.5.3

