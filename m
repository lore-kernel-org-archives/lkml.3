Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763Ab3COATe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 20:19:34 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43766 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872Ab3COATd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 20:19:33 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Richard Purdie <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] backlight: lp855x: use PAGE_SIZE for the sysfs read
 operation
Thread-Topic: [PATCH] backlight: lp855x: use PAGE_SIZE for the sysfs read
 operation
Thread-Index: Ac4hErpqRU9HafcSS8WCFIYE02q2gQ==
Date: Fri, 15 Mar 2013 00:19:17 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F82E48A06@DQHE02.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sysfs allocates PAGE_SIZE. It is used by each R/W operation method.
Use it instead of another buffer size.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/video/backlight/lp855x_bl.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/video/backlight/lp855x_bl.c b/drivers/video/backlight/lp855x_bl.c
index 7ae9ae6..d47efe1 100644
--- a/drivers/video/backlight/lp855x_bl.c
+++ b/drivers/video/backlight/lp855x_bl.c
@@ -35,7 +35,6 @@
 #define LP8557_EPROM_START		0x10
 #define LP8557_EPROM_END		0x1E
 
-#define BUF_SIZE		20
 #define DEFAULT_BL_NAME		"lcd-backlight"
 #define MAX_BRIGHTNESS		255
 
@@ -304,7 +303,7 @@ static ssize_t lp855x_get_chip_id(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
 	struct lp855x *lp = dev_get_drvdata(dev);
-	return scnprintf(buf, BUF_SIZE, "%s\n", lp->chipname);
+	return scnprintf(buf, PAGE_SIZE, "%s\n", lp->chipname);
 }
 
 static ssize_t lp855x_get_bl_ctl_mode(struct device *dev,
@@ -319,7 +318,7 @@ static ssize_t lp855x_get_bl_ctl_mode(struct device *dev,
 	else if (mode == REGISTER_BASED)
 		strmode = "register based";
 
-	return scnprintf(buf, BUF_SIZE, "%s\n", strmode);
+	return scnprintf(buf, PAGE_SIZE, "%s\n", strmode);
 }
 
 static DEVICE_ATTR(chip_id, S_IRUGO, lp855x_get_chip_id, NULL);
-- 
1.7.9.5


Best Regards,
Milo

