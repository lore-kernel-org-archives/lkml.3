Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425Ab3FKUbB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:31:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41689 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756287Ab3FKUDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:03:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 09/32] USB: keyspan: fix bogus array index
Date: Tue, 11 Jun 2013 13:03:08 -0700
Message-Id: <20130611200127.250352805@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611200126.214442788@linuxfoundation.org>
References: <20130611200126.214442788@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit a07088098a650267b2eda689538133a324b9523f upstream.

The outcont_endpoints array was indexed using the port minor number
(which can be greater than the array size) rather than the device port
number.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/keyspan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -1705,7 +1705,7 @@ static int keyspan_usa26_send_setup(stru
 	d_details = s_priv->device_details;
 	device_port = port->number - port->serial->minor;
 
-	outcont_urb = d_details->outcont_endpoints[port->number];
+	outcont_urb = d_details->outcont_endpoints[device_port];
 	this_urb = p_priv->outcont_urb;
 
 	dbg("%s - endpoint %d", __func__, usb_pipeendpoint(this_urb->pipe));


