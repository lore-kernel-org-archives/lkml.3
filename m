Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab3LRKkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 05:40:51 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:33503 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472Ab3LRKkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 05:40:05 -0500
From: Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>
To: stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
        kgene.kim@samsung.com, linux-usb@vger.kernel.org,
        sarah.a.sharp@linux.intel.com, balbi@ti.com, gautam.vivek@samsung.com,
        joshi@samsung.com
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Bresticker <abrestic@chromium.org>,
        Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
Subject: [RFC 5/5] usb: dwc3: enable async suspend/resume
Date: Wed, 18 Dec 2013 16:09:34 +0530
Message-Id: <1387363174-25942-5-git-send-email-yuvaraj.cd@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387363174-25942-1-git-send-email-yuvaraj.cd@samsung.com>
References: <1387363174-25942-1-git-send-email-yuvaraj.cd@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Bresticker <abrestic@chromium.org>

In addition to enabling async suspend/resume on the xhci-plat device,
we must enable it for the dwc3 device (the parent of xhci-plat) in order
to make the full USB stack resume asynchronously.  Like the xhci-plat,
ehci-s5p, and ohci-exynos drivers, there are no outside dependencies
which would make resuming the dwc3 driver asynchronously unsafe.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
Reviewed-by: Julius Werner <jwerner@chromium.org>
Signed-off-by: Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
---
 drivers/usb/dwc3/core.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 59bb8d2..9c8a273 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -586,6 +586,8 @@ static int dwc3_probe(struct platform_device *pdev)
 
 	pm_runtime_allow(dev);
 
+	device_enable_async_suspend(dev);
+
 	return 0;
 
 err3:
-- 
1.7.9.5

