Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab3LRKj6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 05:39:58 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:61121 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089Ab3LRKjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 05:39:49 -0500
From: Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>
To: stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
        kgene.kim@samsung.com, linux-usb@vger.kernel.org,
        sarah.a.sharp@linux.intel.com, balbi@ti.com, gautam.vivek@samsung.com,
        joshi@samsung.com
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Bresticker <abrestic@chromium.org>,
        Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
Subject: [RFC 2/5] usb: ehci-s5p: enable async suspend/resume
Date: Wed, 18 Dec 2013 16:09:31 +0530
Message-Id: <1387363174-25942-2-git-send-email-yuvaraj.cd@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387363174-25942-1-git-send-email-yuvaraj.cd@samsung.com>
References: <1387363174-25942-1-git-send-email-yuvaraj.cd@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Bresticker <abrestic@chromium.org>

USB host controllers can take a significant amount of time to suspend
and resume, adding several hundred miliseconds to the kernel resume
time. Since the Exynos EHCI controller has no outside dependencies
(other than clocks, which are suspended late/resumed early), allow it to
suspend and resume asynchronously.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
Reviewed-by: Julius Werner <jwerner@chromium.org>
Signed-off-by: Yuvaraj Kumar C D <yuvaraj.cd@samsung.com>
---
 drivers/usb/host/ehci-exynos.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/host/ehci-exynos.c b/drivers/usb/host/ehci-exynos.c
index f7ce8e2..e5125cd 100644
--- a/drivers/usb/host/ehci-exynos.c
+++ b/drivers/usb/host/ehci-exynos.c
@@ -165,6 +165,8 @@ skip_phy:
 	}
 	device_wakeup_enable(hcd->self.controller);
 
+	device_enable_async_suspend(&pdev->dev);
+
 	platform_set_drvdata(pdev, hcd);
 
 	return 0;
-- 
1.7.9.5

