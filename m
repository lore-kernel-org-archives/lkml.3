Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933029AbaGOSqW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 14:46:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5115 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932946AbaGOSqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 14:46:05 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH v2 17/23] Input - wacom: register power device at the HID level
Date: Tue, 15 Jul 2014 14:45:40 -0400
Message-Id: <1405449946-11515-18-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1405449946-11515-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1405449946-11515-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the HID device as the parent for the power device when dealing with
a wireless receiver.
Removes one more usb dependency and does not break user space.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Reviewed-by: Jason Gerecke <killertofu@gmail.com>
Tested-by: Jason Gerecke <killertofu@gmail.com>
---

no changes in v2

 drivers/input/tablet/wacom_sys.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index 8065bac..b871059 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -966,12 +966,12 @@ static int wacom_initialize_battery(struct wacom *wacom)
 		wacom->battery.type = POWER_SUPPLY_TYPE_BATTERY;
 		wacom->battery.use_for_apm = 0;
 
-		error = power_supply_register(&wacom->usbdev->dev,
+		error = power_supply_register(&wacom->hdev->dev,
 					      &wacom->battery);
 
 		if (!error)
 			power_supply_powers(&wacom->battery,
-					    &wacom->usbdev->dev);
+					    &wacom->hdev->dev);
 	}
 
 	return error;
-- 
2.0.0

