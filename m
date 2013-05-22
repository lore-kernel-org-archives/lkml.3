Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565Ab3EVRsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 13:48:30 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:46569 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab3EVRsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 13:48:10 -0400
From: "Felipe F. Tonello" <eu@felipetonello.com>
To: linux-mmc@vger.kernel.org
Cc: ben-linux@fluff.org, cjb@laptop.org, arnd@arndb.de,
        linux-kernel@vger.kernel.org,
        "Felipe F. Tonello" <eu@felipetonello.com>
Subject: [PATCH 2/2] mmc: sdhci-s3c: Added set_power handler to platdata
Date: Wed, 22 May 2013 10:47:12 -0700
Message-Id: <1369244832-23868-3-git-send-email-eu@felipetonello.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1369244832-23868-1-git-send-email-eu@felipetonello.com>
References: <1369244832-23868-1-git-send-email-eu@felipetonello.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Felipe F. Tonello" <eu@felipetonello.com>

This is useful to turn off peripherals that are related to the mmc host. One
common case is when the wifi module is connected as an mmc card to the host.

Signed-off-by: Felipe F. Tonello <eu@felipetonello.com>
---
 drivers/mmc/host/sdhci-s3c.c                | 8 ++++++++
 include/linux/platform_data/mmc-sdhci-s3c.h | 1 +
 2 files changed, 9 insertions(+)

diff --git a/drivers/mmc/host/sdhci-s3c.c b/drivers/mmc/host/sdhci-s3c.c
index c6f6246..f7e740c 100644
--- a/drivers/mmc/host/sdhci-s3c.c
+++ b/drivers/mmc/host/sdhci-s3c.c
@@ -360,11 +360,19 @@ static int sdhci_s3c_platform_bus_width(struct sdhci_host *host, int width)
 	return 0;
 }
 
+static void sdhci_s3c_set_power(struct sdhci_host *host, bool power)
+{
+	struct sdhci_s3c *ourhost = to_s3c(host);
+	if (ourhost->pdata->set_power)
+		ourhost->pdata->set_power(power);
+}
+
 static struct sdhci_ops sdhci_s3c_ops = {
 	.get_max_clock		= sdhci_s3c_get_max_clk,
 	.set_clock		= sdhci_s3c_set_clock,
 	.get_min_clock		= sdhci_s3c_get_min_clock,
 	.platform_bus_width	= sdhci_s3c_platform_bus_width,
+	.set_power		= sdhci_s3c_set_power,
 };
 
 static void sdhci_s3c_notify_change(struct platform_device *dev, int state)
diff --git a/include/linux/platform_data/mmc-sdhci-s3c.h b/include/linux/platform_data/mmc-sdhci-s3c.h
index 249f023..55be925 100644
--- a/include/linux/platform_data/mmc-sdhci-s3c.h
+++ b/include/linux/platform_data/mmc-sdhci-s3c.h
@@ -50,6 +50,7 @@ struct s3c_sdhci_platdata {
 						      int state));
 
 	void	(*cfg_gpio)(struct platform_device *dev, int width);
+	void	(*set_power)(bool power);
 };
 
 
-- 
1.8.1.4

