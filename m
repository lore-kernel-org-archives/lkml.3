Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210AbaJIMeF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 08:34:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:25293 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755997AbaJIMdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 08:33:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,684,1406617200"; 
   d="scan'208";a="615765051"
From: Daniel Baluta <daniel.baluta@intel.com>
To: jic23@kernel.org
Cc: irina.tirdea@intel.com, daniel.baluta@intel.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 5/7] iio: core: Introduce HEIGHT channel type
Date: Thu,  9 Oct 2014 15:39:43 +0300
Message-Id: <1412858385-11954-6-git-send-email-daniel.baluta@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412858385-11954-1-git-send-email-daniel.baluta@intel.com>
References: <1412858385-11954-1-git-send-email-daniel.baluta@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Irina Tirdea <irina.tirdea@intel.com>

Some devices need the height of the user to compute various
parameters. One of this devices is Freescale's MMA9553L
(http://www.freescale.com/files/sensors/doc/ref_manual/MMA9553LSWRM.pdf)
that needs the height of the user to compute the stride length which
is used further to determine distance, speed and activity type.

Introduce a new channel type HEIGHT to export these values.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
---
 Documentation/ABI/testing/sysfs-bus-iio | 9 +++++++++
 drivers/iio/industrialio-core.c         | 1 +
 include/linux/iio/types.h               | 1 +
 3 files changed, 11 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
index 3557a69..fc027cb 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio
+++ b/Documentation/ABI/testing/sysfs-bus-iio
@@ -256,6 +256,7 @@ What:		/sys/bus/iio/devices/iio:deviceX/out_altvoltageY_scale
 What:		/sys/bus/iio/devices/iio:deviceX/in_accel_scale
 What:		/sys/bus/iio/devices/iio:deviceX/in_accel_peak_scale
 What:		/sys/bus/iio/devices/iio:deviceX/in_anglvel_scale
+What:		/sys/bus/iio/devices/iio:deviceX/in_height_scale
 What:		/sys/bus/iio/devices/iio:deviceX/in_magn_scale
 What:		/sys/bus/iio/devices/iio:deviceX/in_magn_x_scale
 What:		/sys/bus/iio/devices/iio:deviceX/in_magn_y_scale
@@ -1010,6 +1011,14 @@ Description:
 		For a list of available output power modes read
 		in_accel_power_mode_available.
 
+What:		/sys/.../iio:deviceX/in_height_input
+What:		/sys/.../iio:deviceX/in_height_raw
+KernelVersion:	3.17
+Contact:	linux-iio@vger.kernel.org
+Description:
+		This attribute is used to set and read the user's height.
+		Units after application of scale are centimeters.
+
 What:		/sys/bus/iio/devices/iio:deviceX/store_eeprom
 KernelVersion:	3.4.0
 Contact:	linux-iio@vger.kernel.org
diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index 1e060f3..f08b278 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -72,6 +72,7 @@ static const char * const iio_chan_type_name_spec[] = {
 	[IIO_HUMIDITYRELATIVE] = "humidityrelative",
 	[IIO_ACTIVITY] = "activity",
 	[IIO_STEPS] = "steps",
+	[IIO_HEIGHT] = "height",
 };
 
 static const char * const iio_modifier_names[] = {
diff --git a/include/linux/iio/types.h b/include/linux/iio/types.h
index af0b6e0..a23b2e7 100644
--- a/include/linux/iio/types.h
+++ b/include/linux/iio/types.h
@@ -32,6 +32,7 @@ enum iio_chan_type {
 	IIO_HUMIDITYRELATIVE,
 	IIO_ACTIVITY,
 	IIO_STEPS,
+	IIO_HEIGHT,
 };
 
 enum iio_modifier {
-- 
1.9.1

