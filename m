Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190AbaICKGE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 06:06:04 -0400
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:57409 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932248AbaICJ5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:57:35 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Oliver Neukum <oneukum@suse.de>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 16/56] USB: devio: fix issue with log flooding
Date: Wed,  3 Sep 2014 11:26:35 +0200
Message-Id: <fd44aa85fdbd21b34311ca3d0a7ac5844f4ee1d4.1409735865.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
References: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
In-Reply-To: <cover.1409735865.git.jslaby@suse.cz>
References: <cover.1409735865.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oliver Neukum <oneukum@suse.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit d310d05f1225d1f6f2bf505255fdf593bfbb3051 upstream.

usbfs allows user space to pass down an URB which sets URB_SHORT_NOT_OK
for output URBs. That causes usbcore to log messages without limit
for a nonsensical disallowed combination. The fix is to silently drop
the attribute in usbfs.
The problem is reported to exist since 3.14
https://www.virtualbox.org/ticket/13085

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/core/devio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 71dc5d768fa5..31ffd8459456 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1413,7 +1413,7 @@ static int proc_do_submiturb(struct dev_state *ps, struct usbdevfs_urb *uurb,
 	u = (is_in ? URB_DIR_IN : URB_DIR_OUT);
 	if (uurb->flags & USBDEVFS_URB_ISO_ASAP)
 		u |= URB_ISO_ASAP;
-	if (uurb->flags & USBDEVFS_URB_SHORT_NOT_OK)
+	if (uurb->flags & USBDEVFS_URB_SHORT_NOT_OK && is_in)
 		u |= URB_SHORT_NOT_OK;
 	if (uurb->flags & USBDEVFS_URB_NO_FSBR)
 		u |= URB_NO_FSBR;
-- 
2.1.0

