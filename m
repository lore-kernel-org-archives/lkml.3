Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161797Ab3LFNDj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:03:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44410 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161780Ab3LFNDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:03:35 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stefan Achatz <erazor_de@users.sourceforge.net>,
        Jiri Kosina <jkosina@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 181/272] HID: roccat: add new device return value
Date: Fri,  6 Dec 2013 12:57:50 +0000
Message-Id: <1386334761-25517-182-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Achatz <erazor_de@users.sourceforge.net>

commit 14fc4290df2fb94a28f39dab9ed32feaa5527bef upstream.

Ryos uses a new return value for critical errors, others have been
confirmed.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hid/hid-roccat-common.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

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
1.8.3.2

