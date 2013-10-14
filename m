Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448Ab3JNTrW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 15:47:22 -0400
Received: from libra.uberspace.de ([95.143.172.171]:59394 "HELO
	libra.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755590Ab3JNTrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 15:47:03 -0400
From: Matthias Beyer <mail@beyermatthias.de>
To: gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthias Beyer <mail@beyermatthias.de>
Subject: [PATCH v2 5/5] drivers: usb: core: devio.c: Put arguments on new line
Date: Mon, 14 Oct 2013 21:46:40 +0200
Message-Id: <1381780000-23327-6-git-send-email-mail@beyermatthias.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381780000-23327-1-git-send-email-mail@beyermatthias.de>
References: <20131014181214.GB6023@kroah.com>
 <1381780000-23327-1-git-send-email-mail@beyermatthias.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To fit the 80-cols convention, this patch moves the arguments (the
second and third one) for driver->unlocked_ioctl() onto a new line.

Signed-off-by: Matthias Beyer <mail@beyermatthias.de>
---
 drivers/usb/core/devio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 9761a27..0387948 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1870,7 +1870,8 @@ static int proc_ioctl(struct dev_state *ps, struct usbdevfs_ioctl *ctl)
 			if (driver == NULL || driver->unlocked_ioctl == NULL) {
 				retval = -ENOTTY;
 			} else {
-				retval = driver->unlocked_ioctl(intf, ctl->ioctl_code, buf);
+				retval = driver->unlocked_ioctl(intf,
+						ctl->ioctl_code, buf);
 				if (retval == -ENOIOCTLCMD)
 					retval = -ENOTTY;
 			}
-- 
1.8.4

