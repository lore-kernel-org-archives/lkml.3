Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932934AbaCDUxU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:53:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41312 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780AbaCDUEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:04:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Denis Ciocca <denis.ciocca@st.com>,
        Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 3.13 136/172] iio:gyro: bug on L3GD20H gyroscope support
Date: Tue,  4 Mar 2014 12:03:40 -0800
Message-Id: <20140304200304.062644258@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis CIOCCA <denis.ciocca@st.com>

commit a0657716416f834ef7710a9044614d50a36c3bdc upstream.

The driver was not able to manage the sensor: during probe function
and wai check, the driver stops and writes: "device name and WhoAmI mismatch."
The correct value of L3GD20H wai is 0xd7 instead of 0xd4.
Dropped support for the sensor.

Signed-off-by: Denis Ciocca <denis.ciocca@st.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/gyro/Kconfig        |    2 +-
 drivers/iio/gyro/st_gyro.h      |    1 -
 drivers/iio/gyro/st_gyro_core.c |    9 ++++-----
 drivers/iio/gyro/st_gyro_i2c.c  |    1 -
 drivers/iio/gyro/st_gyro_spi.c  |    1 -
 5 files changed, 5 insertions(+), 9 deletions(-)

--- a/drivers/iio/gyro/Kconfig
+++ b/drivers/iio/gyro/Kconfig
@@ -70,7 +70,7 @@ config IIO_ST_GYRO_3AXIS
 	select IIO_TRIGGERED_BUFFER if (IIO_BUFFER)
 	help
 	  Say yes here to build support for STMicroelectronics gyroscopes:
-	  L3G4200D, LSM330DL, L3GD20, L3GD20H, LSM330DLC, L3G4IS, LSM330.
+	  L3G4200D, LSM330DL, L3GD20, LSM330DLC, L3G4IS, LSM330.
 
 	  This driver can also be built as a module. If so, these modules
 	  will be created:
--- a/drivers/iio/gyro/st_gyro.h
+++ b/drivers/iio/gyro/st_gyro.h
@@ -19,7 +19,6 @@
 #define LSM330DL_GYRO_DEV_NAME		"lsm330dl_gyro"
 #define LSM330DLC_GYRO_DEV_NAME		"lsm330dlc_gyro"
 #define L3GD20_GYRO_DEV_NAME		"l3gd20"
-#define L3GD20H_GYRO_DEV_NAME		"l3gd20h"
 #define L3G4IS_GYRO_DEV_NAME		"l3g4is_ui"
 #define LSM330_GYRO_DEV_NAME		"lsm330_gyro"
 
--- a/drivers/iio/gyro/st_gyro_core.c
+++ b/drivers/iio/gyro/st_gyro_core.c
@@ -167,11 +167,10 @@ static const struct st_sensors st_gyro_s
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
--- a/drivers/iio/gyro/st_gyro_i2c.c
+++ b/drivers/iio/gyro/st_gyro_i2c.c
@@ -55,7 +55,6 @@ static const struct i2c_device_id st_gyr
 	{ LSM330DL_GYRO_DEV_NAME },
 	{ LSM330DLC_GYRO_DEV_NAME },
 	{ L3GD20_GYRO_DEV_NAME },
-	{ L3GD20H_GYRO_DEV_NAME },
 	{ L3G4IS_GYRO_DEV_NAME },
 	{ LSM330_GYRO_DEV_NAME },
 	{},
--- a/drivers/iio/gyro/st_gyro_spi.c
+++ b/drivers/iio/gyro/st_gyro_spi.c
@@ -54,7 +54,6 @@ static const struct spi_device_id st_gyr
 	{ LSM330DL_GYRO_DEV_NAME },
 	{ LSM330DLC_GYRO_DEV_NAME },
 	{ L3GD20_GYRO_DEV_NAME },
-	{ L3GD20H_GYRO_DEV_NAME },
 	{ L3G4IS_GYRO_DEV_NAME },
 	{ LSM330_GYRO_DEV_NAME },
 	{},


