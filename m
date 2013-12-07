Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866Ab3LGGDD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 01:03:03 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:42311 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab3LGGDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 01:03:02 -0500
MIME-Version: 1.0
Date: Sat, 7 Dec 2013 14:03:00 +0800
Message-ID: <CAPgLHd88PwtNx0mjdzGe1K+uFafpxQwZhfDiJNfXPcBCKFA1Bg@mail.gmail.com>
Subject: [PATCH -next] mfd: sta2x11-mfd: fix return value check in sta2x11_mfd_platform_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: sameo@linux.intel.com, lee.jones@linaro.org
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function devm_regmap_init_mmio() returns
ERR_PTR() and never returns NULL. The NULL test in the return
value check should be replaced with IS_ERR().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/mfd/sta2x11-mfd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/sta2x11-mfd.c b/drivers/mfd/sta2x11-mfd.c
index 53ab686..0d42e40 100644
--- a/drivers/mfd/sta2x11-mfd.c
+++ b/drivers/mfd/sta2x11-mfd.c
@@ -339,7 +339,7 @@ static int sta2x11_mfd_platform_probe(struct platform_device *dev,
 	regmap_config->cache_type = REGCACHE_NONE;
 	mfd->regmap[index] = devm_regmap_init_mmio(&dev->dev, mfd->regs[index],
 						   regmap_config);
-	WARN_ON(!mfd->regmap[index]);
+	WARN_ON(IS_ERR(mfd->regmap[index]));
 
 	return 0;
 }

