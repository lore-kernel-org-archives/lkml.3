Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbaC0FcL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 01:32:11 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:37005 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbaC0FcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 01:32:08 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s2R5VgH2009402, This message is accepted by code: ctloc85258
From: <micky_ching@realsil.com.cn>
To: <chris@printf.net>, <sameo@linux.intel.com>
CC: <gregkh@linuxfoundation.org>, <dan.carpenter@oracle.com>,
        <ulf.hansson@linaro.org>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <rogerable@realtek.com>, <wei_wang@realsil.com.cn>,
        Micky Ching <micky_ching@realsil.com.cn>
Subject: [PATCH v2 1/2] mmc: rtsx: add R1-no-CRC mmc command type handle
Date: Thu, 27 Mar 2014 13:35:04 +0800
Message-ID: <afbc1328fb8a89fda3da23f1e9c755311450e1f6.1395824147.git.micky_ching@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1395824147.git.micky_ching@realsil.com.cn>
References: <cover.1395824147.git.micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

commit a27fbf2f067b0cd6f172c8b696b9a44c58bfaa7a
<mmc: add ignorance case for CMD13 CRC error>
produced a cmd.flags unhandled in realtek pci host driver.
This will make MMC card failed initialize, this patch is
used to handle the new cmd.flags condition and MMC card can be used.

Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
---
 drivers/mmc/host/rtsx_pci_sdmmc.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
index 5fb994f..0d8904a 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -346,6 +346,9 @@ static void sd_send_cmd(struct realtek_pci_sdmmc *host, struct mmc_command *cmd)
 	case MMC_RSP_R1:
 		rsp_type = SD_RSP_TYPE_R1;
 		break;
+	case MMC_RSP_R1 & ~MMC_RSP_CRC:
+		rsp_type = SD_RSP_TYPE_R1 | SD_NO_CHECK_CRC7;
+		break;
 	case MMC_RSP_R1B:
 		rsp_type = SD_RSP_TYPE_R1b;
 		break;
-- 
1.7.9.5

