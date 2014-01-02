Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297AbaABWpM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 17:45:12 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:28538 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751920AbaABWo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 17:44:27 -0500
X-IronPort-AV: E=Sophos;i="4.95,593,1384297200"; 
   d="scan'208";a="51446860"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: kernel-janitors@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] mfd: sta2x11-mfd: use named constants for pci_power_t values
Date: Fri,  3 Jan 2014 00:40:29 +0100
Message-Id: <1388706031-22180-2-git-send-email-Julia.Lawall@lip6.fr>
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
expression pdev;
@@

pci_set_power_state(pdev,
- 0
+ PCI_D0
 )
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/mfd/sta2x11-mfd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/sta2x11-mfd.c b/drivers/mfd/sta2x11-mfd.c
index 0d42e40..5b72db0 100644
--- a/drivers/mfd/sta2x11-mfd.c
+++ b/drivers/mfd/sta2x11-mfd.c
@@ -529,7 +529,7 @@ static int sta2x11_mfd_resume(struct pci_dev *pdev)
 {
 	int err;
 
-	pci_set_power_state(pdev, 0);
+	pci_set_power_state(pdev, PCI_D0);
 	err = pci_enable_device(pdev);
 	if (err)
 		return err;

