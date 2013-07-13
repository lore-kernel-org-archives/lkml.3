Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448Ab3GMK5Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 06:57:24 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:37691 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab3GMK5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 06:57:23 -0400
From: Dragos Foianu <dragos.foianu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dragos Foianu <dragos.foianu@gmail.com>
Subject: [PATCH] aic7xxx: replaced string duplication code with kstrdup
Date: Sat, 13 Jul 2013 13:57:16 +0100
Message-Id: <1373720236-13005-1-git-send-email-dragos.foianu@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modified ahc_linux_pci_dev_probe function to use kstrdup instead of duplicating its implementation.

Found using coccinelle.

Signed-off-by: Dragos Foianu <dragos.foianu@gmail.com>
---
 drivers/scsi/aic7xxx/aic7xxx_osm_pci.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
index ee05e84..0fc14da 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
@@ -225,10 +225,9 @@ ahc_linux_pci_dev_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		ahc_get_pci_bus(pci),
 		ahc_get_pci_slot(pci),
 		ahc_get_pci_function(pci));
-	name = kmalloc(strlen(buf) + 1, GFP_ATOMIC);
+	name = kstrdup(buf, GFP_ATOMIC);
 	if (name == NULL)
 		return (-ENOMEM);
-	strcpy(name, buf);
 	ahc = ahc_alloc(NULL, name);
 	if (ahc == NULL)
 		return (-ENOMEM);
-- 
1.7.10.4

