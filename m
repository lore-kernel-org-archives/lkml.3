Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932545AbaJIVHs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:07:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59118 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932502AbaJIVHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:07:43 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felipe Balbi <balbi@ti.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 029/163] usb: dwc3: omap: fix ordering for runtime pm calls
Date: Thu,  9 Oct 2014 14:00:54 -0700
Message-Id: <1412888588-26755-30-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felipe Balbi <balbi@ti.com>

commit 81a60b7f5c143ab3cdcd9943c9b4b7c63c32fc31 upstream.

we don't to gate clocks until our children are
done with their remove path.

Fixes: af310e9 (usb: dwc3: omap: use runtime API's to enable clocks)
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/dwc3/dwc3-omap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
index 7f7ea62..2a0422b 100644
--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -592,9 +592,9 @@ static int dwc3_omap_remove(struct platform_device *pdev)
 	if (omap->extcon_id_dev.edev)
 		extcon_unregister_interest(&omap->extcon_id_dev);
 	dwc3_omap_disable_irqs(omap);
+	device_for_each_child(&pdev->dev, NULL, dwc3_omap_remove_core);
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-	device_for_each_child(&pdev->dev, NULL, dwc3_omap_remove_core);
 
 	return 0;
 }
-- 
1.9.1

