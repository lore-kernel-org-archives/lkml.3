Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758834Ab3EUCnh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 22:43:37 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:32748 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758602Ab3EUCnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 22:43:31 -0400
From: Libo Chen <libo.chen@huawei.com>
To: <brudley@broadcom.com>, <arend@broadcom.com>, <frankyl@broadcom.com>,
        <meuleman@broadcom.com>, <linville@tuxdriver.com>
CC: <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        <brcm80211-dev-list@broadcom.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lizefan@huawei.com>,
        <libo.chen@huawei.com>
Subject: [PATCH 14/19] drivers/net/wireless/brcm80211/brcmfmac: add missing platform_driver owner
Date: Tue, 21 May 2013 10:42:40 +0800
Message-ID: <1369104160-5624-1-git-send-email-libo.chen@huawei.com>
X-Mailer: git-send-email 1.8.1.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

set the owner of platform_driver, to ensure that the
caller of driver holds a module refernece

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 44fa0cd..11400b3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -606,7 +606,8 @@ static int brcmf_sdio_pd_remove(struct platform_device *pdev)
 static struct platform_driver brcmf_sdio_pd = {
 	.remove		= brcmf_sdio_pd_remove,
 	.driver		= {
-		.name	= BRCMFMAC_SDIO_PDATA_NAME
+		.name	= BRCMFMAC_SDIO_PDATA_NAME,
+		.owner	= THIS_MODULE,
 	}
 };
 
-- 
1.7.1


