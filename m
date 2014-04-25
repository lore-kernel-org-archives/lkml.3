Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbaDYKTu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 06:19:50 -0400
Received: from 132.79-246-81.adsl-static.isp.belgacom.be ([81.246.79.132]:39480
	"EHLO viper.mind.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbaDYKSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 06:18:42 -0400
To: jic23@cam.ac.uk
Subject: [PATCH] Fixed segfault in Invensens MPU driver
X-Mailer: IlohaMail/0.8.14 (On: belels005)
Message-ID: <XH2U0J49.1398421120.2347610.filiza@localhost>
From: "Atilla Filiz" <atilla.filiz@essensium.com>
Bounce-To: "Atilla Filiz" <atilla.filiz@essensium.com>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Apr 2014 12:18:40 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello

I found the Invensense MPU6050 driver is not Device-Tree compatible, so I
fixed it. I willl appreciate if you CC your comments to myself.

Regards
Atilla

>From 69995b31f67727e3b9605c494beaeeefd1aa1cd4 Mon Sep 17 00:00:00 2001
From: Atilla Filiz <atilla.filiz@essensium.com>
Date: Fri, 11 Apr 2014 16:51:23 +0200
Subject: [PATCH] Fixed segfault in Invensens MPU driver

The driver used to segfault when the kernel boots
vith device tree

Signed-off-by: Atilla Filiz <atilla.filiz@essensium.com>
---
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
index 37ca05b..3c2ef2e 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
@@ -660,6 +660,7 @@ static int inv_mpu_probe(struct i2c_client *client,
 {
 	struct inv_mpu6050_state *st;
 	struct iio_dev *indio_dev;
+	struct inv_mpu6050_platform_data *pdata;
 	int result;

 	if (!i2c_check_functionality(client->adapter,
@@ -675,8 +676,10 @@ static int inv_mpu_probe(struct i2c_client *client,
 	}
 	st = iio_priv(indio_dev);
 	st->client = client;
-	st->plat_data = *(struct inv_mpu6050_platform_data
-				*)dev_get_platdata(&client->dev);
+	pdata = (struct inv_mpu6050_platform_data
+			*)dev_get_platdata(&client->dev);
+	if (pdata)
+		st->plat_data = *pdata;
 	/* power is turned on inside check chip type*/
 	result = inv_check_and_setup_chip(st, id);
 	if (result)
--
1.8.1.2



