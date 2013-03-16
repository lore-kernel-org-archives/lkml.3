Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab3CQIwi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 04:52:38 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:54510 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756099Ab3CQIwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 04:52:35 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] drivers: char: Use PTR_RET function
Date: Sat, 16 Mar 2013 16:19:51 +0200
Message-Id: <1363443591-22014-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used PTR_RET function instead of IS_ERR and PTR_ERR.
Patch found using coccinelle.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 drivers/char/tile-srom.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/tile-srom.c b/drivers/char/tile-srom.c
index 3b22a60..2e2036e 100644
--- a/drivers/char/tile-srom.c
+++ b/drivers/char/tile-srom.c
@@ -371,7 +371,7 @@ static int srom_setup_minor(struct srom_dev *srom, int index)
 
 	dev = device_create(srom_class, &platform_bus,
 			    MKDEV(srom_major, index), srom, "%d", index);
-	return IS_ERR(dev) ? PTR_ERR(dev) : 0;
+	return PTR_RET(dev);
 }
 
 /** srom_init() - Initialize the driver's module. */
-- 
1.7.9.5

