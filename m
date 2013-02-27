Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760622Ab3B0Q5l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 11:57:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:14774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760472Ab3B0Q4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 11:56:30 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] HID: multitouch: manually send sync event for pen input report
Date: Wed, 27 Feb 2013 17:55:25 +0100
Message-Id: <1361984127-912-6-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1361984127-912-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1361984127-912-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since hid-multitouch sets the quirk HID_QUIRK_NO_INPUT_SYNC, we need
to manually send SYN events for pen report too.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-multitouch.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 77ba751..d89f0eb 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -393,6 +393,9 @@ static int mt_pen_event(struct hid_device *hid, struct hid_field *field,
 
 static void mt_pen_report(struct hid_device *hid, struct hid_report *report)
 {
+	struct hid_field *field = report->field[0];
+
+	input_sync(field->hidinput->input);
 }
 
 static int mt_touch_input_mapping(struct hid_device *hdev, struct hid_input *hi,
-- 
1.8.1.2

