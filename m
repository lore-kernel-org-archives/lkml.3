Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbaCLMkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 08:40:22 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:48477 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbaCLMkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 08:40:13 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        tj@kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, b.zolnierkie@samsung.com,
        linux-ide@vger.kernel.org
Subject: [PATCH 4/5] ahci: st: Only build for ST-Micro h/w
Date: Wed, 12 Mar 2014 12:39:41 +0000
Message-Id: <1394627982-23726-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394627982-23726-1-git-send-email-lee.jones@linaro.org>
References: <1394627982-23726-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This device is designed specifically to run on ST-Microelectronics'
hardware. To ensure no attempts are made to run on anything incompatible
we add a dependency on ST architecture

Suggested-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/ata/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index f1adb4b..9b4feb7 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -100,6 +100,7 @@ config SATA_AHCI_PLATFORM
 config AHCI_ST
 	tristate "ST AHCI SATA support"
 	depends on SATA_AHCI_PLATFORM
+	depends on ARCH_STI
 	help
 	  This option enables support for ST AHCI SATA controller.
 
-- 
1.8.3.2

