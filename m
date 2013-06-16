Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab3FPWQA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:16:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46389 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755670Ab3FPWJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:09:07 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Johan Hovold" <jhovold@gmail.com>
Date: Sun, 16 Jun 2013 23:01:38 +0100
Message-ID: <lsq.1371420098.96050969@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [42/83] USB: ark3116: fix control-message timeout
In-Reply-To: <lsq.1371420097.958132574@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.47-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 634371911730a462626071065b64cd6e1fe213e0 upstream.

The control-message timeout is specified in milliseconds and should not
depend on HZ.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/serial/ark3116.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/serial/ark3116.c
+++ b/drivers/usb/serial/ark3116.c
@@ -49,7 +49,7 @@ static int debug;
 #define DRIVER_NAME "ark3116"
 
 /* usb timeout of 1 second */
-#define ARK_TIMEOUT (1*HZ)
+#define ARK_TIMEOUT 1000
 
 static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x6547, 0x0232) },

