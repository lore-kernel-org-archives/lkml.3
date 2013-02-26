Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759605Ab3BZHRc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 02:17:32 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:37734 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756077Ab3BZHRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 02:17:31 -0500
Date: Mon, 25 Feb 2013 23:17:27 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Timo Kokkonen <timo.t.kokkonen@iki.fi>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] Media: remove incorrect __init/__exit markups
Message-ID: <20130226071726.GA11322@core.coreip.homeip.net>
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

Similarly probe() methods should not be marked __init unless
platform_driver_probe() is used.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---

v1->v2: removed __init markup on omap1_cam_probe() that was pointed out
	by Guennadi Liakhovetski.

 drivers/media/i2c/adp1653.c                      | 4 ++--
 drivers/media/i2c/smiapp/smiapp-core.c           | 4 ++--
 drivers/media/platform/soc_camera/omap1_camera.c | 6 +++---
 drivers/media/radio/radio-si4713.c               | 4 ++--
 drivers/media/rc/ir-rx51.c                       | 4 ++--
 5 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/media/i2c/adp1653.c b/drivers/media/i2c/adp1653.c
index df16380..ef75abe 100644
--- a/drivers/media/i2c/adp1653.c
+++ b/drivers/media/i2c/adp1653.c
@@ -447,7 +447,7 @@ free_and_quit:
 	return ret;
 }
 
-static int __exit adp1653_remove(struct i2c_client *client)
+static int adp1653_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
 	struct adp1653_flash *flash = to_adp1653_flash(subdev);
@@ -476,7 +476,7 @@ static struct i2c_driver adp1653_i2c_driver = {
 		.pm	= &adp1653_pm_ops,
 	},
 	.probe		= adp1653_probe,
-	.remove		= __exit_p(adp1653_remove),
+	.remove		= adp1653_remove,
 	.id_table	= adp1653_id_table,
 };
 
diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 83c7ed7..cae4f46 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -2833,7 +2833,7 @@ static int smiapp_probe(struct i2c_client *client,
 				 sensor->src->pads, 0);
 }
 
-static int __exit smiapp_remove(struct i2c_client *client)
+static int smiapp_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
 	struct smiapp_sensor *sensor = to_smiapp_sensor(subdev);
@@ -2881,7 +2881,7 @@ static struct i2c_driver smiapp_i2c_driver = {
 		.pm = &smiapp_pm_ops,
 	},
 	.probe	= smiapp_probe,
-	.remove	= __exit_p(smiapp_remove),
+	.remove	= smiapp_remove,
 	.id_table = smiapp_id_table,
 };
 
diff --git a/drivers/media/platform/soc_camera/omap1_camera.c b/drivers/media/platform/soc_camera/omap1_camera.c
index 39a77f0..e5091b7 100644
--- a/drivers/media/platform/soc_camera/omap1_camera.c
+++ b/drivers/media/platform/soc_camera/omap1_camera.c
@@ -1546,7 +1546,7 @@ static struct soc_camera_host_ops omap1_host_ops = {
 	.poll		= omap1_cam_poll,
 };
 
-static int __init omap1_cam_probe(struct platform_device *pdev)
+static int omap1_cam_probe(struct platform_device *pdev)
 {
 	struct omap1_cam_dev *pcdev;
 	struct resource *res;
@@ -1677,7 +1677,7 @@ exit:
 	return err;
 }
 
-static int __exit omap1_cam_remove(struct platform_device *pdev)
+static int omap1_cam_remove(struct platform_device *pdev)
 {
 	struct soc_camera_host *soc_host = to_soc_camera_host(&pdev->dev);
 	struct omap1_cam_dev *pcdev = container_of(soc_host,
@@ -1709,7 +1709,7 @@ static struct platform_driver omap1_cam_driver = {
 		.name	= DRIVER_NAME,
 	},
 	.probe		= omap1_cam_probe,
-	.remove		= __exit_p(omap1_cam_remove),
+	.remove		= omap1_cam_remove,
 };
 
 module_platform_driver(omap1_cam_driver);
diff --git a/drivers/media/radio/radio-si4713.c b/drivers/media/radio/radio-si4713.c
index 1507c9d..8ae8442d 100644
--- a/drivers/media/radio/radio-si4713.c
+++ b/drivers/media/radio/radio-si4713.c
@@ -328,7 +328,7 @@ exit:
 }
 
 /* radio_si4713_pdriver_remove - remove the device */
-static int __exit radio_si4713_pdriver_remove(struct platform_device *pdev)
+static int radio_si4713_pdriver_remove(struct platform_device *pdev)
 {
 	struct v4l2_device *v4l2_dev = platform_get_drvdata(pdev);
 	struct radio_si4713_device *rsdev = container_of(v4l2_dev,
@@ -350,7 +350,7 @@ static struct platform_driver radio_si4713_pdriver = {
 		.name	= "radio-si4713",
 	},
 	.probe		= radio_si4713_pdriver_probe,
-	.remove         = __exit_p(radio_si4713_pdriver_remove),
+	.remove         = radio_si4713_pdriver_remove,
 };
 
 module_platform_driver(radio_si4713_pdriver);
diff --git a/drivers/media/rc/ir-rx51.c b/drivers/media/rc/ir-rx51.c
index 8ead492..31b955b 100644
--- a/drivers/media/rc/ir-rx51.c
+++ b/drivers/media/rc/ir-rx51.c
@@ -464,14 +464,14 @@ static int lirc_rx51_probe(struct platform_device *dev)
 	return 0;
 }
 
-static int __exit lirc_rx51_remove(struct platform_device *dev)
+static int lirc_rx51_remove(struct platform_device *dev)
 {
 	return lirc_unregister_driver(lirc_rx51_driver.minor);
 }
 
 struct platform_driver lirc_rx51_platform_driver = {
 	.probe		= lirc_rx51_probe,
-	.remove		= __exit_p(lirc_rx51_remove),
+	.remove		= lirc_rx51_remove,
 	.suspend	= lirc_rx51_suspend,
 	.resume		= lirc_rx51_resume,
 	.driver		= {
-- 
1.7.11.7


-- 
Dmitry
