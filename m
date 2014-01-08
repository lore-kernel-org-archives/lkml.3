Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932368AbaAHWUC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 17:20:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757601AbaAHWTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 17:19:46 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Andrew de los Reyes <adlr@chromium.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] HID: core: do not scan reports if the group is already set
Date: Wed,  8 Jan 2014 17:18:46 -0500
Message-Id: <1389219529-29671-3-git-send-email-benjamin.tissoires@redhat.com>
In-Reply-To: <1389219529-29671-1-git-send-email-benjamin.tissoires@redhat.com>
References: <1389219529-29671-1-git-send-email-benjamin.tissoires@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Tisssoires <benjamin.tissoires@redhat.com>

This allows the transport layer (I have in mind hid-logitech-dj and uhid)
to set the group before it is added to the hid bus. This way, it can
bypass the hid_scan_report() call, and choose in advance which driver
will handle the newly created hid device.

Signed-off-by: Benjamin Tisssoires <benjamin.tissoires@redhat.com>
---
 drivers/hid/hid-core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index a5a8c6a..200118a 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2438,7 +2438,8 @@ int hid_add_device(struct hid_device *hdev)
 	 * Scan generic devices for group information
 	 */
 	if (hid_ignore_special_drivers ||
-	    !hid_match_id(hdev, hid_have_special_driver)) {
+	    (!hdev->group &&
+	     !hid_match_id(hdev, hid_have_special_driver))) {
 		ret = hid_scan_report(hdev);
 		if (ret)
 			hid_warn(hdev, "bad device descriptor (%d)\n", ret);
-- 
1.8.4.2

