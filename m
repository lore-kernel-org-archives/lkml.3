Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255AbaCEPCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 10:02:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41200 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757518AbaCEO0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:26:47 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Denis Ciocca <denis.ciocca@st.com>, Jonathan Cameron <jic23@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 099/131] iio:gyro: bug on L3GD20H gyroscope support
Date: Wed,  5 Mar 2014 14:23:43 +0000
Message-Id: <1394029455-23128-100-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis CIOCCA <denis.ciocca@st.com>

commit a0657716416f834ef7710a9044614d50a36c3bdc upstream.

The driver was not able to manage the sensor: during probe function
and wai check, the driver stops and writes: "device name and WhoAmI mismatch."
The correct value of L3GD20H wai is 0xd7 instead of 0xd4.
Dropped support for the sensor.

Signed-off-by: Denis Ciocca <denis.ciocca@st.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/iio/gyro/Kconfig        | 2 +-
 drivers/iio/gyro/st_gyro.h      | 1 -
 drivers/iio/gyro/st_gyro_core.c | 9 ++++-----
 drivers/iio/gyro/st_gyro_i2c.c  | 1 -
 drivers/iio/gyro/st_gyro_spi.c  | 1 -
 5 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/iio/gyro/Kconfig b/drivers/iio/gyro/Kconfig
index 8498e9d..c400416 100644
--- a/drivers/iio/gyro/Kconfig
+++ b/drivers/iio/gyro/Kconfig
@@ -56,7 +56,7 @@ config IIO_ST_GYRO_3AXIS
 	select IIO_TRIGGERED_BUFFER if (IIO_BUFFER)
 	help
 	  Say yes here to build support for STMicroelectronics gyroscopes:
-	  L3G4200D, LSM330DL, L3GD20, L3GD20H, LSM330DLC, L3G4IS, LSM330.
+	  L3G4200D, LSM330DL, L3GD20, LSM330DLC, L3G4IS, LSM330.
 
 	  This driver can also be built as a module. If so, will be created
 	  these modules:
diff --git a/drivers/iio/gyro/st_gyro.h b/drivers/iio/gyro/st_gyro.h
index 3ad9907..25ee236 100644
--- a/drivers/iio/gyro/st_gyro.h
+++ b/drivers/iio/gyro/st_gyro.h
@@ -19,7 +19,6 @@
 #define LSM330DL_GYRO_DEV_NAME		"lsm330dl_gyro"
 #define LSM330DLC_GYRO_DEV_NAME		"lsm330dlc_gyro"
 #define L3GD20_GYRO_DEV_NAME		"l3gd20"
-#define L3GD20H_GYRO_DEV_NAME		"l3gd20h"
 #define L3G4IS_GYRO_DEV_NAME		"l3g4is_ui"
 #define LSM330_GYRO_DEV_NAME		"lsm330_gyro"
 
diff --git a/drivers/iio/gyro/st_gyro_core.c b/drivers/iio/gyro/st_gyro_core.c
index f9ed348..e0289e1 100644
--- a/drivers/iio/gyro/st_gyro_core.c
+++ b/drivers/iio/gyro/st_gyro_core.c
@@ -167,11 +167,10 @@ static const struct st_sensors st_gyro_sensors[] = {
 		.wai = ST_GYRO_2_WAI_EXP,
 		.sensors_supported = {
 			[0] = L3GD20_GYRO_DEV_NAME,
-			[1] = L3GD20H_GYRO_DEV_NAME,
-			[2] = LSM330D_GYRO_DEV_NAME,
-			[3] = LSM330DLC_GYRO_DEV_NAME,
-			[4] = L3G4IS_GYRO_DEV_NAME,
-			[5] = LSM330_GYRO_DEV_NAME,
+			[1] = LSM330D_GYRO_DEV_NAME,
+			[2] = LSM330DLC_GYRO_DEV_NAME,
+			[3] = L3G4IS_GYRO_DEV_NAME,
+			[4] = LSM330_GYRO_DEV_NAME,
 		},
 		.ch = (struct iio_chan_spec *)st_gyro_16bit_channels,
 		.odr = {
diff --git a/drivers/iio/gyro/st_gyro_i2c.c b/drivers/iio/gyro/st_gyro_i2c.c
index 8a31050..c1755ce 100644
--- a/drivers/iio/gyro/st_gyro_i2c.c
+++ b/drivers/iio/gyro/st_gyro_i2c.c
@@ -61,7 +61,6 @@ static const struct i2c_device_id st_gyro_id_table[] = {
 	{ LSM330DL_GYRO_DEV_NAME },
 	{ LSM330DLC_GYRO_DEV_NAME },
 	{ L3GD20_GYRO_DEV_NAME },
-	{ L3GD20H_GYRO_DEV_NAME },
 	{ L3G4IS_GYRO_DEV_NAME },
 	{ LSM330_GYRO_DEV_NAME },
 	{},
diff --git a/drivers/iio/gyro/st_gyro_spi.c b/drivers/iio/gyro/st_gyro_spi.c
index f354039..b37fc9e 100644
--- a/drivers/iio/gyro/st_gyro_spi.c
+++ b/drivers/iio/gyro/st_gyro_spi.c
@@ -60,7 +60,6 @@ static const struct spi_device_id st_gyro_id_table[] = {
 	{ LSM330DL_GYRO_DEV_NAME },
 	{ LSM330DLC_GYRO_DEV_NAME },
 	{ L3GD20_GYRO_DEV_NAME },
-	{ L3GD20H_GYRO_DEV_NAME },
 	{ L3G4IS_GYRO_DEV_NAME },
 	{ LSM330_GYRO_DEV_NAME },
 	{},
-- 
1.9.0

