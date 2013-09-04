Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935049Ab3IDOmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 10:42:19 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:38209 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934954Ab3IDOmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 10:42:16 -0400
From: Alexandru Juncu <alexj@rosedu.org>
To: m.chehab@samsung.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandru Juncu <alexj@rosedu.org>
Subject: [PATCH] dm1105: remove unneeded not-null test
Date: Wed,  4 Sep 2013 17:41:34 +0300
Message-Id: <1378305694-28879-1-git-send-email-alexj@rosedu.org>
X-Mailer: git-send-email 1.8.4.rc0.1.g8f6a3e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i2c_adap is a field of a struct and will always be allocated so
its address will never be null.

Suggested by coccinelle, manually verified.

Signed-off-by: Alexandru Juncu <alexj@rosedu.org>
---
 drivers/media/pci/dm1105/dm1105.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/pci/dm1105/dm1105.c b/drivers/media/pci/dm1105/dm1105.c
index ab797fe..110a009 100644
--- a/drivers/media/pci/dm1105/dm1105.c
+++ b/drivers/media/pci/dm1105/dm1105.c
@@ -1202,8 +1202,7 @@ static void dm1105_remove(struct pci_dev *pdev)
 	dvb_dmxdev_release(&dev->dmxdev);
 	dvb_dmx_release(dvbdemux);
 	dvb_unregister_adapter(dvb_adapter);
-	if (&dev->i2c_adap)
-		i2c_del_adapter(&dev->i2c_adap);
+	i2c_del_adapter(&dev->i2c_adap);
 
 	dm1105_hw_exit(dev);
 	synchronize_irq(pdev->irq);
-- 
1.8.4.rc0.1.g8f6a3e5

