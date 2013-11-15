Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab3KOW3j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 17:29:39 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:56928 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385Ab3KOW3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 17:29:33 -0500
From: Laurent Navet <laurent.navet@gmail.com>
To: gregkh@linuxfoundation.org
Cc: peterhuewe@gmx.de, rashika.kheria@gmail.com,
        peter.p.waskiewicz.jr@intel.com, cruzjbishop@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Laurent Navet <laurent.navet@gmail.com>
Subject: [PATCH] staging: slicoss: fix possible missing iounmap
Date: Fri, 15 Nov 2013 23:30:07 +0100
Message-Id: <1384554607-2219-1-git-send-email-laurent.navet@gmail.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if slic_card_locate failed, memmapped_ioaddr is not unmapped.

Signed-off-by: Laurent Navet <laurent.navet@gmail.com>
---
 drivers/staging/slicoss/slicoss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index 652272b..ab7206d 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -3708,7 +3708,7 @@ static int slic_entry_probe(struct pci_dev *pcidev,
 	err = slic_card_locate(adapter);
 	if (err) {
 		dev_err(&pcidev->dev, "cannot locate card\n");
-		goto err_out_free_mmio_region;
+		goto err_out_unmap;
 	}
 
 	card = adapter->card;
-- 
1.8.4.2

