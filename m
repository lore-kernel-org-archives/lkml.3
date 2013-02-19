Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758529Ab3BSJVM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 04:21:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:24617 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754892Ab3BSJVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 04:21:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,693,1355126400"; 
   d="scan'208";a="287560934"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Holler <holler@ahsoftware.de>, Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        linux-input@vger.kernel.org, srinivas.pandruvada@intel.com,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] HID: make sensor autodetection independent of underlying bus
Date: Tue, 19 Feb 2013 11:22:33 +0200
Message-Id: <1361265753-17541-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <51221AFD.1090108@ahsoftware.de>
References: <51221AFD.1090108@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of limiting HID sensors to USB and I2C busses we can just make
everything that has usage page of HID_UP_SENSOR to be included in
HID_GROUP_SENSOR_HUB group. This allows the sensor-hub to work over
bluetooth (and other transports) as well.

Reported-by: Alexander Holler <holler@ahsoftware.de>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/hid/hid-core.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index fe3a59e..f89e902 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -728,8 +728,7 @@ static int hid_scan_report(struct hid_device *hid)
 		} else if (page == HID_UP_SENSOR &&
 			item.type == HID_ITEM_TYPE_MAIN &&
 			item.tag == HID_MAIN_ITEM_TAG_BEGIN_COLLECTION &&
-			(item_udata(&item) & 0xff) == HID_COLLECTION_PHYSICAL &&
-			(hid->bus == BUS_USB || hid->bus == BUS_I2C))
+			(item_udata(&item) & 0xff) == HID_COLLECTION_PHYSICAL)
 			hid->group = HID_GROUP_SENSOR_HUB;
 	}
 
-- 
1.7.10.4

