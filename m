Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030315AbaGPQIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 12:08:19 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:49918 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934551AbaGPQIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 12:08:16 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: forest@alittletooquiet.net, gregkh@linuxfoundation.org, tvboxspy@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Cc: Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH V6 6/6] staging: vt6556: Replace printk by dev_warn
Date: Wed, 16 Jul 2014 18:08:02 +0200
Message-Id: <1405526882-7904-1-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a checkpatch warning by replacing printk
by dev_warn. Tested by compilation only.

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
Changes from V5
 - Refresh for staging-next of 16/07/2014

 drivers/staging/vt6656/main_usb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index a3057da..c595a15 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -534,7 +534,8 @@ static void usb_device_reset(struct vnt_private *pDevice)
 
 	status = usb_reset_device(pDevice->usb);
 	if (status)
-            printk("usb_device_reset fail status=%d\n",status);
+		dev_warn(&pDevice->usb->dev,
+			 "usb_device_reset fail status=%d\n", status);
 	return ;
 }
 
-- 
1.9.3

