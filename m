Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752227Ab3KJSif (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 13:38:35 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:43154 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab3KJSiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 13:38:02 -0500
From: Michal Nazarewicz <mpn@google.com>
To: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: go7007: fix use of uninitialised pointer
Date: Sun, 10 Nov 2013 19:37:57 +0100
Message-Id: <1384108677-23476-1-git-send-email-mpn@google.com>
X-Mailer: git-send-email 1.8.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

The go variable is declade without initialisation and invocation of
dev_dbg immediatelly tries to dereference it.
---
 drivers/staging/media/go7007/go7007-usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/go7007/go7007-usb.c b/drivers/staging/media/go7007/go7007-usb.c
index 58684da..457ab63 100644
--- a/drivers/staging/media/go7007/go7007-usb.c
+++ b/drivers/staging/media/go7007/go7007-usb.c
@@ -1057,7 +1057,7 @@ static int go7007_usb_probe(struct usb_interface *intf,
 	char *name;
 	int video_pipe, i, v_urb_len;
 
-	dev_dbg(go->dev, "probing new GO7007 USB board\n");
+	pr_debug("probing new GO7007 USB board\n");
 
 	switch (id->driver_info) {
 	case GO7007_BOARDID_MATRIX_II:
-- 
1.8.3.2

