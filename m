Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538AbaBGF04 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 00:26:56 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:41398 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbaBGF0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 00:26:54 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-48-52f46e9c6390
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com
Subject: [PATCH 8/9 v6] crypto:s5p-sss: Use clk_prepare/clk_unprepare
Date: Fri, 07 Feb 2014 10:56:36 +0530
Message-id: <1391750796-27528-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1389354331-32142-1-git-send-email-ch.naveen@samsung.com>
References: <1389354331-32142-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsWyRsSkSndO3pcgg4a5ZhYvD2ladL+Ssbh/
	7yeTxeVdc9gsZpzfx2SxaNt/Zouzcw4xObB77Jx1l91j2wFVj74tqxg9Pm+SC2CJ4rJJSc3J
	LEst0rdL4MrYeXQec8EErorFe5exNjCu5ehi5OSQEDCReDrxDjuELSZx4d56NhBbSGApo8TS
	3ckwNcvfNjF1MXIBxRcxSmxc9RjK6WeSuN1yFKybTcBM4uCi1WC2iICzxO/mNawgNrNAM6PE
	j9lANgeHsICrxLwWsAUsAqoSV98tYAaxeYHCPy6dYgQpkRBQkJgzyQYkzCngJnF/xisWiHtc
	JR5OncAKslZCoJ9doq/vCwvEHAGJb5MPsUD0ykpsOsAMcbOkxMEVN1gmMAovYGRYxSiaWpBc
	UJyUXmSqV5yYW1yal66XnJ+7iREY0qf/PZu4g/H+AetDjMlA4yYyS4km5wNjIq8k3tDYzMjC
	1MTU2Mjc0ow0YSVx3vRHSUFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGMPj5pv+vjyteFPI
	fDXm0xXbOfUrnjt/3HvrbanVmjR93WMHUx/wGu8w/Xs88catJ98ErDo/ssxukj3Cu3qH6t40
	2TO/Qm4sYVboyE+MNlO8lnX2WA/LiSvbDbZF/p9bUHczbKZxgp5xp8/RaR0tL+92+wVGzzjZ
	UiXuJ5A4rTd8c13+nvC0ICWW4oxEQy3mouJEAL3eYHF/AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t9jAd05eV+CDJYc0rd4eUjTovuVjMX9
	ez+ZLC7vmsNmMeP8PiaLRdv+M1ucnXOIyYHdY+esu+we2w6oevRtWcXo8XmTXABLVAOjTUZq
	YkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QfiWFssScUqBQ
	QGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYQ1jxs6j85gLJnBVLN67jLWBcS1HFyMnh4SA
	icTyt01MELaYxIV769m6GLk4hAQWMUpsXPWYCcLpZ5K43XKUHaSKTcBM4uCi1WC2iICzxO/m
	NawgNrNAM6PEj9lANgeHsICrxLwWNpAwi4CqxNV3C5hBbF6g8I9LpxhBSiQEFCTmTLIBCXMK
	uEncn/GKBcQWAip5OHUC6wRG3gWMDKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgmPmmdQO
	xpUNFocYBTgYlXh4Tyz9HCTEmlhWXJl7iFGCg1lJhJc74UuQEG9KYmVValF+fFFpTmrxIcZk
	oKMmMkuJJucD4zmvJN7Q2MTc1NjU0sTCxMySNGElcd4DrdaBQgLpiSWp2ampBalFMFuYODil
	GhgPp+WHTnY6MyvDLfpiwPF4A2NWE3cvoUVxOb6iUzLv5lhfe6ig5fCW50ncRTNmgbh4BoPU
	njg98WVvwhduzgm3ZJjX3HP8DWfvO2MdCY+QLLY3zGynvOTj3t85LslbfXmH16yQ5sXv64uT
	rtwr3iBWt7REyePxn+D9m9QOqP/bU7NAynR2jBJLcUaioRZzUXEiAA79fFLdAgAA
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
---
changes since v5:
None

 drivers/crypto/s5p-sss.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index a890273..d35a477 100644
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

