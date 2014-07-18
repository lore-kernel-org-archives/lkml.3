Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762218AbaGRP0Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 11:26:16 -0400
Received: from isis.lip6.fr ([132.227.60.2]:55278 "EHLO isis.lip6.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762120AbaGRP0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 11:26:11 -0400
X-pt: isis.lip6.fr
From: Benoit Taine <benoit.taine@lip6.fr>
To: Rasesh Mody <rmody@brocade.com>
Cc: benoit.taine@lip6.fr, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/25] bna: Replace DEFINE_PCI_DEVICE_TABLE macro use
Date: Fri, 18 Jul 2014 17:26:48 +0200
Message-Id: <1405697232-11785-2-git-send-email-benoit.taine@lip6.fr>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1405697232-11785-1-git-send-email-benoit.taine@lip6.fr>
References: <1405697232-11785-1-git-send-email-benoit.taine@lip6.fr>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.4.3 (isis.lip6.fr [132.227.60.2]); Fri, 18 Jul 2014 17:26:06 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should prefer `struct pci_device_id` over `DEFINE_PCI_DEVICE_TABLE` to meet
kernel coding style guidelines. This issue was reported by checkpatch.

Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>

---
Tested by compilation without errors.

 drivers/net/ethernet/brocade/bna/bnad.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/brocade/bna/bnad.c b/drivers/net/ethernet/brocade/bna/bnad.c
index 3a77f9e..16755eb 100644
--- a/drivers/net/ethernet/brocade/bna/bnad.c
+++ b/drivers/net/ethernet/brocade/bna/bnad.c
@@ -3836,7 +3836,7 @@ bnad_pci_remove(struct pci_dev *pdev)
 	free_netdev(netdev);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(bnad_pci_id_table) = {
+static const struct pci_device_id bnad_pci_id_table[] = {
 	{
 		PCI_DEVICE(PCI_VENDOR_ID_BROCADE,
 			PCI_DEVICE_ID_BROCADE_CT),

