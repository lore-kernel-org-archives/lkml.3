Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236Ab3FRMH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 08:07:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55949 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755754Ab3FRLoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:44:07 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 16/93] USB: iuu_phoenix: fix bulk-message timeout
Date: Tue, 18 Jun 2013 12:42:24 +0100
Message-Id: <1371555821-12820-17-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 6c13ff68a7ce01da7a51b44241a7aad8eaaedde7 upstream.

The bulk-message timeout is specified in milliseconds and should not
depend on HZ.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/iuu_phoenix.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/serial/iuu_phoenix.c b/drivers/usb/serial/iuu_phoenix.c
index 22b1eb5..3e7980a 100644
--- a/drivers/usb/serial/iuu_phoenix.c
+++ b/drivers/usb/serial/iuu_phoenix.c
@@ -308,7 +308,7 @@ static int bulk_immediate(struct usb_serial_port *port, u8 *buf, u8 count)
 	    usb_bulk_msg(serial->dev,
 			 usb_sndbulkpipe(serial->dev,
 					 port->bulk_out_endpointAddress), buf,
-			 count, &actual, HZ * 1);
+			 count, &actual, 1000);
 
 	if (status != IUU_OPERATION_OK)
 		dbg("%s - error = %2x", __func__, status);
@@ -328,7 +328,7 @@ static int read_immediate(struct usb_serial_port *port, u8 *buf, u8 count)
 	    usb_bulk_msg(serial->dev,
 			 usb_rcvbulkpipe(serial->dev,
 					 port->bulk_in_endpointAddress), buf,
-			 count, &actual, HZ * 1);
+			 count, &actual, 1000);
 
 	if (status != IUU_OPERATION_OK)
 		dbg("%s - error = %2x", __func__, status);
-- 
1.8.1.2

