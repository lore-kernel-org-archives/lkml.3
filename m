Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957AbaGIUgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 16:36:25 -0400
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:46485 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750915AbaGIUgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 16:36:23 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: m.chehab@samsung.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: em28xx - remove reset_resume interface
Date: Wed,  9 Jul 2014 14:36:03 -0600
Message-Id: <1404938163-27461-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

em28xx uses resume interface as its reset_resume interface.
If usb device is reset during suspend, reset_resume doesn't
do the necessary initialization which leads to resume failure.
Many systems don't maintain do not maintain suspend current to
the USB host controllers during hibernation. Remove reset_resume
to allow disconnect to be called followed by device restore
sequence.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 15ad470..c53fa77 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3522,7 +3522,6 @@ static struct usb_driver em28xx_usb_driver = {
 	.disconnect = em28xx_usb_disconnect,
 	.suspend = em28xx_usb_suspend,
 	.resume = em28xx_usb_resume,
-	.reset_resume = em28xx_usb_resume,
 	.id_table = em28xx_id_table,
 };
 
-- 
1.7.10.4

