Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014AbaGOSqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 14:46:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36123 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932952AbaGOSqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 14:46:05 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH v2 18/23] Input - wacom: use hid_info instead of plain dev_info
Date: Tue, 15 Jul 2014 14:45:41 -0400
Message-Id: <1405449946-11515-19-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1405449946-11515-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1405449946-11515-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes one more need of usb and intf.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Reviewed-by: Jason Gerecke <killertofu@gmail.com>
Tested-by: Jason Gerecke <killertofu@gmail.com>
---

no changes in v2

 drivers/input/tablet/wacom_sys.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index b871059..2c1d984 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -1104,12 +1104,11 @@ static void wacom_wireless_work(struct work_struct *work)
 	wacom_unregister_inputs(wacom2);
 
 	if (wacom_wac->pid == 0) {
-		dev_info(&wacom->intf->dev, "wireless tablet disconnected\n");
+		hid_info(wacom->hdev, "wireless tablet disconnected\n");
 	} else {
 		const struct hid_device_id *id = wacom_ids;
 
-		dev_info(&wacom->intf->dev,
-			 "wireless tablet connected with PID %x\n",
+		hid_info(wacom->hdev, "wireless tablet connected with PID %x\n",
 			 wacom_wac->pid);
 
 		while (id->bus) {
@@ -1120,8 +1119,7 @@ static void wacom_wireless_work(struct work_struct *work)
 		}
 
 		if (!id->bus) {
-			dev_info(&wacom->intf->dev,
-				 "ignoring unknown PID.\n");
+			hid_info(wacom->hdev, "ignoring unknown PID.\n");
 			return;
 		}
 
-- 
2.0.0

