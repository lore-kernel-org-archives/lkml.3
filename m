Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878AbaJCXiN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:38:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46304 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757349AbaJCWDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:03:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3.14 102/238] usb: dwc3: omap: fix ordering for runtime pm calls
Date: Fri,  3 Oct 2014 14:30:17 -0700
Message-Id: <20141003212916.940835369@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felipe Balbi <balbi@ti.com>

commit 81a60b7f5c143ab3cdcd9943c9b4b7c63c32fc31 upstream.

we don't to gate clocks until our children are
done with their remove path.

Fixes: af310e9 (usb: dwc3: omap: use runtime API's to enable clocks)
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/dwc3-omap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -582,9 +582,9 @@ static int dwc3_omap_remove(struct platf
 	if (omap->extcon_id_dev.edev)
 		extcon_unregister_interest(&omap->extcon_id_dev);
 	dwc3_omap_disable_irqs(omap);
+	device_for_each_child(&pdev->dev, NULL, dwc3_omap_remove_core);
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-	device_for_each_child(&pdev->dev, NULL, dwc3_omap_remove_core);
 
 	return 0;
 }


