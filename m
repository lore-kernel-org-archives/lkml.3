Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776AbaLSWaB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 17:30:01 -0500
Received: from mga09.intel.com ([134.134.136.24]:39363 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752747AbaLSW37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 17:29:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,609,1413270000"; 
   d="scan'208";a="650701757"
From: Irina Tirdea <irina.tirdea@intel.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Vlad Dogaru <vlad.dogaru@intel.com>,
        Daniel Baluta <daniel.baluta@intel.com>,
        Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH 1/8] iio: core: Introduce CALORIES channel type
Date: Sat, 20 Dec 2014 00:57:52 +0200
Message-Id: <1419029879-12024-2-git-send-email-irina.tirdea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1419029879-12024-1-git-send-email-irina.tirdea@intel.com>
References: <1419029879-12024-1-git-send-email-irina.tirdea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices compute the number of calories that the user has
burnt since the last reset.

One of this devices is Freescale's MMA9553L
(http://www.freescale.com/files/sensors/doc/ref_manual/MMA9553LSWRM.pdf)
that computes the number of calories based on weight and step rate.

Introduce a new channel type CALORIES to export these values.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 Documentation/ABI/testing/sysfs-bus-iio |    9 +++++++++
 drivers/iio/industrialio-core.c         |    1 +
 include/linux/iio/types.h               |    1 +
 3 files changed, 11 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
index df5e69e..bb9342b 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio
+++ b/Documentation/ABI/testing/sysfs-bus-iio
@@ -282,6 +282,7 @@ What:		/sys/bus/iio/devices/iio:deviceX/in_current_scale
 What:		/sys/bus/iio/devices/iio:deviceX/in_accel_scale
 What:		/sys/bus/iio/devices/iio:deviceX/in_accel_peak_scale
 What:		/sys/bus/iio/devices/iio:deviceX/in_anglvel_scale
+What:		/sys/bus/iio/devices/iio:deviceX/in_calories_scale
 What:		/sys/bus/iio/devices/iio:deviceX/in_magn_scale
 What:		/sys/bus/iio/devices/iio:deviceX/in_magn_x_scale
 What:		/sys/bus/iio/devices/iio:deviceX/in_magn_y_scale
@@ -1049,6 +1050,14 @@ Description:
 		For a list of available output power modes read
 		in_accel_power_mode_available.
 
+What:		/sys/.../iio:deviceX/in_calories_input
+What:		/sys/.../iio:deviceX/in_calories_raw
+KernelVersion:	3.17
+Contact:	linux-iio@vger.kernel.org
+Description:
+		This attribute is used to read the number of calories burned since the last
+		reset. Units after application of scale are Joules.
+
 What:		/sys/bus/iio/devices/iio:deviceX/store_eeprom
 KernelVersion:	3.4.0
 Contact:	linux-iio@vger.kernel.org
diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index ee442ee..5d95e84 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -72,6 +72,7 @@ static const char * const iio_chan_type_name_spec[] = {
 	[IIO_HUMIDITYRELATIVE] = "humidityrelative",
 	[IIO_ACTIVITY] = "activity",
 	[IIO_STEPS] = "steps",
+	[IIO_CALORIES] = "calories",
 };
 
 static const char * const iio_modifier_names[] = {
diff --git a/include/linux/iio/types.h b/include/linux/iio/types.h
index 904dcbb..d2fe930 100644
--- a/include/linux/iio/types.h
+++ b/include/linux/iio/types.h
@@ -32,6 +32,7 @@ enum iio_chan_type {
 	IIO_HUMIDITYRELATIVE,
 	IIO_ACTIVITY,
 	IIO_STEPS,
+	IIO_CALORIES,
 };
 
 enum iio_modifier {
-- 
1.7.9.5

