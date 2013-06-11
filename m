Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab3FKUCv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:02:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41589 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756034Ab3FKUCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:02:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 03/21] USB: iuu_phoenix: fix bulk-message timeout
Date: Tue, 11 Jun 2013 13:02:57 -0700
Message-Id: <20130611195520.423382550@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611195520.003233586@linuxfoundation.org>
References: <20130611195520.003233586@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 6c13ff68a7ce01da7a51b44241a7aad8eaaedde7 upstream.

The bulk-message timeout is specified in milliseconds and should not
depend on HZ.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/iuu_phoenix.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/serial/iuu_phoenix.c
+++ b/drivers/usb/serial/iuu_phoenix.c
@@ -327,7 +327,7 @@ static int bulk_immediate(struct usb_ser
 	    usb_bulk_msg(serial->dev,
 			 usb_sndbulkpipe(serial->dev,
 					 port->bulk_out_endpointAddress), buf,
-			 count, &actual, HZ * 1);
+			 count, &actual, 1000);
 
 	if (status != IUU_OPERATION_OK)
 		dbg("%s - error = %2x", __func__, status);
@@ -350,7 +350,7 @@ static int read_immediate(struct usb_ser
 	    usb_bulk_msg(serial->dev,
 			 usb_rcvbulkpipe(serial->dev,
 					 port->bulk_in_endpointAddress), buf,
-			 count, &actual, HZ * 1);
+			 count, &actual, 1000);
 
 	if (status != IUU_OPERATION_OK)
 		dbg("%s - error = %2x", __func__, status);


