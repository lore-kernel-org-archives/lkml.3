Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933105Ab3HGS7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 14:59:53 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:4097 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932158Ab3HGS7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 14:59:50 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
From: "Christian Daudt" <csd@broadcom.com>
To: "Chris Ball" <cjb@laptop.org>, "Matt Porter" <matt.porter@linaro.org>,
        "Markus Mayer" <markus.mayer@linaro.org>,
        "Arnd Bergmann" <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org
cc: csd_b@daudt.org, "Christian Daudt" <csd@broadcom.com>
Subject: [PATCH] ARM: mmc: fix NONREMOVABLE test in sdhci-bcm-kona
Date: Wed, 7 Aug 2013 11:59:41 -0700
Message-ID: <1375901981-1495-1-git-send-email-csd@broadcom.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
X-WSS-ID: 7E1C49412L871930493-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sdhci-bcm-kona driver is incorrectly doing "|" to bit-test
NONREMOVABLE. Switch to "&"

Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
Reviewed-by: Matt Porter <matt.porter@linaro.org>
Signed-off-by: Christian Daudt <csd@broadcom.com>

diff --git a/drivers/mmc/host/sdhci-bcm-kona.c b/drivers/mmc/host/sdhci-bcm-kona.c
index 87175f9..9ffac0b 100644
--- a/drivers/mmc/host/sdhci-bcm-kona.c
+++ b/drivers/mmc/host/sdhci-bcm-kona.c
@@ -263,7 +263,7 @@ static int __init sdhci_bcm_kona_probe(struct platform_device *pdev)
 		(mmc_gpio_get_cd(host->mmc) != -ENOSYS) ? 'Y' : 'N',
 		(mmc_gpio_get_ro(host->mmc) != -ENOSYS) ? 'Y' : 'N');
 
-	if (host->mmc->caps | MMC_CAP_NONREMOVABLE)
+	if (host->mmc->caps & MMC_CAP_NONREMOVABLE)
 		host->quirks |= SDHCI_QUIRK_BROKEN_CARD_DETECTION;
 
 	dev_dbg(dev, "is_8bit=%c\n",
@@ -282,7 +282,7 @@ static int __init sdhci_bcm_kona_probe(struct platform_device *pdev)
 	}
 
 	/* if device is eMMC, emulate card insert right here */
-	if (host->mmc->caps | MMC_CAP_NONREMOVABLE) {
+	if (host->mmc->caps & MMC_CAP_NONREMOVABLE) {
 		ret = sdhci_bcm_kona_sd_card_emulate(host, 1);
 		if (ret) {
 			dev_err(dev,
-- 
1.7.10.4


