Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965232Ab3CZPXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:23:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53965 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965215Ab3CZPXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:23:15 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 096/150] USB: io_ti: fix get_icount for two port adapters
Date: Tue, 26 Mar 2013 15:19:55 +0000
Message-Id: <1364311249-14454-97-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 5492bf3d5655b4954164f69c02955a7fca267611 upstream.

Add missing get_icount field to two-port driver.

The two-port driver was not updated when switching to the new icount
interface in commit 0bca1b913aff ("tty: Convert the USB drivers to the
new icount interface").

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/io_ti.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/io_ti.c b/drivers/usb/serial/io_ti.c
index ab49912..d81630d 100644
--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -2772,6 +2772,7 @@ static struct usb_serial_driver edgeport_2port_device = {
 	.set_termios		= edge_set_termios,
 	.tiocmget		= edge_tiocmget,
 	.tiocmset		= edge_tiocmset,
+	.get_icount		= edge_get_icount,
 	.write			= edge_write,
 	.write_room		= edge_write_room,
 	.chars_in_buffer	= edge_chars_in_buffer,
-- 
1.8.1.2

