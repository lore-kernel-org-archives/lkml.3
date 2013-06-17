Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753892Ab3FQRd0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:33:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50487 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632Ab3FQRdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:33:23 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 27/84] USB: keyspan: fix bogus array index
Date: Mon, 17 Jun 2013 10:30:31 -0700
Message-Id: <1371490288-23167-28-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371490288-23167-1-git-send-email-kamal@canonical.com>
References: <1371490288-23167-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit a07088098a650267b2eda689538133a324b9523f upstream.

The outcont_endpoints array was indexed using the port minor number
(which can be greater than the array size) rather than the device port
number.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/serial/keyspan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index 97bc49f..c7585cb 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -1604,7 +1604,7 @@ static int keyspan_usa26_send_setup(struct usb_serial *serial,
 	d_details = s_priv->device_details;
 	device_port = port->number - port->serial->minor;
 
-	outcont_urb = d_details->outcont_endpoints[port->number];
+	outcont_urb = d_details->outcont_endpoints[device_port];
 	this_urb = p_priv->outcont_urb;
 
 	dev_dbg(&port->dev, "%s - endpoint %d\n", __func__, usb_pipeendpoint(this_urb->pipe));
-- 
1.8.1.2

