Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758937Ab3GRP36 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 11:29:58 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:35844 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614Ab3GRP35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 11:29:57 -0400
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH v2 5/5] media: davinci: vpbe: Replace printk with dev_*
Date: Thu, 18 Jul 2013 20:59:40 +0530
Message-Id: <1374161380-12762-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

Use the dev_* message logging API instead of raw printk.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 Posting independent patch of the series,
 http://www.spinics.net/lists/linux-media/msg65701.html
 
 Changes for v2:
 1: Fixed logging levels.
 
 drivers/media/platform/davinci/vpbe.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/davinci/vpbe.c b/drivers/media/platform/davinci/vpbe.c
index 33b9660..a3a36e0 100644
--- a/drivers/media/platform/davinci/vpbe.c
+++ b/drivers/media/platform/davinci/vpbe.c
@@ -595,7 +595,7 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
 	 * matching with device name
 	 */
 	if (NULL == vpbe_dev || NULL == dev) {
-		printk(KERN_ERR "Null device pointers.\n");
+		dev_err(dev, "Null device pointers.\n");
 		return -ENODEV;
 	}
 
@@ -735,7 +735,7 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
 
 	mutex_unlock(&vpbe_dev->lock);
 
-	printk(KERN_NOTICE "Setting default output to %s\n", def_output);
+	dev_notice(dev, "Setting default output to %s\n", def_output);
 	ret = vpbe_set_default_output(vpbe_dev);
 	if (ret) {
 		v4l2_err(&vpbe_dev->v4l2_dev, "Failed to set default output %s",
@@ -743,7 +743,7 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
 		return ret;
 	}
 
-	printk(KERN_NOTICE "Setting default mode to %s\n", def_mode);
+	dev_notice(dev, "Setting default mode to %s\n", def_mode);
 	ret = vpbe_set_default_mode(vpbe_dev);
 	if (ret) {
 		v4l2_err(&vpbe_dev->v4l2_dev, "Failed to set default mode %s",
-- 
1.7.9.5

