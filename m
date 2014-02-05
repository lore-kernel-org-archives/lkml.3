Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932911AbaBEUeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:34:22 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48420 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073AbaBEUG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:06:59 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 144/213] USB: mos7840: fix urb leak at release
Date: Wed, 5 Feb 2014 15:01:39 -0500
Message-ID: <1391630568-49251-145-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <jhovold@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 65a4cdbb170e4ec1a7fa0e94936d47e24a17b0e8 upstream.

Make sure control urb is freed at release.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/usb/serial/mos7840.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 16f0548f5f3d..d891d44501f8 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -2632,6 +2632,7 @@ static void mos7840_release(struct usb_serial *serial)
 		mos7840_port = mos7840_get_port_private(serial->port[i]);
 		dbg("mos7840_port %d = %p", i, mos7840_port);
 		if (mos7840_port) {
+			usb_free_urb(mos7840_port->control_urb);
 			kfree(mos7840_port->ctrl_buf);
 			kfree(mos7840_port->dr);
 			kfree(mos7840_port);
-- 
1.8.5.2

