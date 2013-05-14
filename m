Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840Ab3ENJF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 05:05:56 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:50238 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756429Ab3ENJFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 05:05:53 -0400
Message-ID: <1368522350.1350.98.camel@x61.thuisdomein>
Subject: [PATCH] iio: STMicroelectronics: remove three useless selects
From: Paul Bolle <pebolle@tiscali.nl>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 14 May 2013 11:05:50 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 May 2013 09:05:50.0688 (UTC) FILETIME=[3B0B2600:01CE5082]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers for STMicroelectronics accelerometers, gyroscopes, and
magnetometers were added in v3.9. They all have a (similar) select
statement in their Kconfig files for a non-existant Kconfig symbol.
These select statements can safely be removed.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Untested.

1) Perhaps it was intended (in development versions of these drivers) to
have separate buffer and core drivers. One hint is that in the buffer
related source files one can find the usual MODULE_* macros. Those
macros can also be found in the core source files. I do wonder what
happens at build time now these drivers have two copies of these macros.

 drivers/iio/accel/Kconfig        | 1 -
 drivers/iio/gyro/Kconfig         | 1 -
 drivers/iio/magnetometer/Kconfig | 1 -
 3 files changed, 3 deletions(-)

diff --git a/drivers/iio/accel/Kconfig b/drivers/iio/accel/Kconfig
index bb59496..719d83f 100644
--- a/drivers/iio/accel/Kconfig
+++ b/drivers/iio/accel/Kconfig
@@ -28,7 +28,6 @@ config IIO_ST_ACCEL_3AXIS
 	select IIO_ST_ACCEL_I2C_3AXIS if (I2C)
 	select IIO_ST_ACCEL_SPI_3AXIS if (SPI_MASTER)
 	select IIO_TRIGGERED_BUFFER if (IIO_BUFFER)
-	select IIO_ST_ACCEL_BUFFER if (IIO_TRIGGERED_BUFFER)
 	help
 	  Say yes here to build support for STMicroelectronics accelerometers:
 	  LSM303DLH, LSM303DLHC, LIS3DH, LSM330D, LSM330DL, LSM330DLC,
diff --git a/drivers/iio/gyro/Kconfig b/drivers/iio/gyro/Kconfig
index 6be4628..b8daf1b 100644
--- a/drivers/iio/gyro/Kconfig
+++ b/drivers/iio/gyro/Kconfig
@@ -47,7 +47,6 @@ config IIO_ST_GYRO_3AXIS
 	select IIO_ST_GYRO_I2C_3AXIS if (I2C)
 	select IIO_ST_GYRO_SPI_3AXIS if (SPI_MASTER)
 	select IIO_TRIGGERED_BUFFER if (IIO_BUFFER)
-	select IIO_ST_GYRO_BUFFER if (IIO_TRIGGERED_BUFFER)
 	help
 	  Say yes here to build support for STMicroelectronics gyroscopes:
 	  L3G4200D, LSM330DL, L3GD20, L3GD20H, LSM330DLC, L3G4IS, LSM330.
diff --git a/drivers/iio/magnetometer/Kconfig b/drivers/iio/magnetometer/Kconfig
index bd1cfb6..c332b0a 100644
--- a/drivers/iio/magnetometer/Kconfig
+++ b/drivers/iio/magnetometer/Kconfig
@@ -32,7 +32,6 @@ config IIO_ST_MAGN_3AXIS
 	select IIO_ST_MAGN_I2C_3AXIS if (I2C)
 	select IIO_ST_MAGN_SPI_3AXIS if (SPI_MASTER)
 	select IIO_TRIGGERED_BUFFER if (IIO_BUFFER)
-	select IIO_ST_MAGN_BUFFER if (IIO_TRIGGERED_BUFFER)
 	help
 	  Say yes here to build support for STMicroelectronics magnetometers:
 	  LSM303DLHC, LSM303DLM, LIS3MDL.
-- 
1.7.11.7

