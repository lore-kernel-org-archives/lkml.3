Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260AbaCLMmj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 08:42:39 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:58282 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080AbaCLMkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 08:40:09 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        tj@kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, b.zolnierkie@samsung.com,
        linux-ide@vger.kernel.org
Subject: [PATCH 2/5] ahci: st: Remove legacy dependencies on PHY
Date: Wed, 12 Mar 2014 12:39:39 +0000
Message-Id: <1394627982-23726-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394627982-23726-1-git-send-email-lee.jones@linaro.org>
References: <1394627982-23726-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suggested-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/ata/Kconfig   | 1 -
 drivers/ata/ahci_st.c | 2 --
 2 files changed, 3 deletions(-)

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index ffc5d9d..f1adb4b 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -100,7 +100,6 @@ config SATA_AHCI_PLATFORM
 config AHCI_ST
 	tristate "ST AHCI SATA support"
 	depends on SATA_AHCI_PLATFORM
-	select GENERIC_PHY
 	help
 	  This option enables support for ST AHCI SATA controller.
 
diff --git a/drivers/ata/ahci_st.c b/drivers/ata/ahci_st.c
index f5af660..a28532a 100644
--- a/drivers/ata/ahci_st.c
+++ b/drivers/ata/ahci_st.c
@@ -16,7 +16,6 @@
 #include <linux/clk.h>
 #include <linux/of.h>
 #include <linux/ahci_platform.h>
-#include <linux/phy/phy.h>
 #include <linux/libata.h>
 #include <linux/reset.h>
 #include <linux/io.h>
@@ -33,7 +32,6 @@
 
 struct st_ahci_drv_data {
 	struct platform_device *ahci;
-	struct phy *phy;
 	struct reset_control *pwr;
 	struct reset_control *sw_rst;
 	struct reset_control *pwr_rst;
-- 
1.8.3.2

