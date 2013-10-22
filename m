Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863Ab3JVQhK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 12:37:10 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:48368 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab3JVQhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 12:37:07 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [PATCH] atmel_lcdfb: fix module autoload
Date: Tue, 22 Oct 2013 18:36:57 +0200
Message-Id: <1382459817-26990-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing module device table which is needed for module autoloading.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
---
 drivers/video/atmel_lcdfb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
index 088511a..67b339c 100644
--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@ -94,6 +94,7 @@ static const struct platform_device_id atmel_lcdfb_devtypes[] = {
 		/* terminator */
 	}
 };
+MODULE_DEVICE_TABLE(platform, atmel_lcdfb_devtypes);
 
 static struct atmel_lcdfb_config *
 atmel_lcdfb_get_config(struct platform_device *pdev)
-- 
1.8.4

