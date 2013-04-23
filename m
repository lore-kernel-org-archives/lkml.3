Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485Ab3DWQfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:35:37 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62485 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757291Ab3DWQcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:32:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Stephen Warren <swarren@nvidia.com>, Chris Ball <cjb@laptop.org>
Subject: [PATCH 12/21] mmc: sdhci-tegra: fix MODULE_DEVICE_TABLE
Date: Tue, 23 Apr 2013 18:30:44 +0200
Message-Id: <1366734653-488286-13-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366734653-488286-1-git-send-email-arnd@arndb.de>
References: <1366734653-488286-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:3rC0wIE+OhfCJuEmUmps7z4GSoqYyiAfs6BtPlQvAQx
 PvkExUXdkoTW5tajJtGg1T/jCEKaUvL4musol9m/4n17b5c8iJ
 e3a4VEr9/JJmVxjRS1Erl/EUGLJbqTYyemURYpcmfMqHkiOecn
 HZwGnW+D0/sNL1aLwSM3o7nFz0QvO73OkkeMa84XIYj4Xoxgop
 ihSPwYJZ/1iWhvypj5AEaDrO+e0ocqERonD4oEPR4tdrFQ+beT
 gY0C0/TtT5VUw1wUOxINMU0VRhyXZWzDtSTaxChu3NNSs2fLv7
 VPZpontRZhML+uWfL86zRjAMcH+p/dzFcYg6MJnANOxCnVTYLt
 m/uAc66s+nCkLDGZSLlqgt3wimZ8Ec6M1LzSHYQGC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The symbol referenced in MODULE_DEVICE_TABLE must match the actual
table, otherwise we get a build error like

sdhci-tegra.c:206:34: error: '__mod_of_device_table' aliased to undefined symbol 'sdhci_dt_ids'

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Warren <swarren@nvidia.com>
Cc: Chris Ball <cjb@laptop.org>
---
 drivers/mmc/host/sdhci-tegra.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
index 08b06e9..85052bf 100644
--- a/drivers/mmc/host/sdhci-tegra.c
+++ b/drivers/mmc/host/sdhci-tegra.c
@@ -214,7 +214,7 @@ static const struct of_device_id sdhci_tegra_dt_match[] = {
 #endif
 	{}
 };
-MODULE_DEVICE_TABLE(of, sdhci_dt_ids);
+MODULE_DEVICE_TABLE(of, sdhci_tegra_dt_match);
 
 static void sdhci_tegra_parse_dt(struct device *dev,
 					struct sdhci_tegra *tegra_host)
-- 
1.8.1.2

