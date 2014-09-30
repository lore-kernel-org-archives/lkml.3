Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbaI3OUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 10:20:45 -0400
Received: from smtp81.ord1c.emailsrvr.com ([108.166.43.81]:33861 "EHLO
	smtp81.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751190AbaI3OUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 10:20:44 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        linux-input@vger.kernel.org, linux-gpio@vger.kernel.org
Subject: [PATCH] HID: cp2112: remove use of gpiochip_remove() retval
Date: Tue, 30 Sep 2014 19:54:09 +0530
Message-Id: <1412087049-4368-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of using return value from gpiochip_remove() as it returns
void.

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org 
Cc: linux-gpio@vger.kernel.org

Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/hid/hid-cp2112.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-cp2112.c b/drivers/hid/hid-cp2112.c
index a822db5..3318de6 100644
--- a/drivers/hid/hid-cp2112.c
+++ b/drivers/hid/hid-cp2112.c
@@ -1069,8 +1069,7 @@ static int cp2112_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	return ret;
 
 err_gpiochip_remove:
-	if (gpiochip_remove(&dev->gc) < 0)
-		hid_err(hdev, "error removing gpio chip\n");
+	gpiochip_remove(&dev->gc);
 err_free_i2c:
 	i2c_del_adapter(&dev->adap);
 err_free_dev:
@@ -1089,8 +1088,7 @@ static void cp2112_remove(struct hid_device *hdev)
 	struct cp2112_device *dev = hid_get_drvdata(hdev);
 
 	sysfs_remove_group(&hdev->dev.kobj, &cp2112_attr_group);
-	if (gpiochip_remove(&dev->gc))
-		hid_err(hdev, "unable to remove gpio chip\n");
+	gpiochip_remove(&dev->gc);
 	i2c_del_adapter(&dev->adap);
 	/* i2c_del_adapter has finished removing all i2c devices from our
 	 * adapter. Well behaved devices should no longer call our cp2112_xfer
-- 
1.7.9.5

