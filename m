Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab3BDHsz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 02:48:55 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:49893 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab3BDHsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 02:48:51 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID r147mUSd025233
From: Roger Tseng <rogerable@realtek.com>
To: <cjb@laptop.org>, <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <wei_wang@realsil.com.cn>, Roger Tseng <rogerable@realtek.com>
Subject: [PATCH 1/3] MMC: rtsx: remove driving adjustment
Date: Mon, 4 Feb 2013 15:45:57 +0800
Message-ID: <1359963959-2305-2-git-send-email-rogerable@realtek.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1359963959-2305-1-git-send-email-rogerable@realtek.com>
References: <1359963959-2305-1-git-send-email-rogerable@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several new models of readers use different way to select driving
capability(a necessary adjustment along with voltage change). Removing this
from device-independent rtsx_pci_sdmmc module. It will be implemented in
device-depend calls encapsulated by rtsx_pci_switch_output_voltage().

Signed-off-by: Roger Tseng <rogerable@realtek.com>
Reviewed-by: Wei WANG <wei_wang@realsil.com.cn>
---
 drivers/mmc/host/rtsx_pci_sdmmc.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
index f74b5ad..f93f100 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -1083,11 +1083,6 @@ static int sdmmc_switch_voltage(struct mmc_host *mmc, struct mmc_ios *ios)
 		voltage = OUTPUT_1V8;
 
 	if (voltage == OUTPUT_1V8) {
-		err = rtsx_pci_write_register(pcr,
-				SD30_DRIVE_SEL, 0x07, DRIVER_TYPE_B);
-		if (err < 0)
-			goto out;
-
 		err = sd_wait_voltage_stable_1(host);
 		if (err < 0)
 			goto out;
-- 
1.7.12.1

