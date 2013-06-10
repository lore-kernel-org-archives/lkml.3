Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab3FJRP7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 13:15:59 -0400
Received: from mail.advaoptical.com ([91.217.199.15]:53991 "EHLO
	mail.advaoptical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab3FJRP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 13:15:57 -0400
From: Oded Gabbay <ogabbay@advaoptical.com>
To: <gregkh@linuxfoundation.org>, <cjb@laptop.org>, <dirk.behme@de.bosch.com>
CC: <linux-mmc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <ogabbay@advaoptical.com>
Subject: [PATCH] MMC: FSL SDHC: Add support for non-removable card. Kernel version 3.4.48
Date: Mon, 10 Jun 2013 20:15:40 +0300
Message-ID: <1370884540-25238-1-git-send-email-ogabbay@advaoptical.com>
X-Mailer: git-send-email 1.8.3
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.179.55]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8626,1.0.431,0.0.0000
 definitions=2013-06-10_04:2013-06-10,2013-06-10,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support of recognizing non-removable cards
to Freescale's SDHC host driver. This is done by detecting the
attribute "non-removable" in the probe function

This patch depends on patch[2/3] from 6-jun-2013:
https://patchwork.kernel.org/patch/2649381/

This patch is instead of patch[3/3] from 6-jun-2013:
https://patchwork.kernel.org/patch/2649231/

Signed-off-by: Oded Gabbay <ogabbay@advaoptical.com>
---
 drivers/mmc/host/sdhci-of-esdhc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mmc/host/sdhci-of-esdhc.c b/drivers/mmc/host/sdhci-of-esdhc.c
index e70f22f..a6e068c 100644
--- a/drivers/mmc/host/sdhci-of-esdhc.c
+++ b/drivers/mmc/host/sdhci-of-esdhc.c
@@ -222,6 +222,10 @@ static int __devinit sdhci_esdhc_probe(struct platform_device *pdev)
 		host->quirks2 |= SDHCI_QUIRK2_BROKEN_HOST_CONTROL;
 	}
 
+	/* Check if card is non-removable */
+	if (of_find_property(np, "non-removable", NULL))
+		host->caps |= MMC_CAP_NONREMOVABLE;
+
 	ret = sdhci_add_host(host);
 	if (ret)
 		sdhci_pltfm_free(pdev);
-- 
1.8.3

