Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758731Ab3IBJLI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 05:11:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37690 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758300Ab3IBIzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:55:04 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 15/58] USB: mos7840: fix big-endian probe
Date: Mon,  2 Sep 2013 09:54:00 +0100
Message-Id: <1378112083-9475-16-git-send-email-luis.henriques@canonical.com>
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

commit d551ec9b690f3de65b0091a2e767f1382adc792d upstream.

Fix bug in device-type detection on big-endian machines originally
introduced by commit 0eafe4de ("USB: serial: mos7840: add support for
MCS7810 devices") which always matched on little-endian product ids.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/serial/mos7840.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 0d51815..d9368be 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -2405,7 +2405,7 @@ static int mos7810_check(struct usb_serial *serial)
 static int mos7840_probe(struct usb_serial *serial,
 				const struct usb_device_id *id)
 {
-	u16 product = serial->dev->descriptor.idProduct;
+	u16 product = le16_to_cpu(serial->dev->descriptor.idProduct);
 	u8 *buf;
 	int device_type;
 
-- 
1.8.3.2

