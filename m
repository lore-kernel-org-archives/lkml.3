Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130AbaF3J0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 05:26:43 -0400
Received: from mga14.intel.com ([192.55.52.115]:30929 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752656AbaF3J0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 05:26:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,574,1400050800"; 
   d="scan'208";a="555179103"
From: Daniel Baluta <daniel.baluta@intel.com>
To: jic23@kernel.org
Cc: srinivas.pandruvada@linux.intel.com, archana.patni@linux.intel.com,
        subramony.sesha@intel.com, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, Daniel Baluta <daniel.baluta@intel.com>
Subject: [PATCH] iio: hid-sensors: make hid_sensor_get_reporting_interval static
Date: Mon, 30 Jun 2014 12:29:44 +0300
Message-Id: <1404120584-11795-1-git-send-email-daniel.baluta@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the following sparse warning:

  CHECK   drivers/iio/common/hid-sensors/hid-sensor-attributes.c
drivers/iio/common/hid-sensors/hid-sensor-attributes.c:346:5: warning:
symbol 'hid_sensor_get_reporting_interval' was not declared. Should it be static?

Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
---
 drivers/iio/common/hid-sensors/hid-sensor-attributes.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/common/hid-sensors/hid-sensor-attributes.c b/drivers/iio/common/hid-sensors/hid-sensor-attributes.c
index 403dd3d..8220df1 100644
--- a/drivers/iio/common/hid-sensors/hid-sensor-attributes.c
+++ b/drivers/iio/common/hid-sensors/hid-sensor-attributes.c
@@ -343,6 +343,7 @@ int hid_sensor_format_scale(u32 usage_id,
 }
 EXPORT_SYMBOL(hid_sensor_format_scale);
 
+static
 int hid_sensor_get_reporting_interval(struct hid_sensor_hub_device *hsdev,
 					u32 usage_id,
 					struct hid_sensor_common *st)
-- 
1.9.1

