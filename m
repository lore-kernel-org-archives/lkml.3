Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367Ab3CLJFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 05:05:05 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:38759 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752813Ab3CLJFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 05:05:03 -0400
From: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexandru Gheorghiu <gheorghiuandru@gmail.com>
Subject: [PATCH] drivers: mmc: host: Use resource_size()
Date: Tue, 12 Mar 2013 01:04:54 +0200
Message-Id: <1363043094-11352-1-git-send-email-gheorghiuandru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Used resource_size function instead of explicit computation.
Patch found using coccinelle.

Signed-off-by: Alexandru Gheorghiu <gheorghiuandru@gmail.com>
---
 drivers/mmc/host/wmt-sdmmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/wmt-sdmmc.c b/drivers/mmc/host/wmt-sdmmc.c
index 154f0e8..541e097 100644
--- a/drivers/mmc/host/wmt-sdmmc.c
+++ b/drivers/mmc/host/wmt-sdmmc.c
@@ -925,7 +925,7 @@ static int wmt_mci_remove(struct platform_device *pdev)
 	clk_put(priv->clk_sdmmc);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(res->start, res->end - res->start + 1);
+	release_mem_region(res->start, resource_size(res));
 
 	mmc_free_host(mmc);
 
-- 
1.7.9.5

