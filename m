Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab3LBDNo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 22:13:44 -0500
Received: from mail-qe0-f46.google.com ([209.85.128.46]:45304 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704Ab3LBDNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 22:13:21 -0500
From: Fabio Estevam <festevam@gmail.com>
To: akpm@linux-foundation.org
Cc: a.zummo@towertech.it, s.hauer@pengutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH 2/2] rtc: rtc-mxc: Check the return value from clk_prepare_enable()
Date: Mon,  2 Dec 2013 01:13:01 -0200
Message-Id: <1385953981-23630-2-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1385953981-23630-1-git-send-email-festevam@gmail.com>
References: <1385953981-23630-1-git-send-email-festevam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

clk_prepare_enable() may fail, so let's check its return value and propagate it
in the case of error.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/rtc/rtc-mxc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-mxc.c b/drivers/rtc/rtc-mxc.c
index a3ed1cf..419874f 100644
--- a/drivers/rtc/rtc-mxc.c
+++ b/drivers/rtc/rtc-mxc.c
@@ -394,7 +394,10 @@ static int mxc_rtc_probe(struct platform_device *pdev)
 		return PTR_ERR(pdata->clk);
 	}
 
-	clk_prepare_enable(pdata->clk);
+	ret = clk_prepare_enable(pdata->clk);
+	if (ret)
+		return ret;
+
 	rate = clk_get_rate(pdata->clk);
 
 	if (rate == 32768)
-- 
1.8.1.2

