Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252Ab3J1RwK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 13:52:10 -0400
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:59996 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932067Ab3J1RwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 13:52:06 -0400
X-Greylist: Passed host: 88.66.243.220
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-15.arcor-online.net 22ACF1AB543
X-Greylist: Passed host: 88.66.243.220
X-Greylist: Passed host: 88.66.243.220
X-Greylist: Passed host: 88.66.243.220
X-Greylist: Passed host: 88.66.243.220
X-Greylist: Passed host: 88.66.243.220
Subject: [PATCH 1/3] HID: roccat: Added new device return value
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Stefan Achatz <erazor_de@users.sourceforge.net>,
        Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Oct 2013 18:52:03 +0100
Message-ID: <1382982723.2453.9.camel@neuromancer.tessier-ashpool>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ryos uses a new return value for critical errors, others have been
confirmed.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 drivers/hid/hid-roccat-common.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/hid/hid-roccat-common.c b/drivers/hid/hid-roccat-common.c
index 74f7040..e840899 100644
--- a/drivers/hid/hid-roccat-common.c
+++ b/drivers/hid/hid-roccat-common.c
@@ -65,10 +65,11 @@ int roccat_common2_send(struct usb_device *usb_dev, uint report_id,
 EXPORT_SYMBOL_GPL(roccat_common2_send);
 
 enum roccat_common2_control_states {
-	ROCCAT_COMMON_CONTROL_STATUS_OVERLOAD = 0,
+	ROCCAT_COMMON_CONTROL_STATUS_CRITICAL = 0,
 	ROCCAT_COMMON_CONTROL_STATUS_OK = 1,
 	ROCCAT_COMMON_CONTROL_STATUS_INVALID = 2,
-	ROCCAT_COMMON_CONTROL_STATUS_WAIT = 3,
+	ROCCAT_COMMON_CONTROL_STATUS_BUSY = 3,
+	ROCCAT_COMMON_CONTROL_STATUS_CRITICAL_NEW = 4,
 };
 
 static int roccat_common2_receive_control_status(struct usb_device *usb_dev)
@@ -88,13 +89,12 @@ static int roccat_common2_receive_control_status(struct usb_device *usb_dev)
 		switch (control.value) {
 		case ROCCAT_COMMON_CONTROL_STATUS_OK:
 			return 0;
-		case ROCCAT_COMMON_CONTROL_STATUS_WAIT:
+		case ROCCAT_COMMON_CONTROL_STATUS_BUSY:
 			msleep(500);
 			continue;
 		case ROCCAT_COMMON_CONTROL_STATUS_INVALID:
-
-		case ROCCAT_COMMON_CONTROL_STATUS_OVERLOAD:
-			/* seems to be critical - replug necessary */
+		case ROCCAT_COMMON_CONTROL_STATUS_CRITICAL:
+		case ROCCAT_COMMON_CONTROL_STATUS_CRITICAL_NEW:
 			return -EINVAL;
 		default:
 			dev_err(&usb_dev->dev,
-- 
1.7.3.4



