Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560Ab3JJVlz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 17:41:55 -0400
Received: from libra.uberspace.de ([95.143.172.171]:60138 "HELO
	libra.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757518Ab3JJVlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 17:41:53 -0400
From: Matthias Beyer <mail@beyermatthias.de>
To: gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthias Beyer <mail@beyermatthias.de>
Subject: [PATCH 6/6] drivers: usb: core: devio.c: Else should be on closing braces
Date: Thu, 10 Oct 2013 23:41:32 +0200
Message-Id: <1381441292-6145-7-git-send-email-mail@beyermatthias.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381441292-6145-1-git-send-email-mail@beyermatthias.de>
References: <1381441292-6145-1-git-send-email-mail@beyermatthias.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

moved else keyword of if-else construct to closing braces.

Signed-off-by: Matthias Beyer <mail@beyermatthias.de>
---
 drivers/usb/core/devio.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 215d882..adbdea3 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1840,11 +1840,9 @@ static int proc_ioctl(struct dev_state *ps, struct usbdevfs_ioctl *ctl)
 
 	if (ps->dev->state != USB_STATE_CONFIGURED) {
 		retval = -EHOSTUNREACH;
-	}
-	else if (!(intf = usb_ifnum_to_if(ps->dev, ctl->ifno))) {
+	} else if (!(intf = usb_ifnum_to_if(ps->dev, ctl->ifno))) {
 		retval = -EINVAL;
-	}
-	else {
+	} else {
 		switch (ctl->ioctl_code) {
 
 		/* disconnect kernel driver from interface */
-- 
1.8.4

