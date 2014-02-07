Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699AbaBGIpu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 03:45:50 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:36045 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbaBGIps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 03:45:48 -0500
From: Levente Kurusa <levex@linux.com>
To: LKML <linux-kernel@vger.kernel.org>, Jingoo Han <jg1.han@samsung.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        FBDEV list <linux-fbdev@vger.kernel.org>
Cc: Levente Kurusa <levex@linux.com>
Subject: [PATCH] backlight: replace kfree with put_device
Date: Fri,  7 Feb 2014 09:43:21 +0100
Message-Id: <1391762601-4560-1-git-send-email-levex@linux.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As per the comments on device_register, we shouldn't call kfree()
right after a device_register() failure. Instead call put_device(),
which in turn will call bl_device_release resulting in a kfree to the
full structure.

Signed-off-by: Levente Kurusa <levex@linux.com>
---
 drivers/video/backlight/backlight.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index 5d05555..20b276e 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -333,7 +333,7 @@ struct backlight_device *backlight_device_register(const char *name,
 
 	rc = device_register(&new_bd->dev);
 	if (rc) {
-		kfree(new_bd);
+		put_device(&new_bd->dev);
 		return ERR_PTR(rc);
 	}
 
-- 
1.8.3.1

