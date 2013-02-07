Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768Ab3BGObC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 09:31:02 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:46218 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758236Ab3BGObA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 09:31:00 -0500
From: Michal Simek <michal.simek@xilinx.com>
To: linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc: Alexey.Brodkin@synopsys.com, grant.likely@secretlab.ca,
        Graeme Smecher <gsmecher@threespeedlogic.com>
Subject: [PATCH] block: xsysace: Fix device name assignment for SystemACE (from "xs`" to "xsa").
Date: Thu,  7 Feb 2013 15:30:52 +0100
Message-Id: <1360247452-15451-1-git-send-email-michal.simek@xilinx.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graeme Smecher <gsmecher@threespeedlogic.com>

This fixes a bug introduced in 5d10302f46d, where device trees that don't
provide the "port-number" attribute are mistakenly assigned the device "xs`".
The error check that's supposed to assign a default letter can't succeed,
since it tests an unsigned type against a negative return code.

Signed-off-by: Graeme Smecher <gsmecher@threespeedlogic.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
---
 drivers/block/xsysace.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index 64fd3c0..9462e68 100644
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
1.7.0.4

