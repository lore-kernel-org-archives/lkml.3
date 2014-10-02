Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbaJBNjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 09:39:45 -0400
Received: from mga14.intel.com ([192.55.52.115]:3775 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803AbaJBNiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 09:38:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,638,1406617200"; 
   d="scan'208";a="599806646"
From: Daniel Baluta <daniel.baluta@intel.com>
To: jic23@kernel.org, linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: daniel.baluta@intel.com, irina.tirdea@intel.com
Subject: [RFC PATCH 5/8] iio: core: Introduce ENABLE channel info mask
Date: Thu,  2 Oct 2014 16:43:56 +0300
Message-Id: <1412257439-15683-6-git-send-email-daniel.baluta@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412257439-15683-1-git-send-email-daniel.baluta@intel.com>
References: <1412257439-15683-1-git-send-email-daniel.baluta@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Irina Tirdea <irina.tirdea@intel.com>

This change is needed for the step counter functionality of a pedometer.
The step counter needs to be enabled and then it will count the steps
in its hardware register. Whenever the applications need to check
the step count, they will read the step counter register.

Since the pedometer needs to be enabled once so that the hardware
can count and store the steps, we need a specific enable attribute.

For more information on the pedometer requirements for Android see
http://source.android.com/devices/sensors/composite_sensors.html#counter.

A device that has the pedometer functionality this interface needs to
support is Freescale's MMA9553L:
http://www.freescale.com/files/sensors/doc/ref_manual/MMA9553LSWRM.pdf

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 Documentation/ABI/testing/sysfs-bus-iio | 7 +++++++
 drivers/iio/industrialio-core.c         | 1 +
 include/linux/iio/iio.h                 | 1 +
 3 files changed, 9 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
index feacb45..c02785d 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio
+++ b/Documentation/ABI/testing/sysfs-bus-iio
@@ -949,6 +949,13 @@ Description:
 		and the relevant _type attributes to establish the data storage
 		format.
 
+What:		/sys/.../iio:deviceX/in_activity_enable
+KernelVersion:	3.17
+Contact:	linux-iio@vger.kernel.org
+Description:
+		Activates the step counter and all dependent features
+		(e.g.: walked distance, activity detection like running, walking, etc.).
+
 What:		/sys/.../iio:deviceX/in_activity_steps_raw
 KernelVersion:	3.17
 Contact:	linux-iio@vger.kernel.org
diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index 935a8a1..936df49 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -119,6 +119,7 @@ static const char * const iio_chan_info_postfix[] = {
 	[IIO_CHAN_INFO_HARDWAREGAIN] = "hardwaregain",
 	[IIO_CHAN_INFO_HYSTERESIS] = "hysteresis",
 	[IIO_CHAN_INFO_INT_TIME] = "integration_time",
+	[IIO_CHAN_INFO_ENABLE] = "enable",
 };
 
 /**
diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
index 15dc6bc..3d3f06f 100644
--- a/include/linux/iio/iio.h
+++ b/include/linux/iio/iio.h
@@ -37,6 +37,7 @@ enum iio_chan_info_enum {
 	IIO_CHAN_INFO_HARDWAREGAIN,
 	IIO_CHAN_INFO_HYSTERESIS,
 	IIO_CHAN_INFO_INT_TIME,
+	IIO_CHAN_INFO_ENABLE,
 };
 
 enum iio_shared_by {
-- 
1.9.1

