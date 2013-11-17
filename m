Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753595Ab3KQS0X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 13:26:23 -0500
Received: from mail-gg0-f178.google.com ([209.85.161.178]:53276 "EHLO
	mail-gg0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab3KQS0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 13:26:17 -0500
From: "Geyslan G. Bem" <geyslan@gmail.com>
To: geyslan@gmail.com
Cc: Viresh Kumar <viresh.linux@gmail.com>, Chris Ball <cjb@laptop.org>,
        spear-devel@list.st.com (open list:SECURE DIGITAL HO...),
        linux-mmc@vger.kernel.org (open list:SECURE DIGITAL HO...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] mmc: sdhci-spear: fix possible null dereference
Date: Sun, 17 Nov 2013 15:20:19 -0300
Message-Id: <1384712421-10632-1-git-send-email-geyslan@gmail.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Put the 'pdata->card_int_gpio' assignment in inner scope, avoiding
explicit null dereference.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 drivers/mmc/host/sdhci-spear.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci-spear.c b/drivers/mmc/host/sdhci-spear.c
index 2dba9f8..c6e5d16 100644
--- a/drivers/mmc/host/sdhci-spear.c
+++ b/drivers/mmc/host/sdhci-spear.c
@@ -88,10 +88,9 @@ static struct sdhci_plat_data *sdhci_probe_config_dt(struct platform_device *pde
 			dev_err(&pdev->dev, "DT: kzalloc failed\n");
 			return ERR_PTR(-ENOMEM);
 		}
+		pdata->card_int_gpio = cd_gpio;
 	}
 
-	pdata->card_int_gpio = cd_gpio;
-
 	return pdata;
 }
 #else
-- 
1.8.4.2

