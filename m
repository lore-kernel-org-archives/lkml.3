Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbaLPAoO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 19:44:14 -0500
Received: from c-82-192-226-27.customer.ggaweb.ch ([82.192.226.27]:33663 "EHLO
	dizzy-6.o2s.ch" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752023AbaLPAoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 19:44:09 -0500
Subject: [PATCH 4/4] mmc: sunxi: Removing unused code
From: David =?utf-8?q?Lanzend=C3=B6rfer?= <david.lanzendoerfer@o2s.ch>
To: Ulf Hansson <ulf.hansson@linaro.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-mmc@vger.kernel.org,
        Chris Ball <chris@printf.net>, linux-kernel@vger.kernel.org,
        Peter Griffin <peter.griffin@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>, Chen-Yu Tsai <wens@csie.org>,
        David =?utf-8?q?Lanzend=C3=B6rfer?= <david.lanzendoerfer@o2s.ch>,
        =?utf-8?b?5p2O5oOz?= <lixiang@allwinnertech.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org
Date: Tue, 16 Dec 2014 01:38:01 +0100
Message-ID: <20141216003801.15488.82217.stgit@dizzy-6.o2s.ch>
In-Reply-To: <20141216003412.15488.54812.stgit@dizzy-6.o2s.ch>
References: <20141216003412.15488.54812.stgit@dizzy-6.o2s.ch>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removing a relict from reverse engineering of the Android driver code in
sunxi_mmc_clk_set_rate.

Signed-off-by: David Lanzendörfer <david.lanzendoerfer@o2s.ch>
Reported-by: 李想 <lixiang@allwinnertech.com>
---
 drivers/mmc/host/sunxi-mmc.c |   10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/mmc/host/sunxi-mmc.c b/drivers/mmc/host/sunxi-mmc.c
index 5331c88..f73a569 100644
--- a/drivers/mmc/host/sunxi-mmc.c
+++ b/drivers/mmc/host/sunxi-mmc.c
@@ -635,7 +635,7 @@ static int sunxi_mmc_oclk_onoff(struct sunxi_mmc_host *host, u32 oclk_en)
 static int sunxi_mmc_clk_set_rate(struct sunxi_mmc_host *host,
 				  struct mmc_ios *ios)
 {
-	u32 rate, oclk_dly, rval, sclk_dly, src_clk;
+	u32 rate, oclk_dly, rval, sclk_dly;
 	int ret;
 
 	rate = clk_round_rate(host->clk_mmc, ios->clock);
@@ -680,14 +680,6 @@ static int sunxi_mmc_clk_set_rate(struct sunxi_mmc_host *host,
 		sclk_dly = 4;
 	}
 
-	src_clk = clk_get_rate(clk_get_parent(host->clk_mmc));
-	if (src_clk >= 300000000 && src_clk <= 400000000) {
-		if (oclk_dly)
-			oclk_dly--;
-		if (sclk_dly)
-			sclk_dly--;
-	}
-
 	clk_sunxi_mmc_phase_control(host->clk_mmc, sclk_dly, oclk_dly);
 
 	return sunxi_mmc_oclk_onoff(host, 1);

