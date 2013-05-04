Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab3EDF6D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 01:58:03 -0400
Received: from mail-da0-f47.google.com ([209.85.210.47]:44817 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab3EDF6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 01:58:01 -0400
Message-ID: <1367647075.4394.1.camel@phoenix>
Subject: [PATCH] power_supply: wm831x_backup: Remove kfree call for
 devdata->backup.name
From: Axel Lin <axel.lin@ingics.com>
To: Anton Vorontsov <cbou@mail.ru>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Date: Sat, 04 May 2013 13:57:55 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devdata->backup.name points to devdata->name, the memory for devdata->name is
part of struct wm831x_backup. Thus remove kfree call for devdata->backup.name.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/power/wm831x_backup.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/power/wm831x_backup.c b/drivers/power/wm831x_backup.c
index 58cbb00..56fb509 100644
--- a/drivers/power/wm831x_backup.c
+++ b/drivers/power/wm831x_backup.c
@@ -207,7 +207,6 @@ static int wm831x_backup_remove(struct platform_device *pdev)
 	struct wm831x_backup *devdata = platform_get_drvdata(pdev);
 
 	power_supply_unregister(&devdata->backup);
-	kfree(devdata->backup.name);
 
 	return 0;
 }
-- 
1.8.1.2



