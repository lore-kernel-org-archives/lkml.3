Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921Ab3LMQZD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 11:25:03 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:38251 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305Ab3LMQZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 11:25:01 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        gordan@bobich.net
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [RFC PATCH 2/5] xen-pciback: First reset, then free.
Date: Fri, 13 Dec 2013 11:09:35 -0500
Message-Id: <1386950978-8628-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1386950978-8628-1-git-send-email-konrad.wilk@oracle.com>
References: <1386950978-8628-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We were doing the operations of freeing and reset in the wrong
order. Granted nothing broke b/c the reset functions just
set bar->which = 0.

But nonethless this was incorrect.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
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
1.8.3.1

