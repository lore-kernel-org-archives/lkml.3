Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab3EPEI7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 00:08:59 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:60252 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab3EPEI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 00:08:58 -0400
MIME-Version: 1.0
Date: Thu, 16 May 2013 12:08:56 +0800
Message-ID: <CAPgLHd90ZfRjXAt6qYsk4RmBh1sb8VRq00gkNrtPEKdJfUXTaA@mail.gmail.com>
Subject: [PATCH] spi: ep93xx: fix error return code in ep93xx_spi_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: broonie@kernel.org, grant.likely@linaro.org
Cc: yongjun_wei@trendmicro.com.cn, spi-devel-general@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return -ENOMEM in the workqueue create error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/spi/spi-ep93xx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-ep93xx.c b/drivers/spi/spi-ep93xx.c
index 8d4f2a6..2ee5e74 100644
--- a/drivers/spi/spi-ep93xx.c
+++ b/drivers/spi/spi-ep93xx.c
@@ -1104,6 +1104,7 @@ static int ep93xx_spi_probe(struct platform_device *pdev)
 	espi->wq = create_singlethread_workqueue("ep93xx_spid");
 	if (!espi->wq) {
 		dev_err(&pdev->dev, "unable to create workqueue\n");
+		error = -ENOMEM;
 		goto fail_free_dma;
 	}
 	INIT_WORK(&espi->msg_work, ep93xx_spi_work);

