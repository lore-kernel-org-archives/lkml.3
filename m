Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464AbaLPOLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 09:11:15 -0500
Received: from c-82-192-226-27.customer.ggaweb.ch ([82.192.226.27]:35257 "EHLO
	dizzy-6.o2s.ch" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751355AbaLPOLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 09:11:11 -0500
Subject: [PATCH 3/4] mmc: sunxi: Correcting SDXC_HARDWARE_RESET bit
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
Date: Tue, 16 Dec 2014 15:11:10 +0100
Message-ID: <20141216141110.3036.2534.stgit@dizzy-6.o2s.ch>
In-Reply-To: <20141216140921.3036.14668.stgit@dizzy-6.o2s.ch>
References: <20141216140921.3036.14668.stgit@dizzy-6.o2s.ch>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing the register name in sunxi_mmc_reset_host since the SDXC_HARDWARE_RESET bit
is actually located within REG_GCTRL and not REG_CMDR as it was pointed out by Allwinner.

Signed-off-by: David Lanzendörfer <david.lanzendoerfer@o2s.ch>
Reported-by: 李想 <lixiang@allwinnertech.com>
---
 drivers/mmc/host/sunxi-mmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sunxi-mmc.c b/drivers/mmc/host/sunxi-mmc.c
index 67e680c..695fe85 100644
--- a/drivers/mmc/host/sunxi-mmc.c
+++ b/drivers/mmc/host/sunxi-mmc.c
@@ -252,7 +252,7 @@ static int sunxi_mmc_reset_host(struct sunxi_mmc_host *host)
 	unsigned long expire = jiffies + msecs_to_jiffies(250);
 	u32 rval;
 
-	mmc_writel(host, REG_CMDR, SDXC_HARDWARE_RESET);
+	mmc_writel(host, REG_GCTRL, SDXC_HARDWARE_RESET);
 	do {
 		rval = mmc_readl(host, REG_GCTRL);
 	} while (time_before(jiffies, expire) && (rval & SDXC_HARDWARE_RESET));

