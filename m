Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389AbaGZMAA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 08:00:00 -0400
Received: from si-002-i47.relay.mailchannels.net ([184.154.112.221]:43843 "EHLO
	relay.mailchannels.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750732AbaGZL76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 07:59:58 -0400
X-Sender-Id: arvixe|x-authuser|przemo@firszt.eu
X-Sender-Id: arvixe|x-authuser|przemo@firszt.eu
X-MC-Relay: Good
X-MailChannels-SenderId: arvixe|x-authuser|przemo@firszt.eu
X-MailChannels-Auth-Id: arvixe
From: Przemo Firszt <przemo@firszt.eu>
To: benjamin.tissoires@redhat.com
Cc: dmitry.torokhov@gmail.com, jkosina@suse.cz, pinglinux@gmail.com,
        killertofu@gmail.com, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, Przemo Firszt <przemo@firszt.eu>
Subject: [PATCH 1/2] Input - Wacom: Fix transfer header problem
Date: Sat, 26 Jul 2014 12:59:28 +0100
Message-Id: <1406375969-4453-1-git-send-email-przemo@firszt.eu>
X-Mailer: git-send-email 1.9.3
X-AuthUser: przemo@firszt.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Header of transfer of image is different depending on connection type.
That patch should be probably merged with 462c52a8cbcc62c
Input - wacom: Check for bluetooth protocol while setting OLEDs

Signed-off-by: Przemo Firszt <przemo@firszt.eu>
---
 drivers/hid/wacom_sys.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
index 42f139f..51437e2 100644
--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -19,6 +19,7 @@
 
 #define WAC_CMD_LED_CONTROL	0x20
 #define WAC_CMD_ICON_START	0x21
+#define WAC_CMD_ICON_BT_XFER	0x26
 #define WAC_CMD_ICON_XFER	0x23
 #define WAC_CMD_RETRIES		10
 
@@ -550,7 +551,7 @@ static int wacom_led_putimage(struct wacom *wacom, int button_id,
 	if (retval < 0)
 		goto out;
 
-	buf[0] = WAC_CMD_ICON_XFER;
+	buf[0] = len == 256 ? WAC_CMD_ICON_BT_XFER : WAC_CMD_ICON_XFER;
 	buf[1] = button_id & 0x07;
 	for (i = 0; i < 4; i++) {
 		buf[2] = i;
-- 
1.9.3

