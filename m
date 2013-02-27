Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760525Ab3B0Q4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 11:56:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760491Ab3B0Q4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 11:56:32 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] HID: multitouch: force BTN_STYLUS for pen devices
Date: Wed, 27 Feb 2013 17:55:27 +0100
Message-Id: <1361984127-912-8-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1361984127-912-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1361984127-912-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "tablet" udev rule relies on BTN_STYLUS to be triggered.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-multitouch.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index faeec95..499954c1 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -382,6 +382,8 @@ static int mt_pen_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 		}
 	}
 
+	/* force BTN_STYLUS to allow tablet matching in udev */
+	__set_bit(BTN_STYLUS, hi->input->keybit);
 	td->pen_report_id = field->report->id;
 
 	return 0;
-- 
1.8.1.2

