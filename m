Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454Ab3GLJBQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 05:01:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757361Ab3GLJBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 05:01:14 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] HID: logitech-dj: use inlined helpers hid_hw_open/close
Date: Fri, 12 Jul 2013 11:01:02 +0200
Message-Id: <1373619662-15353-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the inlined helpers hid_hw_open/close instead of direct calls to
->ll_driver->open() and ->ll_driver->close().

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-logitech-dj.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hid-logitech-dj.c b/drivers/hid/hid-logitech-dj.c
index 5207591a..db3192b 100644
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -756,10 +756,10 @@ static int logi_dj_probe(struct hid_device *hdev,
 	}
 
 	/* This is enabling the polling urb on the IN endpoint */
-	retval = hdev->ll_driver->open(hdev);
+	retval = hid_hw_open(hdev);
 	if (retval < 0) {
-		dev_err(&hdev->dev, "%s:hdev->ll_driver->open returned "
-			"error:%d\n", __func__, retval);
+		dev_err(&hdev->dev, "%s:hid_hw_open returned error:%d\n",
+			__func__, retval);
 		goto llopen_failed;
 	}
 
@@ -776,7 +776,7 @@ static int logi_dj_probe(struct hid_device *hdev,
 	return retval;
 
 logi_dj_recv_query_paired_devices_failed:
-	hdev->ll_driver->close(hdev);
+	hid_hw_close(hdev);
 
 llopen_failed:
 switch_to_dj_mode_fail:
@@ -818,7 +818,7 @@ static void logi_dj_remove(struct hid_device *hdev)
 
 	cancel_work_sync(&djrcv_dev->work);
 
-	hdev->ll_driver->close(hdev);
+	hid_hw_close(hdev);
 	hid_hw_stop(hdev);
 
 	/* I suppose that at this point the only context that can access
-- 
1.8.3.1

