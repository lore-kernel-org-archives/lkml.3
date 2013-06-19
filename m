Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934080Ab3FSCaD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 22:30:03 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:45323 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933836Ab3FSCaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 22:30:00 -0400
MIME-Version: 1.0
In-Reply-To: <51C04A32.1080208@linaro.org>
References: <CAPgLHd_vfuN7Uenprrc_230MbyR7hAg+D4NCSSKEfcGNDtbS_Q@mail.gmail.com>
	<51C04A32.1080208@linaro.org>
Date: Wed, 19 Jun 2013 10:29:59 +0800
Message-ID: <CAPgLHd9smhNqaZLq0a7fct+0MMuujpQ54KD48+TtfRXB==PSXw@mail.gmail.com>
Subject: [PATCH -next v2] Staging: netlogic: fix missing free_netdev() on
 error in xlr_net_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: tushar.behera@linaro.org
Cc: gregkh@linuxfoundation.org, ganesanr@broadcom.com,
        yongjun_wei@trendmicro.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix missing free_netdev() before return from function xlr_net_probe()
in the devm_ioremap_resource() error handling case.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
v1 -> v2: remove redundant error message.
---
 drivers/staging/netlogic/xlr_net.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/netlogic/xlr_net.c b/drivers/staging/netlogic/xlr_net.c
index b529d79..af9e3f1 100644
--- a/drivers/staging/netlogic/xlr_net.c
+++ b/drivers/staging/netlogic/xlr_net.c
@@ -1023,9 +1023,8 @@ static int xlr_net_probe(struct platform_device *pdev)
 	ndev->base_addr = (unsigned long) devm_ioremap_resource
 		(&pdev->dev, res);
 	if (IS_ERR_VALUE(ndev->base_addr)) {
-		dev_err(&pdev->dev,
-				"devm_ioremap_resource failed\n");
-		return ndev->base_addr;
+		err = ndev->base_addr;
+		goto err_gmac;
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);


