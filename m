Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab3EJIRm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 04:17:42 -0400
Received: from sauhun.de ([89.238.76.85]:60583 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753765Ab3EJIRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 04:17:38 -0400
From: Wolfram Sang <wsa@the-dreams.de>
To: linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: [RFC 34/42] drivers/video/omap2/dss: don't check resource with devm_ioremap_resource
Date: Fri, 10 May 2013 10:17:19 +0200
Message-Id: <1368173847-5661-35-git-send-email-wsa@the-dreams.de>
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
 drivers/video/omap2/dss/hdmi.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/video/omap2/dss/hdmi.c b/drivers/video/omap2/dss/hdmi.c
index 17f4d55..7bc6762 100644
--- a/drivers/video/omap2/dss/hdmi.c
+++ b/drivers/video/omap2/dss/hdmi.c
@@ -1064,13 +1064,8 @@ static int omapdss_hdmihw_probe(struct platform_device *pdev)
 	mutex_init(&hdmi.lock);
 	mutex_init(&hdmi.ip_data.lock);
 
-	res = platform_get_resource(hdmi.pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		DSSERR("can't get IORESOURCE_MEM HDMI\n");
-		return -EINVAL;
-	}
-
 	/* Base address taken from platform */
+	res = platform_get_resource(hdmi.pdev, IORESOURCE_MEM, 0);
 	hdmi.ip_data.base_wp = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(hdmi.ip_data.base_wp))
 		return PTR_ERR(hdmi.ip_data.base_wp);
-- 
1.7.10.4

