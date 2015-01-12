Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbbALSzN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:55:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58149 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034AbbALSaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:30:13 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Guo <peter.guo@bayhubtech.com>, Ulf Hansson <ulf.hansson@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 150/216] mmc: sdhci-pci-o2micro: Fix Dell E5440 issue
Date: Mon, 12 Jan 2015 18:28:48 +0000
Message-Id: <1421087394-2712-38-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Guo <peter.guo@bayhubtech.com>

commit 6380ea099cdd46d7377b6fbec0291cf2aa387bad upstream.

Fix Dell E5440 when reboot Linux, can't find o2micro sd host chip issue.

Fixes: 01acf6917aed (mmc: sdhci-pci: add support of O2Micro/BayHubTech SD hosts)
Signed-off-by: Peter Guo <peter.guo@bayhubtech.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mmc/host/sdhci-pci-o2micro.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pci-o2micro.c b/drivers/mmc/host/sdhci-pci-o2micro.c
index 5670e381b0cf..e2ec108dba0e 100644
--- a/drivers/mmc/host/sdhci-pci-o2micro.c
+++ b/drivers/mmc/host/sdhci-pci-o2micro.c
@@ -127,8 +127,6 @@ void sdhci_pci_o2_fujin2_pci_init(struct sdhci_pci_chip *chip)
 		return;
 	scratch_32 &= ~((1 << 21) | (1 << 30));
 
-	/* Set RTD3 function disabled */
-	scratch_32 |= ((1 << 29) | (1 << 28));
 	pci_write_config_dword(chip->pdev, O2_SD_FUNC_REG3, scratch_32);
 
 	/* Set L1 Entrance Timer */
-- 
2.1.4

