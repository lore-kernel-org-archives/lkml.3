Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428Ab3CYBcx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:32:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33917 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755888Ab3CYBPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:15:39 -0400
Message-Id: <20130325010532.412172554@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:06:46 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 082/104] USB: io_ti: fix get_icount for two port adapters
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 5492bf3d5655b4954164f69c02955a7fca267611 upstream.

Add missing get_icount field to two-port driver.

The two-port driver was not updated when switching to the new icount
interface in commit 0bca1b913aff ("tty: Convert the USB drivers to the
new icount interface").

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/io_ti.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -2796,6 +2796,7 @@ static struct usb_serial_driver edgeport
 	.set_termios		= edge_set_termios,
 	.tiocmget		= edge_tiocmget,
 	.tiocmset		= edge_tiocmset,
+	.get_icount		= edge_get_icount,
 	.write			= edge_write,
 	.write_room		= edge_write_room,
 	.chars_in_buffer	= edge_chars_in_buffer,


