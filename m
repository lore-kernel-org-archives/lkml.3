Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab3F2AaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 20:30:09 -0400
Received: from mail1.bemta12.messagelabs.com ([216.82.251.8]:13067 "EHLO
	mail1.bemta12.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752779Ab3F2AaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 20:30:08 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-8.tower-127.messagelabs.com!1372465803!1379938!5
X-Originating-IP: [216.166.12.72]
X-StarScan-Received: 
X-StarScan-Version: 6.9.9; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] usb: ohci-ep93xx: use devm_clk_get()
Date: Fri, 28 Jun 2013 17:29:04 -0700
User-Agent: KMail/1.9.9
CC: <stern@rowland.harvard.edu>, <kernel@wantstofly.org>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201306281729.04871.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_clk_get() to make the code a bit cleaner and simpler.

This also fixes a bug where a clk_put() is not done if usb_add_hcd()
fails.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Lennert Buytenhek <kernel@wantstofly.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/ohci-ep93xx.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/usb/host/ohci-ep93xx.c b/drivers/usb/host/ohci-ep93xx.c
index b4f5e64..28fa6b8 100644
--- a/drivers/usb/host/ohci-ep93xx.c
+++ b/drivers/usb/host/ohci-ep93xx.c
@@ -69,9 +69,8 @@ static int usb_hcd_ep93xx_probe(const struct hc_driver *driver,
 		goto err_put_hcd;
 	}
 
-	usb_host_clock = clk_get(&pdev->dev, NULL);
+	usb_host_clock = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(usb_host_clock)) {
-		dev_dbg(&pdev->dev, "clk_get failed\n");
 		retval = PTR_ERR(usb_host_clock);
 		goto err_put_hcd;
 	}
@@ -96,7 +95,6 @@ static void usb_hcd_ep93xx_remove(struct usb_hcd *hcd,
 {
 	usb_remove_hcd(hcd);
 	ep93xx_stop_hc(&pdev->dev);
-	clk_put(usb_host_clock);
 	usb_put_hcd(hcd);
 }
 
-- 
1.8.1.4

