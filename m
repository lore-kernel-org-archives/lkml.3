Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861Ab3FDXB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:01:26 -0400
Received: from 1wt.eu ([62.212.114.60]:35675 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753590Ab3FDWnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:43:10 -0400
Message-Id: <20130604172134.746938018@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:23:17 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 107/184] USB: mos7840: fix urb leak at release
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 65a4cdbb170e4ec1a7fa0e94936d47e24a17b0e8 upstream.

Make sure control urb is freed at release.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/usb/serial/mos7840.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 61829b8..9c338ca 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -2636,6 +2636,7 @@ static void mos7840_release(struct usb_serial *serial)
 		mos7840_port = mos7840_get_port_private(serial->port[i]);
 		dbg("mos7840_port %d = %p", i, mos7840_port);
 		if (mos7840_port) {
+			usb_free_urb(mos7840_port->control_urb);
 			kfree(mos7840_port->ctrl_buf);
 			kfree(mos7840_port->dr);
 			kfree(mos7840_port);
-- 
1.7.12.2.21.g234cd45.dirty



