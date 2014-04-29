Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462AbaD2LTZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 07:19:25 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:60347 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757429AbaD2LTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 07:19:23 -0400
From: Xia Kaixu <kaixu.xia@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linaro-kernel@lists.linaro.org, arnd@arndb.de, kaixu.xia@linaro.org,
        Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, alsa-devel@alsa-project.org
Subject: [PATCH 04/15] ASoC: samsung-idma: avoid 64-bit division
Date: Tue, 29 Apr 2014 19:18:25 +0800
Message-Id: <1398770316-19715-5-git-send-email-kaixu.xia@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398770316-19715-1-git-send-email-kaixu.xia@linaro.org>
References: <1398770316-19715-1-git-send-email-kaixu.xia@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

dma_addr_t may be 64 bit wide, which causes a build failure
when doing a division on it. Here it is safe to cast to an
u32 type, which avoids the problem.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Xia Kaixu <kaixu.xia@linaro.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-samsung-soc@vger.kernel.org
Cc: alsa-devel@alsa-project.org
---
 sound/soc/samsung/idma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/samsung/idma.c b/sound/soc/samsung/idma.c
index 3d5cf15..e9891b4 100644
--- a/sound/soc/samsung/idma.c
+++ b/sound/soc/samsung/idma.c
@@ -274,7 +274,7 @@ static irqreturn_t iis_irq(int irqno, void *dev_id)
 
 		addr = readl(idma.regs + I2SLVL0ADDR) - idma.lp_tx_addr;
 		addr += prtd->periodsz;
-		addr %= (prtd->end - prtd->start);
+		addr %= (u32)(prtd->end - prtd->start);
 		addr += idma.lp_tx_addr;
 
 		writel(addr, idma.regs + I2SLVL0ADDR);
-- 
1.7.9.5

