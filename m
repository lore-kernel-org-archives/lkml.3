Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab3LBTVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:21:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39764 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029Ab3LBTTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:19:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 3.12 207/212] HID: roccat: add new device return value
Date: Mon,  2 Dec 2013 11:16:38 -0800
Message-Id: <20131202191312.471773914@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Achatz <erazor_de@users.sourceforge.net>

commit 14fc4290df2fb94a28f39dab9ed32feaa5527bef upstream.

Ryos uses a new return value for critical errors, others have been
confirmed.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-roccat-common.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/hid/hid-roccat-common.c
+++ b/drivers/hid/hid-roccat-common.c
@@ -65,10 +65,11 @@ int roccat_common2_send(struct usb_devic
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
@@ -88,13 +89,12 @@ static int roccat_common2_receive_contro
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


