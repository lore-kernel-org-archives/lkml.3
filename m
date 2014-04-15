Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbaDORvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 13:51:33 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:49221 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbaDORvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 13:51:31 -0400
From: Peter Foley <pefoley2@pefoley.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Foley <pefoley2@pefoley.com>, tj@kernel.org,
        linux-ide@vger.kernel.org
Subject: [PATCH] ata: fix kconfig selection warning
Date: Tue, 15 Apr 2014 13:50:55 -0400
Message-Id: <1397584255-15038-1-git-send-email-pefoley2@pefoley.com>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building with COMPILE_TEST, AHCI_XGENE is enabled even though
PHY_XGENE (which it selects) requires OF to be enabled.
Fix this by adding a dependency on OF to AHCI_XGENE.

warning: (AHCI_XGENE) selects PHY_XGENE which has unmet direct
dependencies (HAS_IOMEM && OF && (ARM64 || COMPILE_TEST))

Signed-off-by: Peter Foley <pefoley2@pefoley.com>
---
 drivers/ata/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index 20e03a7..071f399 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -134,7 +134,7 @@ config AHCI_SUNXI
 
 config AHCI_XGENE
 	tristate "APM X-Gene 6.0Gbps AHCI SATA host controller support"
-	depends on ARM64 || COMPILE_TEST
+	depends on OF && (ARM64 || COMPILE_TEST)
 	select PHY_XGENE
 	help
 	 This option enables support for APM X-Gene SoC SATA host controller.
-- 
1.9.2

