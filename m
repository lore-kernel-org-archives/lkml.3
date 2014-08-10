Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763AbaHJUmA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 16:42:00 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:43442 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbaHJUl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 16:41:59 -0400
From: Suman Kumar <suman@inforcecomputing.com>
To: hverkuil@xs4all.nl
Cc: g.liakhovetski@gmx.de, m.chehab@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, suman@inforcecomputing.com,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] staging: soc_camera.c: fixed coding style: lines over 80 char
Date: Mon, 11 Aug 2014 02:11:41 +0530
Message-Id: <1407703301-2037-1-git-send-email-suman@inforcecomputing.com>
X-Mailer: git-send-email 1.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    Fixes a coding style issue of 'lines over 80 char' reported by
    checkpatch.pl

Signed-off-by: Suman Kumar <suman@inforcecomputing.com>
---
 drivers/media/platform/soc_camera/soc_camera.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 968a64b..1b7e0e1 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -115,7 +115,8 @@ eregenable:
 }
 EXPORT_SYMBOL(soc_camera_power_on);
 
-int soc_camera_power_off(struct device *dev, struct soc_camera_subdev_desc *ssdd,
+int soc_camera_power_off(struct device *dev,
+			 struct soc_camera_subdev_desc *ssdd,
 			 struct v4l2_clk *clk)
 {
 	int ret = 0;
@@ -144,7 +145,8 @@ int soc_camera_power_off(struct device *dev, struct soc_camera_subdev_desc *ssdd
 }
 EXPORT_SYMBOL(soc_camera_power_off);
 
-int soc_camera_power_init(struct device *dev, struct soc_camera_subdev_desc *ssdd)
+int soc_camera_power_init(struct device *dev,
+			  struct soc_camera_subdev_desc *ssdd)
 {
 	/* Should not have any effect in synchronous case */
 	return devm_regulator_bulk_get(dev, ssdd->sd_pdata.num_regulators,
@@ -199,7 +201,9 @@ unsigned long soc_camera_apply_board_flags(struct soc_camera_subdev_desc *ssdd,
 {
 	unsigned long f, flags = cfg->flags;
 
-	/* If only one of the two polarities is supported, switch to the opposite */
+	/* If only one of the two polarities is supported,
+	 * switch to the opposite
+	 */
 	if (ssdd->flags & SOCAM_SENSOR_INVERT_HSYNC) {
 		f = flags & (V4L2_MBUS_HSYNC_ACTIVE_HIGH | V4L2_MBUS_HSYNC_ACTIVE_LOW);
 		if (f == V4L2_MBUS_HSYNC_ACTIVE_HIGH || f == V4L2_MBUS_HSYNC_ACTIVE_LOW)
@@ -1430,7 +1434,7 @@ static int soc_camera_async_bound(struct v4l2_async_notifier *notifier,
 				  struct v4l2_async_subdev *asd)
 {
 	struct soc_camera_async_client *sasc = container_of(notifier,
-					struct soc_camera_async_client, notifier);
+				    struct soc_camera_async_client, notifier);
 	struct soc_camera_device *icd = platform_get_drvdata(sasc->pdev);
 
 	if (asd == sasc->sensor && !WARN_ON(icd->control)) {
@@ -1463,7 +1467,7 @@ static void soc_camera_async_unbind(struct v4l2_async_notifier *notifier,
 				    struct v4l2_async_subdev *asd)
 {
 	struct soc_camera_async_client *sasc = container_of(notifier,
-					struct soc_camera_async_client, notifier);
+				    struct soc_camera_async_client, notifier);
 	struct soc_camera_device *icd = platform_get_drvdata(sasc->pdev);
 
 	if (icd->clk) {
@@ -1475,7 +1479,7 @@ static void soc_camera_async_unbind(struct v4l2_async_notifier *notifier,
 static int soc_camera_async_complete(struct v4l2_async_notifier *notifier)
 {
 	struct soc_camera_async_client *sasc = container_of(notifier,
-					struct soc_camera_async_client, notifier);
+				    struct soc_camera_async_client, notifier);
 	struct soc_camera_device *icd = platform_get_drvdata(sasc->pdev);
 
 	if (to_soc_camera_control(icd)) {
@@ -1735,14 +1739,16 @@ static int default_cropcap(struct soc_camera_device *icd,
 	return v4l2_subdev_call(sd, video, cropcap, a);
 }
 
-static int default_g_crop(struct soc_camera_device *icd, struct v4l2_crop *a)
+static int default_g_crop(struct soc_camera_device *icd,
+			  struct v4l2_crop *a)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 
 	return v4l2_subdev_call(sd, video, g_crop, a);
 }
 
-static int default_s_crop(struct soc_camera_device *icd, const struct v4l2_crop *a)
+static int default_s_crop(struct soc_camera_device *icd,
+			  const struct v4l2_crop *a)
 {
 	struct v4l2_subdev *sd = soc_camera_to_subdev(icd);
 
@@ -1926,8 +1932,8 @@ static int soc_camera_device_register(struct soc_camera_device *icd)
 	icd->host_priv		= NULL;
 
 	/*
-	 * Dynamically allocated devices set the bit earlier, but it doesn't hurt setting
-	 * it again
+	 * Dynamically allocated devices set the bit earlier,
+	 * but it doesn't hurt setting it again
 	 */
 	i = to_platform_device(icd->pdev)->id;
 	if (i < 0)
-- 
1.8.2

