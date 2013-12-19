Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab3LSPIa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:08:30 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:50771 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865Ab3LSPI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:08:26 -0500
From: Levente Kurusa <levex@linux.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Levente Kurusa <levex@linux.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 35/38] media: bt8xx: add missing put_device call
Date: Thu, 19 Dec 2013 16:06:49 +0100
Message-Id: <1387465612-3673-36-git-send-email-levex@linux.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1387465612-3673-33-git-send-email-levex@linux.com>
References: <1387465612-3673-33-git-send-email-levex@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required so that we give up the last reference to the device.
Remove the kfree() because the put_device() call will actually call
release_sub_device which in turn kfrees the device.

Signed-off-by: Levente Kurusa <levex@linux.com>
---
 drivers/media/pci/bt8xx/bttv-gpio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/bt8xx/bttv-gpio.c b/drivers/media/pci/bt8xx/bttv-gpio.c
index 922e823..3f364b7 100644
--- a/drivers/media/pci/bt8xx/bttv-gpio.c
+++ b/drivers/media/pci/bt8xx/bttv-gpio.c
@@ -98,7 +98,7 @@ int bttv_sub_add_device(struct bttv_core *core, char *name)
 
 	err = device_register(&sub->dev);
 	if (0 != err) {
-		kfree(sub);
+		put_device(&sub->dev);
 		return err;
 	}
 	pr_info("%d: add subdevice \"%s\"\n", core->nr, dev_name(&sub->dev));
-- 
1.8.3.1

