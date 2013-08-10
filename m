Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934446Ab3HJPYJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 11:24:09 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:58683 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934117Ab3HJPWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 11:22:43 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: sonic.zhang@analog.com, cjb@laptop.org
Cc: Shuah Khan <shuah.kh@samsung.com>, uclinux-dist-devel@blackfin.uclinux.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com
Subject: [PATCH] mmc:bfin_sdh fix build warning in sdh_dma_irq()
Date: Sat, 10 Aug 2013 09:20:49 -0600
Message-Id: <1376148055-2539-4-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376148055-2539-1-git-send-email-shuah.kh@samsung.com>
References: <1376148055-2539-1-git-send-email-shuah.kh@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following build warning in sdh_dma_irq()
drivers/mmc/host/bfin_sdh.c:466:2: warning: format ‘%lx’ expects argument of type ‘long unsigned int’, but argument 5 has type ‘int’ [-Wformat]
       dev_dbg(mmc_dev(host->mmc), "%s enter, irq_stat: 0x%04x\n", __func__,
                get_dma_curr_irqstat(host->dma_ch));

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/mmc/host/bfin_sdh.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/bfin_sdh.c b/drivers/mmc/host/bfin_sdh.c
index 7b3e12f..61157c4 100644
--- a/drivers/mmc/host/bfin_sdh.c
+++ b/drivers/mmc/host/bfin_sdh.c
@@ -463,7 +463,7 @@ static irqreturn_t sdh_dma_irq(int irq, void *devid)
 {
 	struct sdh_host *host = devid;
 
-	dev_dbg(mmc_dev(host->mmc), "%s enter, irq_stat: 0x%04lx\n", __func__,
+	dev_dbg(mmc_dev(host->mmc), "%s enter, irq_stat: 0x%04x\n", __func__,
 		get_dma_curr_irqstat(host->dma_ch));
 	clear_dma_irqstat(host->dma_ch);
 	SSYNC();
-- 
1.7.10.4

