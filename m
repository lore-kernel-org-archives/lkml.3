Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab3FKUUW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:20:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41851 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756548Ab3FKUDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:03:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 16/79] USB: ark3116: fix control-message timeout
Date: Tue, 11 Jun 2013 13:02:42 -0700
Message-Id: <20130611195314.587295104@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611195312.352656079@linuxfoundation.org>
References: <20130611195312.352656079@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 634371911730a462626071065b64cd6e1fe213e0 upstream.

The control-message timeout is specified in milliseconds and should not
depend on HZ.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/ark3116.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/serial/ark3116.c
+++ b/drivers/usb/serial/ark3116.c
@@ -43,7 +43,7 @@
 #define DRIVER_NAME "ark3116"
 
 /* usb timeout of 1 second */
-#define ARK_TIMEOUT (1*HZ)
+#define ARK_TIMEOUT 1000
 
 static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x6547, 0x0232) },


