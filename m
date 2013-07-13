Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757656Ab3GMLBL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 07:01:11 -0400
Received: from mail-ee0-f44.google.com ([74.125.83.44]:41246 "EHLO
	mail-ee0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab3GMLBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 07:01:09 -0400
From: Dragos Foianu <dragos.foianu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Dragos Foianu <dragos.foianu@gmail.com>
Subject: [PATCH] aic7xxx/aic79xx: replaced string duplication code with kstrdup
Date: Sat, 13 Jul 2013 14:01:02 +0100
Message-Id: <1373720462-13190-1-git-send-email-dragos.foianu@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced kmalloc + strcpy code with kstrdup.

Found using coccinelle.

Signed-off-by: Dragos Foianu <dragos.foianu@gmail.com>
---
 drivers/scsi/aic7xxx/aic79xx_osm_pci.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c b/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
index 3c85873..8466aa7 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm_pci.c
@@ -178,10 +178,9 @@ ahd_linux_pci_dev_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		ahd_get_pci_bus(pci),
 		ahd_get_pci_slot(pci),
 		ahd_get_pci_function(pci));
-	name = kmalloc(strlen(buf) + 1, GFP_ATOMIC);
+	name = kstrdup(buf, GFP_ATOMIC);
 	if (name == NULL)
 		return (-ENOMEM);
-	strcpy(name, buf);
 	ahd = ahd_alloc(NULL, name);
 	if (ahd == NULL)
 		return (-ENOMEM);
-- 
1.7.10.4

