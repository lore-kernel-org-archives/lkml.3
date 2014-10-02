Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbaJBNkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 09:40:11 -0400
Received: from mga14.intel.com ([192.55.52.115]:3775 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753998AbaJBNiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 09:38:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,638,1406617200"; 
   d="scan'208";a="599806614"
From: Daniel Baluta <daniel.baluta@intel.com>
To: jic23@kernel.org, linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: daniel.baluta@intel.com, irina.tirdea@intel.com
Subject: [RFC PATCH 3/8] iio: core: Introduce new MOTION event
Date: Thu,  2 Oct 2014 16:43:54 +0300
Message-Id: <1412257439-15683-4-git-send-email-daniel.baluta@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412257439-15683-1-git-send-email-daniel.baluta@intel.com>
References: <1412257439-15683-1-git-send-email-daniel.baluta@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is to be used by drivers to signal detection of motion. We also
add some possible values for motion as IIO events modifiers:
	* running
	* jogging
	* walking
	* still

These values are supported by Frescale's MMA9553 sensor:

http://freescale.com/files/sensors/doc/ref_manual/MMA9553LSWRM.pdf

Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 Documentation/ABI/testing/sysfs-bus-iio | 7 +++++++
 drivers/iio/industrialio-core.c         | 4 ++++
 drivers/iio/industrialio-event.c        | 1 +
 include/linux/iio/types.h               | 7 ++++++-
 4 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
index d760b02..070346d 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio
+++ b/Documentation/ABI/testing/sysfs-bus-iio
@@ -808,6 +808,13 @@ Description:
 		number or direction is not specified, applies to all channels of
 		this type.
 
+What:		/sys/.../events/in_activity_motion_either_en
+KernelVersion:	3.17
+Contact:	linux-iio@vger.kernel.org
+Description:
+		Enables or disables motion detection. Each time motion is detected an
+		event of this type will be generated.
+
 What:		/sys/bus/iio/devices/iio:deviceX/trigger/current_trigger
 KernelVersion:	2.6.35
 Contact:	linux-iio@vger.kernel.org
diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index 67e8561..e453ef9 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -92,6 +92,10 @@ static const char * const iio_modifier_names[] = {
 	[IIO_MOD_NORTH_TRUE] = "from_north_true",
 	[IIO_MOD_NORTH_MAGN_TILT_COMP] = "from_north_magnetic_tilt_comp",
 	[IIO_MOD_NORTH_TRUE_TILT_COMP] = "from_north_true_tilt_comp",
+	[IIO_MOD_RUNNING] = "running",
+	[IIO_MOD_JOGGING] = "jogging",
+	[IIO_MOD_WALKING] = "walking",
+	[IIO_MOD_STILL] = "still",
 };
 
 /* relies on pairs of these shared then separate */
diff --git a/drivers/iio/industrialio-event.c b/drivers/iio/industrialio-event.c
index 0c1e37e..eca5af2 100644
--- a/drivers/iio/industrialio-event.c
+++ b/drivers/iio/industrialio-event.c
@@ -197,6 +197,7 @@ static const char * const iio_ev_type_text[] = {
 	[IIO_EV_TYPE_ROC] = "roc",
 	[IIO_EV_TYPE_THRESH_ADAPTIVE] = "thresh_adaptive",
 	[IIO_EV_TYPE_MAG_ADAPTIVE] = "mag_adaptive",
+	[IIO_EV_TYPE_MOTION] = "motion",
 };
 
 static const char * const iio_ev_dir_text[] = {
diff --git a/include/linux/iio/types.h b/include/linux/iio/types.h
index d58769a..003638d 100644
--- a/include/linux/iio/types.h
+++ b/include/linux/iio/types.h
@@ -60,7 +60,11 @@ enum iio_modifier {
 	IIO_MOD_NORTH_MAGN,
 	IIO_MOD_NORTH_TRUE,
 	IIO_MOD_NORTH_MAGN_TILT_COMP,
-	IIO_MOD_NORTH_TRUE_TILT_COMP
+	IIO_MOD_NORTH_TRUE_TILT_COMP,
+	IIO_MOD_RUNNING,
+	IIO_MOD_JOGGING,
+	IIO_MOD_WALKING,
+	IIO_MOD_STILL,
 };
 
 enum iio_event_type {
@@ -69,6 +73,7 @@ enum iio_event_type {
 	IIO_EV_TYPE_ROC,
 	IIO_EV_TYPE_THRESH_ADAPTIVE,
 	IIO_EV_TYPE_MAG_ADAPTIVE,
+	IIO_EV_TYPE_MOTION,
 };
 
 enum iio_event_info {
-- 
1.9.1

