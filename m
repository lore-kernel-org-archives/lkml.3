Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbaBBEvj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 23:51:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1692 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438AbaBBEus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 23:50:48 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, David Herrmann <dh.herrmann@gmail.com>,
        Frank Praznik <frank.praznik@oh.rr.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 06/11] HID: remove hidinput_input_event handler
Date: Sat,  1 Feb 2014 23:50:25 -0500
Message-Id: <1391316630-29541-7-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1391316630-29541-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1391316630-29541-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the different transport drivers use now the generic event handling
in hid-input. We can remove the handler definitively now.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-input.c | 4 +---
 include/linux/hid.h     | 4 ----
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index a713e62..594722d 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -1263,9 +1263,7 @@ static struct hid_input *hidinput_allocate(struct hid_device *hid)
 	}
 
 	input_set_drvdata(input_dev, hid);
-	if (hid->ll_driver->hidinput_input_event)
-		input_dev->event = hid->ll_driver->hidinput_input_event;
-	else if (hid->ll_driver->request || hid->hid_output_raw_report)
+	if (hid->ll_driver->request || hid->hid_output_raw_report)
 		input_dev->event = hidinput_input_event;
 	input_dev->open = hidinput_open;
 	input_dev->close = hidinput_close;
diff --git a/include/linux/hid.h b/include/linux/hid.h
index dddcad0..38c307b 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -675,7 +675,6 @@ struct hid_driver {
  * @stop: called on remove
  * @open: called by input layer on open
  * @close: called by input layer on close
- * @hidinput_input_event: event input event (e.g. ff or leds)
  * @parse: this method is called only once to parse the device data,
  *	   shouldn't allocate anything to not leak memory
  * @request: send report request to device (e.g. feature report)
@@ -693,9 +692,6 @@ struct hid_ll_driver {
 
 	int (*power)(struct hid_device *hdev, int level);
 
-	int (*hidinput_input_event) (struct input_dev *idev, unsigned int type,
-			unsigned int code, int value);
-
 	int (*parse)(struct hid_device *hdev);
 
 	void (*request)(struct hid_device *hdev,
-- 
1.8.3.1

