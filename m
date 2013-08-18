Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756435Ab3HRUm0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:42:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43703 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab3HRUfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:35:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        kbuild test robot <fengguang.wu@intel.com>,
        Johan Hovold <jhovold@gmail.com>
Subject: [ 32/45] USB: mos7840: fix big-endian probe
Date: Sun, 18 Aug 2013 13:36:21 -0700
Message-Id: <20130818203623.224566690@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818203620.996166594@linuxfoundation.org>
References: <20130818203620.996166594@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit d551ec9b690f3de65b0091a2e767f1382adc792d upstream.

Fix bug in device-type detection on big-endian machines originally
introduced by commit 0eafe4de ("USB: serial: mos7840: add support for
MCS7810 devices") which always matched on little-endian product ids.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/mos7840.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -2208,7 +2208,7 @@ static int mos7810_check(struct usb_seri
 static int mos7840_probe(struct usb_serial *serial,
 				const struct usb_device_id *id)
 {
-	u16 product = serial->dev->descriptor.idProduct;
+	u16 product = le16_to_cpu(serial->dev->descriptor.idProduct);
 	u8 *buf;
 	int device_type;
 


