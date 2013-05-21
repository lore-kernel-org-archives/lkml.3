Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758739Ab3EUCnL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 22:43:11 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:34556 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758713Ab3EUCnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 22:43:06 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <balbi@ti.com>, <gregkh@linuxfoundation.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <lizefan@huawei.com>,
        <libo.chen@huawei.com>
Subject: [PATCH 01/19] drivers/usb/musb: add missing platform_driver owner
Date: Tue, 21 May 2013 10:42:04 +0800
Message-ID: <1369104124-18192-1-git-send-email-libo.chen@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

set the owner of platform_driver, to ensure that the
caller of driver holds a module refernece

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/usb/musb/am35x.c    |    1 +
 drivers/usb/musb/blackfin.c |    1 +
 drivers/usb/musb/da8xx.c    |    1 +
 drivers/usb/musb/davinci.c  |    1 +
 drivers/usb/musb/omap2430.c |    1 +
 drivers/usb/musb/tusb6010.c |    1 +
 drivers/usb/musb/ux500.c    |    1 +
 7 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/musb/am35x.c b/drivers/usb/musb/am35x.c
index 2231850..1efe7c6 100644
--- a/drivers/usb/musb/am35x.c
+++ b/drivers/usb/musb/am35x.c
@@ -631,6 +631,7 @@ static struct platform_driver am35x_driver = {
 	.remove		= am35x_remove,
 	.driver		= {
 		.name	= "musb-am35x",
+		.owner	= THIS_MODULE,
 		.pm	= DEV_PM_OPS,
 	},
 };
diff --git a/drivers/usb/musb/blackfin.c b/drivers/usb/musb/blackfin.c
index 5e63b16..483f388 100644
--- a/drivers/usb/musb/blackfin.c
+++ b/drivers/usb/musb/blackfin.c
@@ -563,6 +563,7 @@ static struct platform_driver bfin_driver = {
 	.remove		= __exit_p(bfin_remove),
 	.driver		= {
 		.name	= "musb-blackfin",
+		.owner	= THIS_MODULE,
 		.pm	= DEV_PM_OPS,
 	},
 };
diff --git a/drivers/usb/musb/da8xx.c b/drivers/usb/musb/da8xx.c
index b903b74..d38f41c 100644
--- a/drivers/usb/musb/da8xx.c
+++ b/drivers/usb/musb/da8xx.c
@@ -575,6 +575,7 @@ static struct platform_driver da8xx_driver = {
 	.remove		= da8xx_remove,
 	.driver		= {
 		.name	= "musb-da8xx",
+		.owner	= THIS_MODULE,
 	},
 };
 
diff --git a/drivers/usb/musb/davinci.c b/drivers/usb/musb/davinci.c
index bea6cc3..acac555 100644
--- a/drivers/usb/musb/davinci.c
+++ b/drivers/usb/musb/davinci.c
@@ -607,6 +607,7 @@ static struct platform_driver davinci_driver = {
 	.remove		= davinci_remove,
 	.driver		= {
 		.name	= "musb-davinci",
+		.owner  = THIS_MODULE,
 	},
 };
 
diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index 3551f1a..2538fc7 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -668,6 +668,7 @@ static struct platform_driver omap2430_driver = {
 	.remove		= omap2430_remove,
 	.driver		= {
 		.name	= "musb-omap2430",
+		.owner  = THIS_MODULE,
 		.pm	= DEV_PM_OPS,
 		.of_match_table = of_match_ptr(omap2430_id_table),
 	},
diff --git a/drivers/usb/musb/tusb6010.c b/drivers/usb/musb/tusb6010.c
index 7369ba3..96696dc 100644
--- a/drivers/usb/musb/tusb6010.c
+++ b/drivers/usb/musb/tusb6010.c
@@ -1231,6 +1231,7 @@ static struct platform_driver tusb_driver = {
 	.remove		= tusb_remove,
 	.driver		= {
 		.name	= "musb-tusb",
+		.owner  = THIS_MODULE,
 	},
 };
 
diff --git a/drivers/usb/musb/ux500.c b/drivers/usb/musb/ux500.c
index 2c80004..aaae79e 100644
--- a/drivers/usb/musb/ux500.c
+++ b/drivers/usb/musb/ux500.c
@@ -325,6 +325,7 @@ static struct platform_driver ux500_driver = {
 	.remove		= ux500_remove,
 	.driver		= {
 		.name	= "musb-ux500",
+		.owner  = THIS_MODULE,
 		.pm	= DEV_PM_OPS,
 	},
 };
-- 
1.7.1


