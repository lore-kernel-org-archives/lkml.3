Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762306AbaGRP0X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 11:26:23 -0400
Received: from isis.lip6.fr ([132.227.60.2]:55219 "EHLO isis.lip6.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762194AbaGRP0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 11:26:16 -0400
X-pt: isis.lip6.fr
From: Benoit Taine <benoit.taine@lip6.fr>
To: Roger Luethi <rl@hellgate.ch>
Cc: benoit.taine@lip6.fr, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 20/25] via-rhine: Replace DEFINE_PCI_DEVICE_TABLE macro use
Date: Fri, 18 Jul 2014 17:27:07 +0200
Message-Id: <1405697232-11785-21-git-send-email-benoit.taine@lip6.fr>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1405697232-11785-1-git-send-email-benoit.taine@lip6.fr>
References: <1405697232-11785-1-git-send-email-benoit.taine@lip6.fr>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.4.3 (isis.lip6.fr [132.227.60.2]); Fri, 18 Jul 2014 17:26:12 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should prefer `struct pci_device_id` over `DEFINE_PCI_DEVICE_TABLE` to meet
kernel coding style guidelines. This issue was reported by checkpatch.

Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>

---
Tested by compilation without errors.

 drivers/net/ethernet/via/via-rhine.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/via/via-rhine.c
index 2d72f96..68c5260 100644
--- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -273,7 +273,7 @@ enum rhine_quirks {
 /* Beware of PCI posted writes */
 #define IOSYNC	do { ioread8(ioaddr + StationAddr); } while (0)
 
-static DEFINE_PCI_DEVICE_TABLE(rhine_pci_tbl) = {
+static const struct pci_device_id rhine_pci_tbl[] = {
 	{ 0x1106, 0x3043, PCI_ANY_ID, PCI_ANY_ID, },	/* VT86C100A */
 	{ 0x1106, 0x3065, PCI_ANY_ID, PCI_ANY_ID, },	/* VT6102 */
 	{ 0x1106, 0x3106, PCI_ANY_ID, PCI_ANY_ID, },	/* 6105{,L,LOM} */

