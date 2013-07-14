Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab3GNL3u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 07:29:50 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:58913 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751801Ab3GNL3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 07:29:49 -0400
Message-ID: <1373801388.1370.15.camel@x61.thuisdomein>
Subject: [PATCH] staging: drm/imx: drop "select OF_VIDEOMODE"
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Sun, 14 Jul 2013 13:29:48 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jul 2013 11:29:48.0396 (UTC) FILETIME=[72B78AC0:01CE8085]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ac4c1a9b33 ("staging: drm/imx: Add LDB support") added the
DRM_IMX_LDB Kconfig entry. That entry selects OF_VIDEOMODE. But there is
no Kconfig symbol named OF_VIDEOMODE. The select statement for that
symbol is a nop. Drop it.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Not tested!

1) Perhaps OF_VIDEOMODE was selected because this commit added an
include of <video/of_videomode>. But the functionality of that header
requires the Kconfig symbol VIDEOMODE_HELPERS. The commit didn't use
that Kconfig symbol.

The again, as far as I can tell, the drm/imx code doesn't actually use
the videomode of-helper. So it seems the include of <video/of_videomode>
isn't needed anyway.

 drivers/staging/imx-drm/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/imx-drm/Kconfig b/drivers/staging/imx-drm/Kconfig
index 2233905..bd0f2fd 100644
--- a/drivers/staging/imx-drm/Kconfig
+++ b/drivers/staging/imx-drm/Kconfig
@@ -33,7 +33,6 @@ config DRM_IMX_TVE
 config DRM_IMX_LDB
 	tristate "Support for LVDS displays"
 	depends on DRM_IMX
-	select OF_VIDEOMODE
 	help
 	  Choose this to enable the internal LVDS Display Bridge (LDB)
 	  found on i.MX53 and i.MX6 processors.
-- 
1.8.1.4

