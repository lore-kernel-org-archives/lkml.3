Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbaJUPAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 11:00:36 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:53124 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754553AbaJUPAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 11:00:35 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] staging: vt6655: Remove redundant cast
Date: Tue, 21 Oct 2014 17:00:24 +0200
Message-Id: <1413903624-3310-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both sides have type const struct iw_handler_def*, so the cast is
unnecessary and confusing.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/staging/vt6655/device_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 54e16f4..9281713 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -936,7 +936,7 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 	dev->irq                = pcid->irq;
 	dev->netdev_ops         = &device_netdev_ops;
 
-	dev->wireless_handlers = (struct iw_handler_def *)&iwctl_handler_def;
+	dev->wireless_handlers = &iwctl_handler_def;
 
 	rc = register_netdev(dev);
 	if (rc) {
-- 
2.0.4

