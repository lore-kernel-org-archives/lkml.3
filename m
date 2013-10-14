Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445Ab3JNTrE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 15:47:04 -0400
Received: from libra.uberspace.de ([95.143.172.171]:59380 "HELO
	libra.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757276Ab3JNTq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 15:46:58 -0400
From: Matthias Beyer <mail@beyermatthias.de>
To: gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthias Beyer <mail@beyermatthias.de>
Subject: [PATCH v2 3/5] drivers: usb: core: devio.c: Braces around if-elseif-else
Date: Mon, 14 Oct 2013 21:46:38 +0200
Message-Id: <1381780000-23327-4-git-send-email-mail@beyermatthias.de>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381780000-23327-1-git-send-email-mail@beyermatthias.de>
References: <20131014181214.GB6023@kroah.com>
 <1381780000-23327-1-git-send-email-mail@beyermatthias.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch applies the rules for braces to the if-elseif-else statement
in proc_ioctl().

As the kernel styleguide says: If there is at least one multiline block
in a if-else branching, we should add braces around all blocks. This
includes braces around the switch-statement on the else branch, which
needs a reindent after adding the braces.

Signed-off-by: Matthias Beyer <mail@beyermatthias.de>
---
 drivers/usb/core/devio.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index d15aa51..dd8701b 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1222,7 +1222,7 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
 		return -ENOENT;
 
 	u = 0;
-	switch(uurb->type) {
+	switch (uurb->type) {
 	case USBDEVFS_URB_TYPE_CONTROL:
 		if (!usb_endpoint_xfer_control(&ep->desc))
 			return -EINVAL;
@@ -1838,11 +1838,12 @@ static int proc_ioctl(struct dev_state *ps, struct usbdevfs_ioctl *ctl)
 		return -ENODEV;
 	}
 
-	if (ps->dev->state != USB_STATE_CONFIGURED)
+	if (ps->dev->state != USB_STATE_CONFIGURED) {
 		retval = -EHOSTUNREACH;
-	else if (!(intf = usb_ifnum_to_if(ps->dev, ctl->ifno)))
+	} else if (!(intf = usb_ifnum_to_if(ps->dev, ctl->ifno))) {
 		retval = -EINVAL;
-	else switch (ctl->ioctl_code) {
+	} else {
+	switch (ctl->ioctl_code) {
 
 	/* disconnect kernel driver from interface */
 	case USBDEVFS_DISCONNECT:
@@ -1874,6 +1875,7 @@ static int proc_ioctl(struct dev_state *ps, struct usbdevfs_ioctl *ctl)
 				retval = -ENOTTY;
 		}
 	}
+	}
 
 	/* cleanup and return */
 	if (retval >= 0
-- 
1.8.4

