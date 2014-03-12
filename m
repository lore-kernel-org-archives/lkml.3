Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbaCLPsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 11:48:51 -0400
Received: from moutng.kundenserver.de ([212.227.17.13]:58653 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854AbaCLPsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 11:48:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kamil Debski <k.debski@samsung.com>
Cc: Tomasz Figa <t.figa@samsung.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] phy: exynos: fix building as a module
Date: Wed, 12 Mar 2014 16:48:13 +0100
Message-ID: <10501799.dhM9cVfZmk@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:tNjrXVdSiNAAD3MfW45ab05z0cz7b7jDESgNT7jO7Gi
 9fJixA6VeJfCqHDJmX1I/6j2wSCbkDLbmUI4zk30CeVjWEe76I
 k3sTpBA5Hphbnfdq/DSdS9gdJths14n8Hl8cgJVWEIIL/7pzU7
 I+VpG42rg9k5wSEY9YpwjVPgBgiuI1Ua8uvuFhwUdwqAOHL/gV
 ywFbhWsjBgQ74axuEO4yQOvhSYlwM+t2k+U2SDuSBfeOdSWSfK
 BRvVqgKjUNgmo5Nn0zZbNvz4xke2Jq2I8DXWxjWEqqjrtBR4Pl
 MqVC0Z0yl/94/qLsBOJeVcXKcRWD8idTJS67aFqB7KvDZwk6Rb
 3M9aoMTIm6J1ebPGqC4g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The top-level phy-samsung-usb2 driver may be configured as a
loadable module, which currently causes link errors because
of the dependency on the exynos{5250,4x12,4210}_usb2_phy_config
symbol. Solving this could be achieved by exporting these
symbols, but as the SoC-specific parts of the driver are not
currently built as modules, it seems better to just link
everything into one module and avoid the need for the export.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
index 2faf78e..7728518 100644
--- a/drivers/phy/Makefile
+++ b/drivers/phy/Makefile
@@ -13,8 +13,9 @@ obj-$(CONFIG_TI_PIPE3)			+= phy-ti-pipe3.o
 obj-$(CONFIG_TWL4030_USB)		+= phy-twl4030-usb.o
 obj-$(CONFIG_PHY_EXYNOS5250_SATA)	+= phy-exynos5250-sata.o
 obj-$(CONFIG_PHY_SUN4I_USB)		+= phy-sun4i-usb.o
-obj-$(CONFIG_PHY_SAMSUNG_USB2)		+= phy-samsung-usb2.o
-obj-$(CONFIG_PHY_EXYNOS4210_USB2)	+= phy-exynos4210-usb2.o
-obj-$(CONFIG_PHY_EXYNOS4X12_USB2)	+= phy-exynos4x12-usb2.o
-obj-$(CONFIG_PHY_EXYNOS5250_USB2)	+= phy-exynos5250-usb2.o
+obj-$(CONFIG_PHY_SAMSUNG_USB2)		+= phy-exynos-usb2.o
+phy-exynos-usb2-y			+= phy-samsung-usb2.o
+phy-exynos-usb2-$(CONFIG_PHY_EXYNOS4210_USB2)	+= phy-exynos4210-usb2.o
+phy-exynos-usb2-$(CONFIG_PHY_EXYNOS4X12_USB2)	+= phy-exynos4x12-usb2.o
+phy-exynos-usb2-$(CONFIG_PHY_EXYNOS5250_USB2)	+= phy-exynos5250-usb2.o
 obj-$(CONFIG_PHY_XGENE)			+= phy-xgene.o

