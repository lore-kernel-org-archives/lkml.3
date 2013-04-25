Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932854Ab3DYRaF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 13:30:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62912 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932523Ab3DYR37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 13:29:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Chas Williams <chas@cmf.nrl.navy.mil>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH 05/21] atm: he: use mdelay instead of large udelay constants
Date: Thu, 25 Apr 2013 19:28:48 +0200
Message-Id: <1366910944-3033663-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
References: <1366910944-3033663-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:owGBgzWOFO8Gwr83p82TUcAghVvhlF9OaRp3Yanc1Gl
 eY+wYfB4oukUUxSdbaXRxsw4NBPMFACi+JI2Cgc5WUrtMAO21N
 nSf8he44HBX31w91lGgI3ubXO7kUX+TNjBEQQk+vAFQ3ij9QvG
 KxF+TCFKY05PRUTenbDY87R6eixL1IFZC+nqiiupME181946oA
 zcfcWz2FkwCu9I31GinHBuevft0zkq/F98umxjzkQUbmg0naK/
 +ID/wCC2TDFHYKHWnXanyPx/6vBQriaQ+8tc4396/O45baun5f
 mLW/34RdKqy4m1qfAfpsaSn9rkYO/T5ktK13py7TU6mu+mgiyY
 NE2YmFb+YULeNvjK4o2nkkwLxzRU/e3MewWyN0KYx
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM cannot handle udelay for more than 2 miliseconds, so we
should use mdelay instead for those.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Chas Williams <chas@cmf.nrl.navy.mil>
Cc: linux-atm-general@lists.sourceforge.net
Cc: netdev@vger.kernel.org
---
 drivers/atm/he.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/atm/he.c b/drivers/atm/he.c
index d689126..7700061 100644
--- a/drivers/atm/he.c
+++ b/drivers/atm/he.c
@@ -1055,7 +1055,7 @@ static int he_start(struct atm_dev *dev)
 	he_writel(he_dev, 0x0, RESET_CNTL);
 	he_writel(he_dev, 0xff, RESET_CNTL);
 
-	udelay(16*1000);	/* 16 ms */
+	mdelay(16);	/* 16 ms */
 	status = he_readl(he_dev, RESET_CNTL);
 	if ((status & BOARD_RST_STATUS) == 0) {
 		hprintk("reset failed\n");
-- 
1.8.1.2

