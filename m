Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064AbaIWWza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 18:55:30 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:46317 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756883AbaIWWzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 18:55:25 -0400
From: behanw@converseincode.com
To: bcm@fixthebug.org, chris@printf.net, gnurou@gmail.com,
        linus.walleij@linaro.org, mporter@linaro.org, ulf.hansson@linaro.org
Cc: bcm-kernel-feedback-list@broadcom.com, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        rjui@broadcom.com, Behan Webster <behanw@converseincode.com>
Subject: [PATCH v2 2/2] mmc, sdhci, bcm-kona, LLVMLinux: Remove use of __initconst
Date: Tue, 23 Sep 2014 15:55:08 -0700
Message-Id: <1411512908-19237-2-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411512908-19237-1-git-send-email-behanw@converseincode.com>
References: <20140923212922.GG12270@beef>
 <1411512908-19237-1-git-send-email-behanw@converseincode.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Behan Webster <behanw@converseincode.com>

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
index dd780c3..4bb06c8 100644
--- a/drivers/mmc/host/sdhci-bcm-kona.c
+++ b/drivers/mmc/host/sdhci-bcm-kona.c
@@ -225,7 +225,7 @@ static struct sdhci_pltfm_data sdhci_pltfm_data_kona = {
 		SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN,
 };
 
-static struct __initconst of_device_id sdhci_bcm_kona_of_match[] = {
+static struct of_device_id const sdhci_bcm_kona_of_match[] = {
 	{ .compatible = "brcm,kona-sdhci"},
 	{ .compatible = "bcm,kona-sdhci"}, /* deprecated name */
 	{}
-- 
1.9.1

