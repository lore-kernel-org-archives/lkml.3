Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513AbaGIGH2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 02:07:28 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:51716 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbaGIGH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 02:07:26 -0400
From: Anil Belur <askb23@gmail.com>
X-Google-Original-From: Anil Belur
To: m.chehab@samsung.com, dan.carpenter@oracle.com, pavel@ucw.cz,
        gregkh@linuxfoundation.org
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Anil Belur <askb23@gmail.com>
Subject: [PATCH 1/2] staging: media: bcm2048: radio-bcm2048.c - removed IRQF_DISABLED macro
Date: Wed,  9 Jul 2014 11:36:37 +0530
Message-Id: <1404885998-10981-1-git-send-email-askb23@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anil Belur <askb23@gmail.com>

- this patch removes IRQF_DISABLED macro, as this is
  deprecated/noop.

Signed-off-by: Anil Belur <askb23@gmail.com>
---
 drivers/staging/media/bcm2048/radio-bcm2048.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
index bbf236e..8760eca 100644
--- a/drivers/staging/media/bcm2048/radio-bcm2048.c
+++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
@@ -2618,7 +2618,7 @@ static int bcm2048_i2c_driver_probe(struct i2c_client *client,
 
 	if (client->irq) {
 		err = request_irq(client->irq,
-			bcm2048_handler, IRQF_TRIGGER_FALLING | IRQF_DISABLED,
+			bcm2048_handler, IRQF_TRIGGER_FALLING,
 			client->name, bdev);
 		if (err < 0) {
 			dev_err(&client->dev, "Could not request IRQ\n");
-- 
1.9.1

