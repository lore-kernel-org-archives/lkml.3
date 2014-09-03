Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936243AbaICXew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:34:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45524 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933154AbaICWIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:08:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Oliver Neukum <oneukum@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 3.14 07/88] USB: devio: fix issue with log flooding
Date: Wed,  3 Sep 2014 15:04:41 -0700
Message-Id: <20140903220516.175705008@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220515.958924632@linuxfoundation.org>
References: <20140903220515.958924632@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.de>

commit d310d05f1225d1f6f2bf505255fdf593bfbb3051 upstream.

usbfs allows user space to pass down an URB which sets URB_SHORT_NOT_OK
for output URBs. That causes usbcore to log messages without limit
for a nonsensical disallowed combination. The fix is to silently drop
the attribute in usbfs.
The problem is reported to exist since 3.14
https://www.virtualbox.org/ticket/13085

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/devio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1411,7 +1411,7 @@ static int proc_do_submiturb(struct dev_
 	u = (is_in ? URB_DIR_IN : URB_DIR_OUT);
 	if (uurb->flags & USBDEVFS_URB_ISO_ASAP)
 		u |= URB_ISO_ASAP;
-	if (uurb->flags & USBDEVFS_URB_SHORT_NOT_OK)
+	if (uurb->flags & USBDEVFS_URB_SHORT_NOT_OK && is_in)
 		u |= URB_SHORT_NOT_OK;
 	if (uurb->flags & USBDEVFS_URB_NO_FSBR)
 		u |= URB_NO_FSBR;


