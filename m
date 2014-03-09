Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752639AbaCIDxR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 22:53:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299AbaCIDxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 22:53:10 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, David Herrmann <dh.herrmann@gmail.com>,
        David Barksdale <dbarksdale@uplogix.com>, Antonio Ospite <ao2@ao2.it>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/4] HID: cp2112: remove the last hid_output_raw_report() call
Date: Sat,  8 Mar 2014 22:52:41 -0500
Message-Id: <1394337163-32478-3-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1394337163-32478-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1394337163-32478-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tests have shown that output reports use hid_hw_output_report().

Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
changes in v3:
- no changes

changes in v2:
- removed FIXME
- actually use the proper calls and do not guess

 drivers/hid/hid-cp2112.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-cp2112.c b/drivers/hid/hid-cp2112.c
index 3913eb9..56be85a 100644
--- a/drivers/hid/hid-cp2112.c
+++ b/drivers/hid/hid-cp2112.c
@@ -290,7 +290,12 @@ static int cp2112_hid_output(struct hid_device *hdev, u8 *data, size_t count,
 	if (!buf)
 		return -ENOMEM;
 
-	ret = hdev->hid_output_raw_report(hdev, buf, count, report_type);
+	if (report_type == HID_OUTPUT_REPORT)
+		ret = hid_hw_output_report(hdev, buf, count);
+	else
+		ret = hid_hw_raw_request(hdev, buf[0], buf, count, report_type,
+				HID_REQ_SET_REPORT);
+
 	kfree(buf);
 	return ret;
 }
-- 
1.8.5.3

