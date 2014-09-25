Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187AbaIYWpa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 18:45:30 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:35489 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbaIYWp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 18:45:29 -0400
From: Behan Webster <behanw@converseincode.com>
To: bcm@fixthebug.org, chris@printf.net, mporter@linaro.org,
        ulf.hansson@linaro.org
Cc: behanw@converseincode.com, bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Subject: [PATCH v3] mmc, sdhci, bcm-kona, LLVMLinux: Remove use of __initconst
Date: Thu, 25 Sep 2014 15:45:22 -0700
Message-Id: <1411685122-21867-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <5774775.2EcFmuR4sV@wuerfel>
References: <5774775.2EcFmuR4sV@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __initconst is in the wrong place, and when moved to the correct place
it uncovers an error where the variable is used by non-init data structures.

Instead merely make them const and put the const in the right spot.

Signed-off-by: Behan Webster <behanw@converseincode.com>
Reviewed-by: Mark Charlebois <charlebm@gmail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Matt Porter <mporter@linaro.org>
---
 drivers/mmc/host/sdhci-bcm-kona.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-bcm-kona.c b/drivers/mmc/host/sdhci-bcm-kona.c
index dd780c3..d085dfe 100644
--- a/drivers/mmc/host/sdhci-bcm-kona.c
+++ b/drivers/mmc/host/sdhci-bcm-kona.c
@@ -225,7 +225,7 @@ static struct sdhci_pltfm_data sdhci_pltfm_data_kona = {
 		SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN,
 };
 
-static struct __initconst of_device_id sdhci_bcm_kona_of_match[] = {
+static const struct of_device_id sdhci_bcm_kona_of_match[] = {
 	{ .compatible = "brcm,kona-sdhci"},
 	{ .compatible = "bcm,kona-sdhci"}, /* deprecated name */
 	{}
-- 
1.9.1

