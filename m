Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759730Ab3BYD03 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 22:26:29 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38642 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757463Ab3BYD02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 22:26:28 -0500
Date: Sun, 24 Feb 2013 19:26:25 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Regulator: db8500-prcmu - remove incorrect __exit markup
Message-ID: <20130225032624.GA10547@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even if bus is not hot-pluggable, the devices can be unbound from the
driver via sysfs, so we should not be using __exit annotations on
remove() methods. The only exception is drivers registered with
platform_driver_probe() which specifically disables sysfs bind/unbind
attributes.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/regulator/db8500-prcmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/db8500-prcmu.c b/drivers/regulator/db8500-prcmu.c
index 219d162..a53c11a 100644
--- a/drivers/regulator/db8500-prcmu.c
+++ b/drivers/regulator/db8500-prcmu.c
@@ -528,7 +528,7 @@ static int db8500_regulator_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static int __exit db8500_regulator_remove(struct platform_device *pdev)
+static int db8500_regulator_remove(struct platform_device *pdev)
 {
 	int i;
 
@@ -553,7 +553,7 @@ static struct platform_driver db8500_regulator_driver = {
 		.owner = THIS_MODULE,
 	},
 	.probe = db8500_regulator_probe,
-	.remove = __exit_p(db8500_regulator_remove),
+	.remove = db8500_regulator_remove,
 };
 
 static int __init db8500_regulator_init(void)
-- 
1.7.11.7


-- 
Dmitry
