Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab3IKLUk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 07:20:40 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:63050 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608Ab3IKLUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 07:20:38 -0400
MIME-Version: 1.0
Date: Wed, 11 Sep 2013 19:20:37 +0800
Message-ID: <CAPgLHd-xMHXoC6Qe1n3rBo+rZ6WK6nwz+zU82yBoA8z=M2o8AA@mail.gmail.com>
Subject: [PATCH] MFD: ucb1x00-core: fix error return code in ucb1x00_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: sameo@linux.intel.com, lee.jones@linaro.org
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code in the irq alloc error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/mfd/ucb1x00-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mfd/ucb1x00-core.c b/drivers/mfd/ucb1x00-core.c
index b7cf98f..10f2e8d 100644
--- a/drivers/mfd/ucb1x00-core.c
+++ b/drivers/mfd/ucb1x00-core.c
@@ -551,6 +551,7 @@ static int ucb1x00_probe(struct mcp *mcp)
 	if (ucb->irq_base < 0) {
 		dev_err(&ucb->dev, "unable to allocate 16 irqs: %d\n",
 			ucb->irq_base);
+		ret = ucb->irq_base;
 		goto err_irq_alloc;
 	}
 

