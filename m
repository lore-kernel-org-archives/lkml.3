Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761757Ab3EBU1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 16:27:23 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:62598 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761381Ab3EBU1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 16:27:22 -0400
From: Gernot Vormayr <gvormayr@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Gernot Vormayr <gvormayr@gmail.com>
Subject: [RESEND] [PATCH 1/1] block: Fix id of xsysace with missing port-number
Date: Thu,  2 May 2013 22:27:45 +0200
Message-Id: <1367526465-31886-1-git-send-email-gvormayr@gmail.com>
X-Mailer: git-send-email 1.8.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the port number is missing from the device-tree the device gets
named xs` instead of xsa. This fixes the check for missing ids.

Tested on ml507 board.

Signed-off-by: Gernot Vormayr <gvormayr@gmail.com>
---
 drivers/block/xsysace.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index 1f38643..6b5807a 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -1161,8 +1161,7 @@ static int ace_probe(struct platform_device *dev)
 	dev_dbg(&dev->dev, "ace_probe(%p)\n", dev);
 
 	/* device id and bus width */
-	of_property_read_u32(dev->dev.of_node, "port-number", &id);
-	if (id < 0)
+	if (of_property_read_u32(dev->dev.of_node, "port-number", &id))
 		id = 0;
 	if (of_find_property(dev->dev.of_node, "8-bit", NULL))
 		bus_width = ACE_BUS_WIDTH_8;
-- 
1.8.2.2

