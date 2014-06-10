Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935000AbaFJAlo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 20:41:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58245 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933945AbaFJAWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 20:22:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>,
        Ben Hutchings <ben@decadent.org.uk>, Jianguo Wu <wujianguo@huawei.com>
Subject: [PATCH 3.4 25/88] Bluetooth: Add USB_VENDOR_AND_INTERFACE_INFO() for Broadcom/Foxconn
Date: Mon,  9 Jun 2014 17:24:35 -0700
Message-Id: <20140610002425.350463528@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140610002424.500996570@linuxfoundation.org>
References: <20140610002424.500996570@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gustavo Padovan <gustavo.padovan@collabora.co.uk>

commit ee66401bb94b1f2ce51089c341dcdd25d26ae631 upstream.

Foxconn devices has a vendor specific class of device, we will match them
differently now.

Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Jianguo Wu <wujianguo@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bluetooth/btusb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -108,7 +108,7 @@ static struct usb_device_id btusb_table[
 	{ USB_DEVICE(0x413c, 0x8197) },
 
 	/* Foxconn - Hon Hai */
-	{ USB_DEVICE(0x0489, 0xe033) },
+	{ USB_VENDOR_AND_INTERFACE_INFO(0x0489, 0xff, 0x01, 0x01) },
 
 	/*Broadcom devices with vendor specific id */
 	{ USB_VENDOR_AND_INTERFACE_INFO(0x0a5c, 0xff, 0x01, 0x01) },


