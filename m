Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818AbaKGNWz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 08:22:55 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:36854 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbaKGNWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 08:22:50 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Steve Glendinning <steve.glendinning@shawell.net>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usbnet: smsc95xx: dereferencing NULL pointer
Date: Fri,  7 Nov 2014 18:52:40 +0530
Message-Id: <1415366560-27614-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we were dereferencing dev to initialize pdata. but just after that we
have a BUG_ON(!dev). so we were basically dereferencing the pointer
first and then tesing it for NULL.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/net/usb/smsc95xx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index d07bf4c..3393238 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -1670,12 +1670,13 @@ done:
 static int smsc95xx_resume(struct usb_interface *intf)
 {
 	struct usbnet *dev = usb_get_intfdata(intf);
-	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
+	struct smsc95xx_priv *pdata;
 	u8 suspend_flags = pdata->suspend_flags;
 	int ret;
 	u32 val;
 
 	BUG_ON(!dev);
+	pdata = (struct smsc95xx_priv *)(dev->data[0]);
 
 	netdev_dbg(dev->net, "resume suspend_flags=0x%02x\n", suspend_flags);
 
-- 
1.8.1.2

