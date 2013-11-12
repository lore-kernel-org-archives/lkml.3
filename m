Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559Ab3KLTJr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 14:09:47 -0500
Received: from jacques.telenet-ops.be ([195.130.132.50]:39142 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab3KLTHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 14:07:36 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH 12/12] usb: host: Remove superfluous name casts
Date: Tue, 12 Nov 2013 20:07:25 +0100
Message-Id: <1384283245-9419-13-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384283245-9419-1-git-send-email-geert@linux-m68k.org>
References: <1384283245-9419-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_driver.name is "const char *"

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
---
 drivers/usb/host/imx21-hcd.c    |    2 +-
 drivers/usb/host/isp116x-hcd.c  |    2 +-
 drivers/usb/host/isp1362-hcd.c  |    2 +-
 drivers/usb/host/r8a66597-hcd.c |    2 +-
 drivers/usb/host/u132-hcd.c     |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/host/imx21-hcd.c b/drivers/usb/host/imx21-hcd.c
index adb01d950a16..3fb2315dcb47 100644
--- a/drivers/usb/host/imx21-hcd.c
+++ b/drivers/usb/host/imx21-hcd.c
@@ -1926,7 +1926,7 @@ failed_request_mem:
 
 static struct platform_driver imx21_hcd_driver = {
 	.driver = {
-		   .name = (char *)hcd_name,
+		   .name = hcd_name,
 		   },
 	.probe = imx21_probe,
 	.remove = imx21_remove,
diff --git a/drivers/usb/host/isp116x-hcd.c b/drivers/usb/host/isp116x-hcd.c
index c06739705d24..ab536637842d 100644
--- a/drivers/usb/host/isp116x-hcd.c
+++ b/drivers/usb/host/isp116x-hcd.c
@@ -1775,7 +1775,7 @@ static struct platform_driver isp116x_driver = {
 	.suspend = isp116x_suspend,
 	.resume = isp116x_resume,
 	.driver = {
-		.name = (char *)hcd_name,
+		.name = hcd_name,
 		.owner	= THIS_MODULE,
 	},
 };
diff --git a/drivers/usb/host/isp1362-hcd.c b/drivers/usb/host/isp1362-hcd.c
index 935a2dd367a8..cd94b108b57f 100644
--- a/drivers/usb/host/isp1362-hcd.c
+++ b/drivers/usb/host/isp1362-hcd.c
@@ -2829,7 +2829,7 @@ static struct platform_driver isp1362_driver = {
 	.suspend = isp1362_suspend,
 	.resume = isp1362_resume,
 	.driver = {
-		.name = (char *)hcd_name,
+		.name = hcd_name,
 		.owner = THIS_MODULE,
 	},
 };
diff --git a/drivers/usb/host/r8a66597-hcd.c b/drivers/usb/host/r8a66597-hcd.c
index 2ad004ae747c..3bddfcfafb79 100644
--- a/drivers/usb/host/r8a66597-hcd.c
+++ b/drivers/usb/host/r8a66597-hcd.c
@@ -2534,7 +2534,7 @@ static struct platform_driver r8a66597_driver = {
 	.probe =	r8a66597_probe,
 	.remove =	r8a66597_remove,
 	.driver		= {
-		.name = (char *) hcd_name,
+		.name = hcd_name,
 		.owner	= THIS_MODULE,
 		.pm	= R8A66597_DEV_PM_OPS,
 	},
diff --git a/drivers/usb/host/u132-hcd.c b/drivers/usb/host/u132-hcd.c
index e402beb5a069..46236e9fc87f 100644
--- a/drivers/usb/host/u132-hcd.c
+++ b/drivers/usb/host/u132-hcd.c
@@ -3217,7 +3217,7 @@ static struct platform_driver u132_platform_driver = {
 	.suspend = u132_suspend,
 	.resume = u132_resume,
 	.driver = {
-		   .name = (char *)hcd_name,
+		   .name = hcd_name,
 		   .owner = THIS_MODULE,
 		   },
 };
-- 
1.7.9.5

