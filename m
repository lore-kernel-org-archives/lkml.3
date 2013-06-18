Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859Ab3FRJxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 05:53:19 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:59987 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754396Ab3FRJxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 05:53:18 -0400
MIME-Version: 1.0
Date: Tue, 18 Jun 2013 17:53:16 +0800
Message-ID: <CAPgLHd_vfuN7Uenprrc_230MbyR7hAg+D4NCSSKEfcGNDtbS_Q@mail.gmail.com>
Subject: [PATCH -next] Staging: netlogic: fix missing free_netdev() on error
 in xlr_net_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: gregkh@linuxfoundation.org, ganesanr@broadcom.com,
        tushar.behera@linaro.org
Cc: yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix missing free_netdev() before return from function xlr_net_probe()
in the devm_ioremap_resource() error handling case.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
no compile test.
---
 drivers/staging/netlogic/xlr_net.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/netlogic/xlr_net.c b/drivers/staging/netlogic/xlr_net.c
index b529d79..2acde54 100644
--- a/drivers/staging/netlogic/xlr_net.c
+++ b/drivers/staging/netlogic/xlr_net.c
@@ -1023,9 +1023,9 @@ static int xlr_net_probe(struct platform_device *pdev)
 	ndev->base_addr = (unsigned long) devm_ioremap_resource
 		(&pdev->dev, res);
 	if (IS_ERR_VALUE(ndev->base_addr)) {
-		dev_err(&pdev->dev,
-				"devm_ioremap_resource failed\n");
-		return ndev->base_addr;
+		dev_err(&pdev->dev, "devm_ioremap_resource failed\n");
+		err = ndev->base_addr;
+		goto err_gmac;
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);

