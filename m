Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431Ab3FRMFo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 08:05:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55980 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175Ab3FRLoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:44:13 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 22/93] USB: keyspan: fix bogus array index
Date: Tue, 18 Jun 2013 12:42:30 +0100
Message-Id: <1371555821-12820-23-git-send-email-luis.henriques@canonical.com>
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

commit a07088098a650267b2eda689538133a324b9523f upstream.

The outcont_endpoints array was indexed using the port minor number
(which can be greater than the array size) rather than the device port
number.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/keyspan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index a1b9924..2d35ad4 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -1670,7 +1670,7 @@ static int keyspan_usa26_send_setup(struct usb_serial *serial,
 	d_details = s_priv->device_details;
 	device_port = port->number - port->serial->minor;
 
-	outcont_urb = d_details->outcont_endpoints[port->number];
+	outcont_urb = d_details->outcont_endpoints[device_port];
 	this_urb = p_priv->outcont_urb;
 
 	dbg("%s - endpoint %d", __func__, usb_pipeendpoint(this_urb->pipe));
-- 
1.8.1.2

