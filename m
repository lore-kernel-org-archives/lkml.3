Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422770Ab3CVRjg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 13:39:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422740Ab3CVRje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 13:39:34 -0400
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/7] HID: multitouch: change touch sensor detection in mt_input_configured()
Date: Fri, 22 Mar 2013 18:38:31 +0100
Message-Id: <1363973914-5661-5-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1363973914-5661-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1363973914-5661-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To implement different methods for pen and touch, the previous
implementation has to be reworked.

This detection of the input attached to the touch sensor is the same
than the one used in mt_report().

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-multitouch.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 611c88cb..6a934de 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -857,13 +857,10 @@ static void mt_post_parse(struct mt_device *td)
 
 static void mt_input_configured(struct hid_device *hdev, struct hid_input *hi)
 {
-	struct input_dev *input = hi->input;
-
-	/* Only initialize slots for MT input devices */
-	if (!test_bit(ABS_MT_POSITION_X, input->absbit))
-		return;
+	struct mt_device *td = hid_get_drvdata(hdev);
 
-	mt_touch_input_configured(hdev, hi);
+	if (hi->report->id == td->mt_report_id)
+		mt_touch_input_configured(hdev, hi);
 }
 
 static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
-- 
1.8.1.4

