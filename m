Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233AbaABWop (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 17:44:45 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:28538 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752940AbaABWo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 17:44:28 -0500
X-IronPort-AV: E=Sophos;i="4.95,593,1384297200"; 
   d="scan'208";a="51446862"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Steve Glendinning <steve.glendinning@shawell.net>
Cc: kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] smsc9420: use named constants for pci_power_t values
Date: Fri,  3 Jan 2014 00:40:31 +0100
Message-Id: <1388706031-22180-4-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1388706031-22180-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1388706031-22180-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e1,e2;
@@

pci_enable_wake(e1,
- 0
+ PCI_D0
,e2)
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/net/ethernet/smsc/smsc9420.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/smsc/smsc9420.c b/drivers/net/ethernet/smsc/smsc9420.c
index 9d6effe..d3b967a 100644
--- a/drivers/net/ethernet/smsc/smsc9420.c
+++ b/drivers/net/ethernet/smsc/smsc9420.c
@@ -1540,7 +1540,7 @@ static int smsc9420_resume(struct pci_dev *pdev)
 
 	pci_set_master(pdev);
 
-	err = pci_enable_wake(pdev, 0, 0);
+	err = pci_enable_wake(pdev, PCI_D0, 0);
 	if (err)
 		netif_warn(pd, ifup, pd->dev, "pci_enable_wake failed: %d\n",
 			   err);

