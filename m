Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769AbbA0MZG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:25:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35417 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbbA0MT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:19:57 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Xiang Wang <wangx@marvell.com>, Ulf Hansson <ulf.hansson@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 109/126] mmc: sdhci-pxav3: fix error handling of sdhci_add_host
Date: Tue, 27 Jan 2015 12:16:54 +0000
Message-Id: <1422361031-19364-110-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Wang <wangx@marvell.com>

commit 87d2163dae1f2388c7ccda5269be8d58e24382dd upstream.

Commit 0dcaa2499b7d111bd70da5b0976c34210c850fb3 improved error
handling of sdhci_add_host. However, "err_of_parse" and "err_cd_req"
should be placed after "pm_runtime_disable(&pdev->dev)".

Signed-off-by: Xiang Wang <wangx@marvell.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
[ luis: 3.16-stable prereq for:
  aa8165f91442 "mmc: sdhci-pxav3: do the mbus window configuration after enabling clocks" ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/mmc/host/sdhci-pxav3.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pxav3.c b/drivers/mmc/host/sdhci-pxav3.c
index 10846b04809a..6675be324cbc 100644
--- a/drivers/mmc/host/sdhci-pxav3.c
+++ b/drivers/mmc/host/sdhci-pxav3.c
@@ -382,11 +382,11 @@ static int sdhci_pxav3_probe(struct platform_device *pdev)
 
 	return 0;
 
-err_of_parse:
-err_cd_req:
 err_add_host:
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
+err_of_parse:
+err_cd_req:
 	clk_disable_unprepare(clk);
 	clk_put(clk);
 err_clk_get:
-- 
2.1.4

