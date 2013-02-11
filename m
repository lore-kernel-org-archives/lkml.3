Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757807Ab3BKPyL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 10:54:11 -0500
Received: from mga03.intel.com ([143.182.124.21]:29054 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757759Ab3BKPyJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 10:54:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,643,1355126400"; 
   d="scan'208";a="255467994"
From: "Pandruvada, Srinivas" <srinivas.pandruvada@intel.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: RE: [PATCH 3/3] HID: sensor-hub: don't limit the driver only to USB
 bus
Thread-Topic: [PATCH 3/3] HID: sensor-hub: don't limit the driver only to
 USB bus
Thread-Index: AQHOCELGlYIRQQMi4068siyCSnc0hJh0zhBQ
Date: Mon, 11 Feb 2013 15:54:05 +0000
Message-ID: <4FA419E87744DF4DAECD5BCE1214B7A91E00FB81@ORSMSX108.amr.corp.intel.com>
References: <1360578679-7029-1-git-send-email-mika.westerberg@linux.intel.com>
 <1360578679-7029-3-git-send-email-mika.westerberg@linux.intel.com>
In-Reply-To: <1360578679-7029-3-git-send-email-mika.westerberg@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So finally we can use HID sensor hub over I2C.
Did you try with any I2C sensor hub?

Thanks,
Srinivas


-----Original Message-----
From: Mika Westerberg [mailto:mika.westerberg@linux.intel.com] 
Sent: Monday, February 11, 2013 2:31 AM
To: linux-kernel@vger.kernel.org
Cc: Jiri Kosina; Benjamin Tissoires; linux-input@vger.kernel.org; Pandruvada, Srinivas; Mika Westerberg
Subject: [PATCH 3/3] HID: sensor-hub: don't limit the driver only to USB bus

We now have two transport mediums: USB and I2C, where sensor hubs can exists. So instead of constraining the driver to only these two we let it to match any HID bus as long as the group is HID_GROUP_SENSOR_HUB.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/hid/hid-sensor-hub.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-sensor-hub.c b/drivers/hid/hid-sensor-hub.c index 2643bce9..c01f10d 100644
--- a/drivers/hid/hid-sensor-hub.c
+++ b/drivers/hid/hid-sensor-hub.c
@@ -603,7 +603,8 @@ static void sensor_hub_remove(struct hid_device *hdev)  }
 
 static const struct hid_device_id sensor_hub_devices[] = {
-	{ HID_DEVICE(BUS_USB, HID_GROUP_SENSOR_HUB, HID_ANY_ID, HID_ANY_ID) },
+	{ HID_DEVICE(HID_BUS_ANY, HID_GROUP_SENSOR_HUB, HID_ANY_ID,
+		     HID_ANY_ID) },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, sensor_hub_devices);
--
1.7.10.4

