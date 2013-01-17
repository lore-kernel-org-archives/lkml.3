Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143Ab3AQR0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 12:26:42 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:45966 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754776Ab3AQR0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 12:26:41 -0500
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, Koen Kooi <koen@dominion.thruhere.net>
Subject: [PATCH] Link platform device resources properly.
Date: Thu, 17 Jan 2013 19:26:36 +0200
Message-Id: <1358443596-30631-1-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The resources of the platform devices created by the OF core were
not properly linked. Make sure that they are, so that we don't get
any crashes when trying to remove the device.

Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
---
 drivers/of/device.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/of/device.c b/drivers/of/device.c
index 4c74e4f..d75fcaf 100644
--- a/drivers/of/device.c
+++ b/drivers/of/device.c
@@ -62,6 +62,9 @@ int of_device_add(struct platform_device *ofdev)
 	if (!ofdev->dev.parent)
 		set_dev_node(&ofdev->dev, of_node_to_nid(ofdev->dev.of_node));
 
+	/* make sure we add the resources to the appropriate lists */
+	platform_device_link_resources(ofdev);
+
 	return device_add(&ofdev->dev);
 }
 
-- 
1.7.12

