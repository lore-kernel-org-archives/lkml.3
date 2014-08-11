Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236AbaHKKSL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 06:18:11 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:1922 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752360AbaHKKSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 06:18:09 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 11 Aug 2014 03:09:03 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <tj@kernel.org>, <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>
CC: <linux-ide@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH] ata: ahci_tegra: Change include to fix compilation
Date: Mon, 11 Aug 2014 13:17:48 +0300
Message-ID: <1407752268-18745-1-git-send-email-mperttunen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before this patch, the driver included <linux/tegra-powergate.h>,
which was effectively renamed to <soc/tegra/pmc.h> at about the same
time the ahci_tegra series landed. Fix the include path so that the
driver compiles.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
---
This would be for 3.17.

 drivers/ata/ahci_tegra.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/ahci_tegra.c b/drivers/ata/ahci_tegra.c
index fc3df47..f1fef74 100644
--- a/drivers/ata/ahci_tegra.c
+++ b/drivers/ata/ahci_tegra.c
@@ -24,8 +24,8 @@
 #include <linux/module.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
-#include <linux/tegra-powergate.h>
 #include <linux/regulator/consumer.h>
+#include <soc/tegra/pmc.h>
 #include "ahci.h"
 
 #define SATA_CONFIGURATION_0				0x180
-- 
1.8.1.5

