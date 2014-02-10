Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207AbaBJR7I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:59:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410AbaBJR7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:59:04 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, David Herrmann <dh.herrmann@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 01/14] HID: uHID: remove duplicated code
Date: Mon, 10 Feb 2014 12:58:46 -0500
Message-Id: <1392055139-19631-2-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1392055139-19631-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1392055139-19631-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uhid_hid_output_report() can be implemented through a simple call
to uhid_hid_output_raw().

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/uhid.c | 22 +---------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

diff --git a/drivers/hid/uhid.c b/drivers/hid/uhid.c
index 12439e1..b6de903 100644
--- a/drivers/hid/uhid.c
+++ b/drivers/hid/uhid.c
@@ -247,27 +247,7 @@ static int uhid_hid_output_raw(struct hid_device *hid, __u8 *buf, size_t count,
 static int uhid_hid_output_report(struct hid_device *hid, __u8 *buf,
 				  size_t count)
 {
-	struct uhid_device *uhid = hid->driver_data;
-	unsigned long flags;
-	struct uhid_event *ev;
-
-	if (count < 1 || count > UHID_DATA_MAX)
-		return -EINVAL;
-
-	ev = kzalloc(sizeof(*ev), GFP_KERNEL);
-	if (!ev)
-		return -ENOMEM;
-
-	ev->type = UHID_OUTPUT;
-	ev->u.output.size = count;
-	ev->u.output.rtype = UHID_OUTPUT_REPORT;
-	memcpy(ev->u.output.data, buf, count);
-
-	spin_lock_irqsave(&uhid->qlock, flags);
-	uhid_queue(uhid, ev);
-	spin_unlock_irqrestore(&uhid->qlock, flags);
-
-	return count;
+	return uhid_hid_output_raw(hid, buf, count, HID_OUTPUT_REPORT);
 }
 
 static struct hid_ll_driver uhid_hid_driver = {
-- 
1.8.3.1

