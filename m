Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbaLSWaM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 17:30:12 -0500
Received: from mga01.intel.com ([192.55.52.88]:23079 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752651AbaLSWaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 17:30:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,609,1413270000"; 
   d="scan'208";a="650701898"
From: Irina Tirdea <irina.tirdea@intel.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Vlad Dogaru <vlad.dogaru@intel.com>,
        Daniel Baluta <daniel.baluta@intel.com>,
        Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH 3/8] iio: core: Introduce SPEED channel type
Date: Sat, 20 Dec 2014 00:57:54 +0200
Message-Id: <1419029879-12024-4-git-send-email-irina.tirdea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1419029879-12024-1-git-send-email-irina.tirdea@intel.com>
References: <1419029879-12024-1-git-send-email-irina.tirdea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices export the current speed value of the user.

One of this devices is Freescale's MMA9553L
(http://www.freescale.com/files/sensors/doc/ref_manual/MMA9553LSWRM.pdf)
that computes the speed of the user based on the number of steps and
stride length.

Introduce a new channel type SPEED to export these values.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 Documentation/ABI/testing/sysfs-bus-iio |    9 +++++++++
 drivers/iio/industrialio-core.c         |    1 +
 include/linux/iio/types.h               |    1 +
 3 files changed, 11 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
index a5c1dcc..07acef7 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio
+++ b/Documentation/ABI/testing/sysfs-bus-iio
@@ -295,6 +295,7 @@ What:		/sys/bus/iio/devices/iio:deviceX/in_rot_from_north_true_tilt_comp_scale
 What:		/sys/bus/iio/devices/iio:deviceX/in_pressureY_scale
 What:		/sys/bus/iio/devices/iio:deviceX/in_pressure_scale
 What:		/sys/bus/iio/devices/iio:deviceX/in_humidityrelative_scale
+What:		/sys/bus/iio/devices/iio:deviceX/in_speed_scale
 KernelVersion:	2.6.35
 Contact:	linux-iio@vger.kernel.org
 Description:
@@ -1146,6 +1147,14 @@ Description:
 		present, output should be considered as processed with the
 		unit in milliamps.
 
+What:		/sys/.../iio:deviceX/in_speed_input
+What:		/sys/.../iio:deviceX/in_speed_raw
+KernelVersion:	3.19
+Contact:	linux-iio@vger.kernel.org
+Description:
+		This attribute is used to read the current speed value of the user.
+		Units after application of scale are m/s.
+
 What:		/sys/.../iio:deviceX/in_steps_en
 KernelVersion:	3.19
 Contact:	linux-iio@vger.kernel.org
diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index 4a10d31..5e50aca 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -74,6 +74,7 @@ static const char * const iio_chan_type_name_spec[] = {
 	[IIO_STEPS] = "steps",
 	[IIO_CALORIES] = "calories",
 	[IIO_DISTANCE] = "distance",
+	[IIO_SPEED] = "speed",
 };
 
 static const char * const iio_modifier_names[] = {
diff --git a/include/linux/iio/types.h b/include/linux/iio/types.h
index b98f751..c848f45 100644
--- a/include/linux/iio/types.h
+++ b/include/linux/iio/types.h
@@ -34,6 +34,7 @@ enum iio_chan_type {
 	IIO_STEPS,
 	IIO_CALORIES,
 	IIO_DISTANCE,
+	IIO_SPEED,
 };
 
 enum iio_modifier {
-- 
1.7.9.5

