Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbaJ1KT5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 06:19:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:60184 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338AbaJ1KTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 06:19:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,802,1406617200"; 
   d="scan'208";a="621979836"
From: Daniel Baluta <daniel.baluta@intel.com>
To: jic23@kernel.org, linux-iio@vger.kernel.org
Cc: daniel.baluta@intel.com, knaack.h@gmx.de, linux-kernel@vger.kernel.org,
        irina.tirdea@intel.com
Subject: [PATCH v3 5/7] iio: core: Introduce IIO_CHAN_INFO_CALIBHEIGHT
Date: Tue, 28 Oct 2014 12:19:29 +0200
Message-Id: <1414491571-11672-6-git-send-email-daniel.baluta@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414491571-11672-1-git-send-email-daniel.baluta@intel.com>
References: <1414491571-11672-1-git-send-email-daniel.baluta@intel.com>
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
index 337ed0c..61d6603 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio
+++ b/Documentation/ABI/testing/sysfs-bus-iio
@@ -320,6 +320,14 @@ Description:
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
index 3d3f06f..057d8ce7 100644
--- a/include/linux/iio/iio.h
+++ b/include/linux/iio/iio.h
@@ -38,6 +38,7 @@ enum iio_chan_info_enum {
 	IIO_CHAN_INFO_HYSTERESIS,
 	IIO_CHAN_INFO_INT_TIME,
 	IIO_CHAN_INFO_ENABLE,
+	IIO_CHAN_INFO_CALIBHEIGHT,
 };
 
 enum iio_shared_by {
-- 
1.9.1

