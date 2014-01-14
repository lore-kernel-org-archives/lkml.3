Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbaANL73 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 06:59:29 -0500
Received: from sauhun.de ([89.238.76.85]:47831 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942AbaANL7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 06:59:20 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        =?UTF-8?q?Terje=20Bergstr=C3=B6m?= <tbergstrom@nvidia.com>,
        David Airlie <airlied@linux.ie>,
        Stephen Warren <swarren@wwwdotorg.org>,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org
Subject: [PATCH 3/7] drivers/gpu/host1x/drm: don't check resource with devm_ioremap_resource
Date: Tue, 14 Jan 2014 12:58:54 +0100
Message-Id: <1389700739-3696-3-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1389700739-3696-1-git-send-email-wsa@the-dreams.de>
References: <1389700739-3696-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource does sanity checks on the given resource. No need to
duplicate this in the driver.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Reviewed-by: Terje Bergstrom <tbergstrom@nvidia.com>
---

Should go via subsystem tree

 drivers/gpu/drm/tegra/hdmi.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/gpu/drm/tegra/hdmi.c b/drivers/gpu/drm/tegra/hdmi.c
index 0cd9bc2..1650fb3 100644
--- a/drivers/gpu/drm/tegra/hdmi.c
+++ b/drivers/gpu/drm/tegra/hdmi.c
@@ -1375,9 +1375,6 @@ static int tegra_hdmi_probe(struct platform_device *pdev)
 		return err;
 
 	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!regs)
-		return -ENXIO;
-
 	hdmi->regs = devm_ioremap_resource(&pdev->dev, regs);
 	if (IS_ERR(hdmi->regs))
 		return PTR_ERR(hdmi->regs);
-- 
1.8.5.1

