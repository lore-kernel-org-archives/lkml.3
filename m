Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab3LRKkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 05:40:06 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:35426 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389Ab3LRKkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 05:40:00 -0500
From: Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>
To: stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
        kgene.kim@samsung.com, linux-usb@vger.kernel.org,
        sarah.a.sharp@linux.intel.com, balbi@ti.com, gautam.vivek@samsung.com,
        joshi@samsung.com
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Bresticker <abrestic@chromium.org>,
        Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
Subject: [RFC 4/5] usb: dwc3-exynos: enable async suspend/resume
Date: Wed, 18 Dec 2013 16:09:33 +0530
Message-Id: <1387363174-25942-4-git-send-email-yuvaraj.cd@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387363174-25942-1-git-send-email-yuvaraj.cd@samsung.com>
References: <1387363174-25942-1-git-send-email-yuvaraj.cd@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Bresticker <abrestic@chromium.org>

In addition to enabling async suspend/resume on the xhci-plat device,
we must enable it for the dwc3-exynos platform device in order to make
the full USB stack resume asynchronously.  Like the xhci-plat, ehci-s5p,
and ohci-exynos drivers, there are no outside dependencies which would
make resuming the dwc3-exynos driver asynchronously unsafe.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
Reviewed-by: Julius Werner <jwerner@chromium.org>
Signed-off-by: Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
---
 drivers/usb/dwc3/dwc3-exynos.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-exynos.c
index 8b20c70..57431b7 100644
--- a/drivers/usb/dwc3/dwc3-exynos.c
+++ b/drivers/usb/dwc3/dwc3-exynos.c
@@ -155,6 +155,8 @@ static int dwc3_exynos_probe(struct platform_device *pdev)
 		goto err2;
 	}
 
+	device_enable_async_suspend(dev);
+
 	return 0;
 
 err2:
-- 
1.7.9.5

