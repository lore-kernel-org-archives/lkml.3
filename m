Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbaEBPnZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:43:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43993 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900AbaEBPnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:43:22 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Russell King <rmk+kernel@arm.linux.org.uk>, Chris Ball <chris@printf.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 027/151] mmc: sdhci-bcm-kona: fix build errors when built-in
Date: Fri,  2 May 2014 08:36:55 -0700
Message-Id: <1399045139-4531-28-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit 4025ce24f326830135341814307c072f6c2a7738 upstream.

`sdhci_bcm_kona_remove' referenced in section `.data' of drivers/built-in.o: defined in discarded section `.exit.text' of drivers/built-in.o

Fixes: 058feb53666f ("mmc: sdhci-bcm-kona: make linker-section warning go away")
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Tested-by: Markus Mayer <markus.mayer@linaro.org>
Acked-by: Matt Porter <mporter@linaro.org>
Signed-off-by: Chris Ball <chris@printf.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/mmc/host/sdhci-bcm-kona.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-bcm-kona.c b/drivers/mmc/host/sdhci-bcm-kona.c
index 7a190fe..e5565aa 100644
--- a/drivers/mmc/host/sdhci-bcm-kona.c
+++ b/drivers/mmc/host/sdhci-bcm-kona.c
@@ -314,7 +314,7 @@ err_pltfm_free:
 	return ret;
 }
 
-static int __exit sdhci_bcm_kona_remove(struct platform_device *pdev)
+static int sdhci_bcm_kona_remove(struct platform_device *pdev)
 {
 	return sdhci_pltfm_unregister(pdev);
 }
-- 
1.9.1

