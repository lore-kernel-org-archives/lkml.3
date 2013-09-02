Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932179Ab3IBJI6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 05:08:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37728 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758378Ab3IBIzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:55:13 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 23/58] USB: keyspan: fix null-deref at disconnect and release
Date: Mon,  2 Sep 2013 09:54:08 +0100
Message-Id: <1378112083-9475-24-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
References: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit ff8a43c10f1440f07a5faca0c1556921259f7f76 upstream.

Make sure to fail properly if the device is not accepted during attach
in order to avoid null-pointer derefs (of missing interface private
data) at disconnect or release.

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/keyspan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index 2d35ad4..9b55796 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -2439,7 +2439,7 @@ static int keyspan_startup(struct usb_serial *serial)
 	if (d_details == NULL) {
 		dev_err(&serial->dev->dev, "%s - unknown product id %x\n",
 		    __func__, le16_to_cpu(serial->dev->descriptor.idProduct));
-		return 1;
+		return -ENODEV;
 	}
 
 	/* Setup private data for serial driver */
-- 
1.8.3.2

