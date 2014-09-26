Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbaIZK7R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:59:17 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:61610 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863AbaIZK6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 06:58:36 -0400
X-Google-Original-Sender: <johan@hovold.com>
From: Johan Hovold <johan@kernel.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5/6] HID: hid-sensor-hub: use mfd_add_hotplug_devices helper
Date: Fri, 26 Sep 2014 12:55:32 +0200
Message-Id: <1411728933-13351-6-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1411728933-13351-1-git-send-email-johan@kernel.org>
References: <1411728933-13351-1-git-send-email-johan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use mfd_add_hotplug_devices helper to register the subdevices.

Compile-only tested.

Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/hid/hid-sensor-hub.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hid-sensor-hub.c b/drivers/hid/hid-sensor-hub.c
index 2ac25760a9a9..fbe1a6d2aa53 100644
--- a/drivers/hid/hid-sensor-hub.c
+++ b/drivers/hid/hid-sensor-hub.c
@@ -641,9 +641,6 @@ static int sensor_hub_probe(struct hid_device *hdev,
 					goto err_stop_hw;
 			}
 			sd->hid_sensor_hub_client_devs[
-				sd->hid_sensor_client_cnt].id =
-							PLATFORM_DEVID_AUTO;
-			sd->hid_sensor_hub_client_devs[
 				sd->hid_sensor_client_cnt].name = name;
 			sd->hid_sensor_hub_client_devs[
 				sd->hid_sensor_client_cnt].platform_data =
@@ -659,8 +656,9 @@ static int sensor_hub_probe(struct hid_device *hdev,
 	if (last_hsdev)
 		last_hsdev->end_collection_index = i;
 
-	ret = mfd_add_devices(&hdev->dev, 0, sd->hid_sensor_hub_client_devs,
-		sd->hid_sensor_client_cnt, NULL, 0, NULL);
+	ret = mfd_add_hotplug_devices(&hdev->dev,
+			sd->hid_sensor_hub_client_devs,
+			sd->hid_sensor_client_cnt);
 	if (ret < 0)
 		goto err_stop_hw;
 
-- 
1.8.5.5

