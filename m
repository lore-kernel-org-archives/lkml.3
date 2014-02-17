Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154AbaBQJpo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:45:44 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:29241 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbaBQJp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:45:26 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-85-5301da2eadfe
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, davem@davemloft.net
Subject: [PATCH 8/9 v7] crypto:s5p-sss: Use clk_prepare/clk_unprepare
Date: Mon, 17 Feb 2014 15:14:34 +0530
Message-id: <1392630275-8667-9-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392630275-8667-1-git-send-email-ch.naveen@samsung.com>
References: <1392630275-8667-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsWyRsSkWlfvFmOwwb1dhhYvD2lazDnfwmLR
	/UrG4v69n0wWl3fNYbOYcX4fk8Wibf+ZLc7OOcTkwOGxZeVNJo+ds+6ye2w7oOrRt2UVo8fn
	TXIBrFFcNimpOZllqUX6dglcGe93GxY85a7YeWgKewPjG84uRk4OCQETiTkvnzFC2GISF+6t
	Z+ti5OIQEljKKHHj1ldmmKJDfy6xQCQWMUqcbeuDcvqZJFoP7QJrZxMwkzi4aDU7iC0i4Czx
	u3kNK0gRs8AsRonZ9z+BFQkLuEpcPnyCqYuRg4NFQFVixyYLkDCvgIvE+V1NLCBhCQEFiTmT
	bEDCnEDVnXe2s4DYQkAl6zohjpAQWMQu8XHVKTaQBIuAgMS3yYegemUlNh2AOlpS4uCKGywT
	GIUXMDKsYhRNLUguKE5KLzLVK07MLS7NS9dLzs/dxAgM9NP/nk3cwXj/gPUhxmSgcROZpUST
	84GRklcSb2hsZmRhamJqbGRuaUaasJI4b/qjpCAhgfTEktTs1NSC1KL4otKc1OJDjEwcnFIN
	jG5XArcLhtzM35d8ebJoilDJ64zkF3/+5M4+NveW52uvqxGt9vsbCy7zsW4/IrdLyMCwh+Pd
	ncpvP6/FVQQVfEsBpoywCzJ7ZIKXNzu9Pf9lX+HyLexbk/XrpEqvLeZy38N6LIbv/yq92Ebu
	1Fc7UtdqazdzGWuVndqzXUpn3zypKksDl+NuSizFGYmGWsxFxYkAiNeCmooCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t9jAV29W4zBBsv/alq8PKRpMed8C4tF
	9ysZi/v3fjJZXN41h81ixvl9TBaLtv1ntjg75xCTA4fHlpU3mTx2zrrL7rHtgKpH35ZVjB6f
	N8kFsEY1MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXm
	AF2ipFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYcx4v9uw4Cl3xc5DU9gb
	GN9wdjFyckgImEgc+nOJBcIWk7hwbz1bFyMXh5DAIkaJs219LBBOP5NE66FdjCBVbAJmEgcX
	rWYHsUUEnCV+N69hBSliFpjFKDH7/iewImEBV4nLh08wdTFycLAIqErs2GQBEuYVcJE4v6uJ
	BSQsIaAgMWeSDUiYE6i68852sCOEgErWdV5imcDIu4CRYRWjaGpBckFxUnquoV5xYm5xaV66
	XnJ+7iZGcBw9k9rBuLLB4hCjAAejEg+vQTVjsBBrYllxZe4hRgkOZiURXtt1QCHelMTKqtSi
	/Pii0pzU4kOMyUA3TWSWEk3OB8Z4Xkm8obGJuamxqaWJhYmZJWnCSuK8B1qtA4UE0hNLUrNT
	UwtSi2C2MHFwSjUwSs6aLuBx9uSbrN8Tnqm7L/96vXf65exlRY3H5dbvXPuLUelQ3GJP/4cq
	X1Q1jLkPaTUFvZ3F5Dy3jiWj0q1zq/L1zZFt2dHz/n7+6zrl2frKNg0/m5hnJxbpr+SPvuby
	mv2h4uHtnir3T2/nY/kYlxvBHeYndNrswZ3Nl9/uW9FUaPzGgkXiuRJLcUaioRZzUXEiAJP8
	a3nnAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set adds use of clk_prepare/clk_unprepare as
required by generic clock framework.

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>
CC: David S. Miller <davem@davemloft.net>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
TO: <linux-crypto@vger.kernel.org>
CC: <linux-samsung-soc@vger.kernel.org>
---
Changes since v6:
None

 drivers/crypto/s5p-sss.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 7da1da4..429b4c1 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -648,7 +648,11 @@ static int s5p_aes_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	clk_enable(pdata->clk);
+	err = clk_prepare_enable(pdata->clk);
+	if (err < 0) {
+		dev_err(dev, "Enabling SSS clk failed, err %d\n", err);
+		return err;
+	}
 
 	spin_lock_init(&pdata->lock);
 	pdata->ioaddr = devm_ioremap(dev, res->start,
@@ -711,7 +715,7 @@ static int s5p_aes_probe(struct platform_device *pdev)
 	tasklet_kill(&pdata->tasklet);
 
  err_irq:
-	clk_disable(pdata->clk);
+	clk_disable_unprepare(pdata->clk);
 
 	s5p_dev = NULL;
 
@@ -731,7 +735,7 @@ static int s5p_aes_remove(struct platform_device *pdev)
 
 	tasklet_kill(&pdata->tasklet);
 
-	clk_disable(pdata->clk);
+	clk_disable_unprepare(pdata->clk);
 
 	s5p_dev = NULL;
 
-- 
1.7.9.5

