Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbaEHOr0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:47:26 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:64580 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945AbaEHOrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:47:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Matt Porter <mporter@linaro.org>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 1/2] phy: kona2: use 'select GENERIC_PHY' in Kconfig
Date: Thu,  8 May 2014 16:46:53 +0200
Message-Id: <1399560433-1402630-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:5yoASF/ZUkyUuvtYzHl67pnj9D6pQIC0pl1kjTs6b0h
 yIfrqTOP+TGMRJmkUDEo7vCkM3PkUMM+ppkivTTqoMwgXusR+u
 e8O3Yr311bq5U8iK9JXPl7aY9e9XJsOBo2lo9Rw9gugQIlna8+
 3tqlr5WvxjvhXmhiy78H4XcW4ZTVMbwTkGwA1jJo5F4S3OUGwO
 eXDkVzaWoH10kiz7qvnUOzb7jfa8x+D7kj7HalJ1j8LeVT1oBz
 zneYE8R8HI7Mjyp6cee22m0gFMNz7F71T2VRepqRjpB9VMY6wP
 AWhlwNhY/C2N61R+/5/nnTvKoLDLfjbzaLN9xG8zi8we/csH3z
 CU+lbDEpsuoWbP98+1v11k8h34DqTpzkoGeGJ5mjU
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All other phy drivers use 'select', while this one is
the only one to use 'depends on'. This is not a bug, just
slightly inconsistent, so let's change it to do things the
same way as everyone else.

We may also want to turn GENERIC_PHY into a silent option
that only ever gets turned on if another driver needs it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Matt Porter <mporter@linaro.org>
Cc: Felipe Balbi <balbi@ti.com>
---
 drivers/phy/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
index 4906c27..071b763 100644
--- a/drivers/phy/Kconfig
+++ b/drivers/phy/Kconfig
@@ -89,8 +89,8 @@ config PHY_EXYNOS_DP_VIDEO
 
 config BCM_KONA_USB2_PHY
 	tristate "Broadcom Kona USB2 PHY Driver"
-	depends on GENERIC_PHY
 	depends on HAS_IOMEM
+	select GENERIC_PHY
 	help
 	  Enable this to support the Broadcom Kona USB 2.0 PHY.
 
-- 
1.8.3.2

