Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbaKJMox (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 07:44:53 -0500
Received: from mga09.intel.com ([134.134.136.24]:10698 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814AbaKJMob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 07:44:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,352,1413270000"; 
   d="scan'208";a="634415514"
From: Daniel Baluta <daniel.baluta@intel.com>
To: jic23@kernel.org, knaack.h@gmx.de
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        irina.tirdea@intel.com, daniel.baluta@inte.com
Subject: [PATCH v4 5/7] iio: core: Introduce IIO_CHAN_INFO_CALIBHEIGHT
Date: Mon, 10 Nov 2014 14:45:33 +0200
Message-Id: <1415623535-24337-6-git-send-email-daniel.baluta@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415623535-24337-1-git-send-email-daniel.baluta@intel.com>
References: <1415623535-24337-1-git-send-email-daniel.baluta@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Irina Tirdea <irina.tirdea@intel.com>

Some devices need the height of the user to compute various
parameters. One of this devices is Freescale's MMA9553L
(http://www.freescale.com/files/sensors/doc/ref_manual/MMA9553LSWRM.pdf)
that needs the height of the user to compute the stride length which
is used further to determine distance, speed and activity type.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
---
 Documentation/ABI/testing/sysfs-bus-iio | 8 ++++++++
 drivers/iio/industrialio-core.c         | 1 +
 include/linux/iio/iio.h                 | 1 +
 3 files changed, 10 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
index c60b0a1..4a9e29a 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio
+++ b/Documentation/ABI/testing/sysfs-bus-iio
@@ -323,6 +323,14 @@ Description:
 		production inaccuracies).  If shared across all channels,
 		<type>_calibscale is used.
 
+What:		/sys/bus/iio/devices/iio:deviceX/in_steps_calibheight
+KernelVersion:	3.19
+Contact:	linux-iio@vger.kernel.org
+Description:
+		Height of the user (in centimeters) used by some pedometers
+		to compute the stride length, distance, speed and activity
+		type.
+
 What:		/sys/bus/iio/devices/iio:deviceX/in_accel_scale_available
 What:		/sys/.../iio:deviceX/in_voltageX_scale_available
 What:		/sys/.../iio:deviceX/in_voltage-voltage_scale_available
diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index 1e060f3..45bb3a4 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -120,6 +120,7 @@ static const char * const iio_chan_info_postfix[] = {
 	[IIO_CHAN_INFO_HYSTERESIS] = "hysteresis",
 	[IIO_CHAN_INFO_INT_TIME] = "integration_time",
 	[IIO_CHAN_INFO_ENABLE] = "en",
+	[IIO_CHAN_INFO_CALIBHEIGHT] = "calibheight",
 };
 
 /**
diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
index f45a400..878d861 100644
--- a/include/linux/iio/iio.h
+++ b/include/linux/iio/iio.h
@@ -39,6 +39,7 @@ enum iio_chan_info_enum {
 	IIO_CHAN_INFO_HYSTERESIS,
 	IIO_CHAN_INFO_INT_TIME,
 	IIO_CHAN_INFO_ENABLE,
+	IIO_CHAN_INFO_CALIBHEIGHT,
 };
 
 enum iio_shared_by {
-- 
1.9.1

