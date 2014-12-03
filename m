Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229AbaLCNd2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 08:33:28 -0500
Received: from mga09.intel.com ([134.134.136.24]:53375 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbaLCNd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 08:33:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,507,1413270000"; 
   d="scan'208";a="647549701"
From: Daniel Baluta <daniel.baluta@intel.com>
To: jic23@kernel.org, pmeerw@pmeerw.net, srinivas.pandruvada@linux.intel.com,
        knaack.h@gmx.de
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        daniel.baluta@intel.com
Subject: [PATCH v4 0/6] Add support for KMX61 sensor
Date: Wed,  3 Dec 2014 15:31:47 +0200
Message-Id: <1417613513-28285-1-git-send-email-daniel.baluta@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset implements support for Kionix KMX61 6-axis accelerometer / 
magnetometer sensor.

In order to simplify things we now use two separate IIO devices for accel/
magn, as suggested by Lars and Jonathan here:

	http://marc.info/?l=linux-iio&m=141700672107973&w=2

Patch 1/6, 2/6, 3/6 are already applied for an older version in this commit:
d7d787d291 (iio: imu: Add support for Kionix KMX61 sensor)

Jonathan please remove them, when you'll apply this patchset.

Changes since v3:
	* refactored code to have one IIO device per sensor
	* fixed most of the comments from Hartmut reported on v3:
	  * http://marc.info/?l=linux-kernel&m=141687633527812&w=2
	* added support for PM events, data ready/any motion triggers

Daniel Baluta (6):
  iio: imu: Add support for Kionix KMX61 sensor
  iio: imu: kmx61: Add acpi support
  iio: imu: kmx61: Add PM runtime support
  iio: imu: kmx61: Add PM sleep support
  iio: imu: kmx61: Add support for data ready triggers
  iio: imu: kmx61: Add support for any motion trigger

 drivers/iio/imu/Kconfig  |   11 +
 drivers/iio/imu/Makefile |    2 +
 drivers/iio/imu/kmx61.c  | 1601 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 1614 insertions(+)
 create mode 100644 drivers/iio/imu/kmx61.c

-- 
1.9.1

