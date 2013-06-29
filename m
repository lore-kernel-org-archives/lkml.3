Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab3F2Aak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 20:30:40 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.98]:59995 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753171Ab3F2Aaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 20:30:39 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-15.tower-209.messagelabs.com!1372465829!6041021!11
X-Originating-IP: [216.166.12.69]
X-StarScan-Received: 
X-StarScan-Version: 6.9.9; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] usb: ohci-ep93xx: tidy up ohci_hcd_ep93xx_drv_probe()
Date: Fri, 28 Jun 2013 17:29:44 -0700
User-Agent: KMail/1.9.9
CC: <stern@rowland.harvard.edu>, <kernel@wantstofly.org>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201306281729.44988.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refactor the function a bit to remove the need for the local variable.

The extern prototype of usb_disabled() is not needed.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Lennert Buytenhek <kernel@wantstofly.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ohci-ep93xx.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/host/ohci-ep93xx.c b/drivers/usb/host/ohci-ep93xx.c
index 28fa6b8..bdc2908 100644
--- a/drivers/usb/host/ohci-ep93xx.c
+++ b/drivers/usb/host/ohci-ep93xx.c
@@ -138,17 +138,12 @@ static struct hc_driver ohci_ep93xx_hc_driver = {
 	.start_port_reset	= ohci_start_port_reset,
 };
 
-extern int usb_disabled(void);
-
 static int ohci_hcd_ep93xx_drv_probe(struct platform_device *pdev)
 {
-	int ret;
-
-	ret = -ENODEV;
-	if (!usb_disabled())
-		ret = usb_hcd_ep93xx_probe(&ohci_ep93xx_hc_driver, pdev);
+	if (usb_disabled())
+		return -ENODEV;
 
-	return ret;
+	return usb_hcd_ep93xx_probe(&ohci_ep93xx_hc_driver, pdev);
 }
 
 static int ohci_hcd_ep93xx_drv_remove(struct platform_device *pdev)
-- 
1.8.1.4

