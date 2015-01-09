Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbbAIDqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 22:46:37 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34684 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352AbbAIDqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 22:46:36 -0500
From: Gigi Joseph <gigi.joseph@gmail.com>
X-Google-Original-From: Gigi Joseph <gigi.joseph@ti.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Enric Balletbo i Serra <eballetbo@iseebcn.com>,
        Robin van der Gracht <robin@protonic.nl>, linux-kernel@vger.kernel.org
Cc: Gigi Joseph <gigi.joseph@ti.com>, Eyal Reizer <eyalr@ti.com>
Subject: [PATCH 2/6] st_kim: allow suspend if callback is not registered
Date: Fri,  9 Jan 2015 03:46:24 +0000
Message-Id: <1420775184-24704-1-git-send-email-gigi.joseph@ti.com>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suspend/resume was failing if callbacks were not registered.
As it is ok not to do anything when suspending fix this
so it soen't return an error and allow the system to suspend.

Signed-off-by: Eyal Reizer <eyalr@ti.com>
Signed-off-by: Gigi Joseph <gigi.joseph@ti.com>
---
 drivers/misc/ti-st/st_kim.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/ti-st/st_kim.c b/drivers/misc/ti-st/st_kim.c
index 68a0b58..f2c1071 100644
--- a/drivers/misc/ti-st/st_kim.c
+++ b/drivers/misc/ti-st/st_kim.c
@@ -908,7 +908,7 @@ static int kim_suspend(struct platform_device *pdev, pm_message_t state)
 	if (pdata->suspend)
 		return pdata->suspend(pdev, state);
 
-	return -EOPNOTSUPP;
+	return 0;
 }
 
 static int kim_resume(struct platform_device *pdev)
@@ -925,7 +925,7 @@ static int kim_resume(struct platform_device *pdev)
 	if (pdata->resume)
 		return pdata->resume(pdev);
 
-	return -EOPNOTSUPP;
+	return 0;
 }
 
 /**********************************************************************/
-- 
1.9.1

