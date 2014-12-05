Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464AbaLEFzJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 00:55:09 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:47401 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaLEFzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 00:55:01 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID sB55sb6H016845, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <sameo@linux.intel.com>, <lee.jones@linaro.org>, <chris@printf.net>,
        <ulf.hansson@linaro.org>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <dan.carpenter@oracle.com>, <rogerable@realtek.com>,
        <wei_wang@realsil.com.cn>, Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH v4 3/6] mmc: rtsx: init cookie at probe/card_event
Date: Fri, 5 Dec 2014 13:54:28 +0800
Message-ID: <561d5d6cb02c4db153c0c4ee793581725ab77857.1417758564.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1417758564.git.micky_ching@realsil.com.cn>
References: <cover.1417758564.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

host->cookie is used for handle async request,
we should init it to negative value when new card inserted,
make cookie value invalid.

Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
---
 drivers/mmc/host/rtsx_pci_sdmmc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
index b1390f0..90b7b6d 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -1321,6 +1321,7 @@ static void rtsx_pci_sdmmc_card_event(struct platform_device *pdev)
 {
 	struct realtek_pci_sdmmc *host = platform_get_drvdata(pdev);
 
+	host->cookie = -1;
 	mmc_detect_change(host->mmc, 0);
 }
 
@@ -1353,6 +1354,7 @@ static int rtsx_pci_sdmmc_drv_probe(struct platform_device *pdev)
 	host->pcr = pcr;
 	host->mmc = mmc;
 	host->pdev = pdev;
+	host->cookie = -1;
 	host->power_state = SDMMC_POWER_OFF;
 	INIT_WORK(&host->work, sd_request);
 	platform_set_drvdata(pdev, host);
-- 
1.9.1

