Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752836AbaLSWa1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 17:30:27 -0500
Received: from mga14.intel.com ([192.55.52.115]:21661 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752719AbaLSWaY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 17:30:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,609,1413270000"; 
   d="scan'208";a="650701997"
From: Irina Tirdea <irina.tirdea@intel.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Vlad Dogaru <vlad.dogaru@intel.com>,
        Daniel Baluta <daniel.baluta@intel.com>,
        Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH 5/8] iio: core: Introduce IIO_CHAN_INFO_CALIBGENDER
Date: Sat, 20 Dec 2014 00:57:56 +0200
Message-Id: <1419029879-12024-6-git-send-email-irina.tirdea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1419029879-12024-1-git-send-email-irina.tirdea@intel.com>
References: <1419029879-12024-1-git-send-email-irina.tirdea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some devices need the gender of the user to compute various
parameters. One of this devices is Freescale's MMA9553L
(http://www.freescale.com/files/sensors/doc/ref_manual/MMA9553LSWRM.pdf)
that needs the gender of the user to compute distance, speed and activity type.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 Documentation/ABI/testing/sysfs-bus-iio |    8 ++++++++
 drivers/iio/industrialio-core.c         |    1 +
 include/linux/iio/iio.h                 |    1 +
 3 files changed, 10 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
index e480175..3b68c2d 100644
--- a/Documentation/ABI/testing/sysfs-bus-iio
+++ b/Documentation/ABI/testing/sysfs-bus-iio
@@ -343,6 +343,14 @@ Description:
 		production inaccuracies).  If shared across all channels,
 		<type>_calibscale is used.
 
+What:		/sys/bus/iio/devices/iio:deviceX/in_steps_calibgender
+KernelVersion:	3.19
+Contact:	linux-iio@vger.kernel.org
+Description:
+		Gender of the user: 0 for female and 1 for male. It is needed
+		by some pedometers to compute the stride length, distance,
+		speed and activity type.
+
 What:		/sys/bus/iio/devices/iio:deviceX/in_steps_calibheight
 KernelVersion:	3.19
 Contact:	linux-iio@vger.kernel.org
diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index 4c435c8..93a39f9 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -125,6 +125,7 @@ static const char * const iio_chan_info_postfix[] = {
 	[IIO_CHAN_INFO_ENABLE] = "en",
 	[IIO_CHAN_INFO_CALIBHEIGHT] = "calibheight",
 	[IIO_CHAN_INFO_CALIBWEIGHT] = "calibweight",
+	[IIO_CHAN_INFO_CALIBGENDER] = "calibgender",
 };
 
 /**
diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
index 752a929..63dac0f 100644
--- a/include/linux/iio/iio.h
+++ b/include/linux/iio/iio.h
@@ -41,6 +41,7 @@ enum iio_chan_info_enum {
 	IIO_CHAN_INFO_ENABLE,
 	IIO_CHAN_INFO_CALIBHEIGHT,
 	IIO_CHAN_INFO_CALIBWEIGHT,
+	IIO_CHAN_INFO_CALIBGENDER,
 };
 
 enum iio_shared_by {
-- 
1.7.9.5

