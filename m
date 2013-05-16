Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab3EPLPk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 07:15:40 -0400
Received: from sauhun.de ([89.238.76.85]:56247 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967Ab3EPLPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 07:15:32 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: [PATCH 26/33] drivers/video/omap2/dss: don't check resource with devm_ioremap_resource
Date: Thu, 16 May 2013 13:15:54 +0200
Message-Id: <1368702961-4325-27-git-send-email-wsa@the-dreams.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368702961-4325-1-git-send-email-wsa@the-dreams.de>
References: <1368702961-4325-1-git-send-email-wsa@the-dreams.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_ioremap_resource does sanity checks on the given resource. No need to
duplicate this in the driver.

Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
---
 drivers/video/omap2/dss/hdmi.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/video/omap2/dss/hdmi.c b/drivers/video/omap2/dss/hdmi.c
index 17f4d55..a109934 100644
--- a/drivers/video/omap2/dss/hdmi.c
+++ b/drivers/video/omap2/dss/hdmi.c
@@ -1065,10 +1065,6 @@ static int omapdss_hdmihw_probe(struct platform_device *pdev)
 	mutex_init(&hdmi.ip_data.lock);
 
 	res = platform_get_resource(hdmi.pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		DSSERR("can't get IORESOURCE_MEM HDMI\n");
-		return -EINVAL;
-	}
 
 	/* Base address taken from platform */
 	hdmi.ip_data.base_wp = devm_ioremap_resource(&pdev->dev, res);
-- 
1.7.10.4

