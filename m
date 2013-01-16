Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379Ab3APNI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 08:08:28 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:53405 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757261Ab3APNI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 08:08:26 -0500
From: Volokh Konstantin <volokh84@gmail.com>
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, gregkh@linuxfoundation.org, volokh84@gmail.com,
        dhowells@redhat.com, rdunlap@xenotime.net, hans.verkuil@cisco.com,
        justinmattock@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] staging: media: go7007: i2c GPIO initialization Reset i2c stuff for GO7007_BOARDID_ADLINK_MPG24   need reset GPIO always when encoder initialize
Date: Wed, 16 Jan 2013 17:00:50 +0400
Message-Id: <1358341251-10087-3-git-send-email-volokh84@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1358341251-10087-1-git-send-email-volokh84@gmail.com>
References: <1358341251-10087-1-git-send-email-volokh84@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Volokh Konstantin <volokh84@gmail.com>
---
 drivers/staging/media/go7007/go7007-driver.c |    5 +++++
 drivers/staging/media/go7007/go7007-usb.c    |    3 ---
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/media/go7007/go7007-driver.c b/drivers/staging/media/go7007/go7007-driver.c
index a66e339..c0ea312 100644
--- a/drivers/staging/media/go7007/go7007-driver.c
+++ b/drivers/staging/media/go7007/go7007-driver.c
@@ -173,6 +173,11 @@ static int go7007_init_encoder(struct go7007 *go)
 		go7007_write_addr(go, 0x3c82, 0x0001);
 		go7007_write_addr(go, 0x3c80, 0x00fe);
 	}
+	if (go->board_id == GO7007_BOARDID_ADLINK_MPG24) {
+		/* set GPIO5 to be an output, currently low */
+		go7007_write_addr(go, 0x3c82, 0x0000);
+		go7007_write_addr(go, 0x3c80, 0x00df);
+	}
 	return 0;
 }
 
diff --git a/drivers/staging/media/go7007/go7007-usb.c b/drivers/staging/media/go7007/go7007-usb.c
index a6cad15..9dbf5ec 100644
--- a/drivers/staging/media/go7007/go7007-usb.c
+++ b/drivers/staging/media/go7007/go7007-usb.c
@@ -1110,9 +1110,6 @@ static int go7007_usb_probe(struct usb_interface *intf,
 			} else {
 				u16 channel;
 
-				/* set GPIO5 to be an output, currently low */
-				go7007_write_addr(go, 0x3c82, 0x0000);
-				go7007_write_addr(go, 0x3c80, 0x00df);
 				/* read channel number from GPIO[1:0] */
 				go7007_read_addr(go, 0x3c81, &channel);
 				channel &= 0x3;
-- 
1.7.7.6

