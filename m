Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933461AbaGOUrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 16:47:22 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:62610 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757922AbaGOUrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 16:47:19 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: forest@alittletooquiet.net, gregkh@linuxfoundation.org, tvboxspy@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Cc: Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH V5 6/6] staging: vt6556: Replace printk by dev_warn
Date: Tue, 15 Jul 2014 22:46:49 +0200
Message-Id: <1405457209-6584-2-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405457209-6584-1-git-send-email-peter.senna@gmail.com>
References: <1405457209-6584-1-git-send-email-peter.senna@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a checkpatch warning by replacing printk
by dev_warn. Tested by compilation only.

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
Changes from V4:
 - use dev_warn instead of pr_warn

 drivers/staging/vt6656/main_usb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 7567646..6708e98 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -527,7 +527,8 @@ static void usb_device_reset(struct vnt_private *pDevice)
 
 	status = usb_reset_device(pDevice->usb);
 	if (status)
-            printk("usb_device_reset fail status=%d\n",status);
+		dev_warn(&pDevice->usb->dev,
+			 "usb_device_reset fail status=%d\n", status);
 }
 
 static void device_free_int_bufs(struct vnt_private *priv)
-- 
1.9.3

