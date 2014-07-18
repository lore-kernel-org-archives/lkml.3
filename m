Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761757AbaGRNJj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:09:39 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17447 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761325AbaGRNJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:09:36 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Micky Ching <micky_ching@realsil.com.cn>,
        Ulf Hansson <ulf.hansson@linaro.org>, Chris Ball <chris@printf.net>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 122/170] mmc: rtsx: add R1-no-CRC mmc command type handle
Date: Fri, 18 Jul 2014 14:12:07 +0200
Message-Id: <b0799474eb2c1b18e4b676150dfbbb18a68530a5.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Micky Ching <micky_ching@realsil.com.cn>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 5027251eced6e34315a52bd841279df957f627bb upstream.

a27fbf2f067b0cd ("mmc: add ignorance case for CMD13 CRC error") produced
a cmd.flags unhandled in realtek pci host driver.  This will make MMC
card fail to initialize, this patch is used to handle the new cmd.flags
condition and MMC card can be used.

Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Chris Ball <chris@printf.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/mmc/host/rtsx_pci_sdmmc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
index 375a880e0c5f..54e8ba45c3ad 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -246,6 +246,9 @@ static void sd_send_cmd_get_rsp(struct realtek_pci_sdmmc *host,
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
2.0.0

