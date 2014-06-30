Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957AbaF3V0z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 17:26:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224AbaF3V0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 17:26:53 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Ping Cheng <pinglinux@gmail.com>, Jason Gerecke <killertofu@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxwacom-devel@lists.sourceforge.net
Subject: [PATCH 10/15] Input - wacom: use hid_info instead of plain dev_info
Date: Mon, 30 Jun 2014 17:26:21 -0400
Message-Id: <1404163586-29582-11-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1404163586-29582-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1404163586-29582-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes one more need of usb and intf.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/input/tablet/wacom_sys.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index 2313f1a..2208b4a 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -1101,12 +1101,11 @@ static void wacom_wireless_work(struct work_struct *work)
 	wacom_wac2->input = NULL;
 
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
@@ -1117,8 +1116,7 @@ static void wacom_wireless_work(struct work_struct *work)
 		}
 
 		if (!id->bus) {
-			dev_info(&wacom->intf->dev,
-				 "ignoring unknown PID.\n");
+			hid_info(wacom->hdev, "ignoring unknown PID.\n");
 			return;
 		}
 
-- 
2.0.0

