Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbaBJR7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:59:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29189 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410AbaBJR7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:59:09 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, David Herrmann <dh.herrmann@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 06/14] HID: usbhid: change return error of usbhid_output_report
Date: Mon, 10 Feb 2014 12:58:51 -0500
Message-Id: <1392055139-19631-7-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1392055139-19631-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1392055139-19631-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there is no urbout when sending a output report, ENOSYS (Function
not implemented) is a better error than EIO (I/O error).

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/usbhid/hid-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index b9a770f..0d1d875 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -922,7 +922,7 @@ static int usbhid_output_report(struct hid_device *hid, __u8 *buf, size_t count)
 	int actual_length, skipped_report_id = 0, ret;
 
 	if (!usbhid->urbout)
-		return -EIO;
+		return -ENOSYS;
 
 	if (buf[0] == 0x0) {
 		/* Don't send the Report ID */
-- 
1.8.3.1

