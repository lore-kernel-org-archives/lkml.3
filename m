Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbaFMUcX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 16:32:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61012 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753883AbaFMUcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 16:32:21 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Aristeu Rozanski <aris@redhat.com>, Ping Cheng <pinglinux@gmail.com>,
        Jason Gerecke <killertofu@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Revert "Input: wacom - testing result shows get_report is unnecessary."
Date: Fri, 13 Jun 2014 16:32:18 -0400
Message-Id: <1402691538-26392-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 1b2faaf7e219fc2905d75afcd4c815e5d39eda80.

The Intuos4 series presents a bug in which it hangs if it receives
a set feature command while switching to the enhanced mode.
This bug is triggered when plugging an Intuos 4 while having
a gnome user session up and running.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---

Hi Aris,

actually, you bisected the bug, so can I consider that I have your signed-off-by?

Cheers,
Benjamin

 drivers/input/tablet/wacom_sys.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/input/tablet/wacom_sys.c b/drivers/input/tablet/wacom_sys.c
index 7087b33..319a3ff 100644
--- a/drivers/input/tablet/wacom_sys.c
+++ b/drivers/input/tablet/wacom_sys.c
@@ -536,6 +536,9 @@ static int wacom_set_device_mode(struct usb_interface *intf, int report_id, int
 
 		error = wacom_set_report(intf, WAC_HID_FEATURE_REPORT,
 		                         report_id, rep_data, length, 1);
+		if (error >= 0)
+			error = wacom_get_report(intf, WAC_HID_FEATURE_REPORT,
+			                         report_id, rep_data, length, 1);
 	} while ((error < 0 || rep_data[1] != mode) && limit++ < WAC_MSG_RETRIES);
 
 	kfree(rep_data);
-- 
1.9.0

