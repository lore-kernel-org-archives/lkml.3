Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbbAKNnS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 08:43:18 -0500
Received: from mail-yh0-f51.google.com ([209.85.213.51]:58197 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbbAKNnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 08:43:13 -0500
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Johan Hovold <johan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Jeremiah Mahler <jmmahler@gmail.com>
Subject: [PATCH v3 1/2] usb: serial: silence all non-critical read errors
Date: Sun, 11 Jan 2015 05:42:06 -0800
Message-Id: <1420983727-5167-2-git-send-email-jmmahler@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1420983727-5167-1-git-send-email-jmmahler@gmail.com>
References: <1419066698-2684-1-git-send-email-jmmahler@gmail.com>
 <1420983727-5167-1-git-send-email-jmmahler@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a USB serial device is unplugged while there is an active program
using the device it may spam the logs with -EPROTO (71) messages as it
attempts to retry.

Most serial usb drivers (metro-usb, pl2303, mos7840, ...) only output
these messages for debugging.  The generic driver treats these as
errors.

Change the default output for the generic serial driver from error to
debug to silence these non-critical errors.

Signed-off-by: Jeremiah Mahler <jmmahler@gmail.com>
---
 drivers/usb/serial/generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/serial/generic.c b/drivers/usb/serial/generic.c
index 1bd1922..2d7207b 100644
--- a/drivers/usb/serial/generic.c
+++ b/drivers/usb/serial/generic.c
@@ -373,7 +373,7 @@ void usb_serial_generic_read_bulk_callback(struct urb *urb)
 							__func__, urb->status);
 		return;
 	default:
-		dev_err(&port->dev, "%s - nonzero urb status: %d\n",
+		dev_dbg(&port->dev, "%s - nonzero urb status: %d\n",
 							__func__, urb->status);
 		goto resubmit;
 	}
-- 
2.1.4

