Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab3EJIcb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 04:32:31 -0400
Received: from sauhun.de ([89.238.76.85]:60372 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575Ab3EJIQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 04:16:32 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>
Subject: [RFC 08/42] drivers/gpu/host1x/drm: don't check resource with devm_ioremap_resource
Date: Fri, 10 May 2013 10:16:53 +0200
Message-Id: <1368173847-5661-9-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
References: <1368173847-5661-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource does sanity checks on the given resource. No need to
duplicate this in the driver.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/gpu/host1x/drm/dc.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/gpu/host1x/drm/dc.c b/drivers/gpu/host1x/drm/dc.c
index 1e20603..8c04943 100644
--- a/drivers/gpu/host1x/drm/dc.c
+++ b/drivers/gpu/host1x/drm/dc.c
@@ -1128,11 +1128,6 @@ static int tegra_dc_probe(struct platform_device *pdev)
 		return err;
 
 	regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!regs) {
-		dev_err(&pdev->dev, "failed to get registers\n");
-		return -ENXIO;
-	}
-
 	dc->regs = devm_ioremap_resource(&pdev->dev, regs);
 	if (IS_ERR(dc->regs))
 		return PTR_ERR(dc->regs);
-- 
1.7.10.4

