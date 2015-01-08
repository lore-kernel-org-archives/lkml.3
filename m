Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385AbbAHSlq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 13:41:46 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:53399 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517AbbAHSlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 13:41:45 -0500
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: tj@kernel.org
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>
Subject: [PATCH] ahci: Use dev_info() to inform about the lack of Device Sleep support
Date: Thu,  8 Jan 2015 19:41:34 +0100
Message-Id: <1420742494-5017-1-git-send-email-gabriele.mzt@gmail.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the Serial ATA AHCI specification, Device Sleep is an
optional feature and as such no errors should be printed if it's
missing. Keep informing users, but use dev_info() instead of dev_err().

Signed-off-by: Gabriele Mazzotta <gabriele.mzt@gmail.com>
---
 drivers/ata/libahci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index 97683e4..61a9c07 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -2003,7 +2003,7 @@ static void ahci_set_aggressive_devslp(struct ata_port *ap, bool sleep)
 
 	devslp = readl(port_mmio + PORT_DEVSLP);
 	if (!(devslp & PORT_DEVSLP_DSP)) {
-		dev_err(ap->host->dev, "port does not support device sleep\n");
+		dev_info(ap->host->dev, "port does not support device sleep\n");
 		return;
 	}
 
-- 
2.1.4

