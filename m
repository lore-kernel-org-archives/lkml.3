Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab3BKKaF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 05:30:05 -0500
Received: from mga02.intel.com ([134.134.136.20]:4855 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754953Ab3BKKaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 05:30:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,641,1355126400"; 
   d="scan'208";a="260983519"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input@vger.kernel.org, srinivas.pandruvada@intel.com,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 3/3] HID: sensor-hub: don't limit the driver only to USB bus
Date: Mon, 11 Feb 2013 12:31:19 +0200
Message-Id: <1360578679-7029-3-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1360578679-7029-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1360578679-7029-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We now have two transport mediums: USB and I2C, where sensor hubs can
exists. So instead of constraining the driver to only these two we let it
to match any HID bus as long as the group is HID_GROUP_SENSOR_HUB.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/hid/hid-sensor-hub.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-sensor-hub.c b/drivers/hid/hid-sensor-hub.c
index 2643bce9..c01f10d 100644
--- a/drivers/hid/hid-sensor-hub.c
+++ b/drivers/hid/hid-sensor-hub.c
@@ -603,7 +603,8 @@ static void sensor_hub_remove(struct hid_device *hdev)
 }
 
 static const struct hid_device_id sensor_hub_devices[] = {
-	{ HID_DEVICE(BUS_USB, HID_GROUP_SENSOR_HUB, HID_ANY_ID, HID_ANY_ID) },
+	{ HID_DEVICE(HID_BUS_ANY, HID_GROUP_SENSOR_HUB, HID_ANY_ID,
+		     HID_ANY_ID) },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, sensor_hub_devices);
-- 
1.7.10.4

