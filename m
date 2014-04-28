Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbaD1Krl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 06:47:41 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:64391 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216AbaD1KrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 06:47:11 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-cc-535e31aa736c
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
        herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
        cpgs@samsung.com, t.figa@samsung.com, davem@davemloft.net
Subject: [PATCH 6/7 v8] crypto:s5p-sss: Use clk_prepare/clk_unprepare
Date: Mon, 28 Apr 2014 16:14:58 +0530
Message-id: <1398681899-20782-7-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398681899-20782-1-git-send-email-ch.naveen@samsung.com>
References: <1398681899-20782-1-git-send-email-ch.naveen@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDLMWRmVeSWpSXmKPExsWyRsSkWne1YVywwfq/LBYvD2lazDnfwmLR
	/UrG4v69n0wWl3fNYbOYcX4fk8Wibf+ZLdbPeM1icXbOISYHTo8tK28yeeycdZfdY9sBVY++
	LasYPT5vkgtgjeKySUnNySxLLdK3S+DKWHvoIkvBB+6KfcdusjcwfuTsYuTkkBAwkTh68gsL
	hC0mceHeerYuRi4OIYGljBJH7l5igSn6fGYOVGI6o0TrpC3sIAkhgX4mifdPU0FsNgEziYOL
	VoPFRQScJX43r2EFaWAWWMco8enNYSaQhLCAq8TN97tYQWwWAVWJCbvPg9m8QPHHt48D2RxA
	2xQk5kyyAQlzCrhJXF1/jhFil6vE0t4fzBAHrWKXmHEqBGKMgMS3yYdYIFplJTYdgCqRlDi4
	4gbLBEbhBYwMqxhFUwuSC4qT0ouM9YoTc4tL89L1kvNzNzECQ/70v2f9OxjvHrA+xJgMNG4i
	s5Rocj4wZvJK4g2NzYwsTE1MjY3MLc1IE1YS573/MClISCA9sSQ1OzW1ILUovqg0J7X4ECMT
	B6dUA+PhZTHXtbk2LgvwXcVmNyfPLUIrSr/ZetKpjsmrOJ4bf+a/tJhV8HnloZ/Mq19r7D67
	71fL6ZyU5b+61VyeZspFvz/w9Hyf7X6T1mmz3msG8nVNlDo+dWfUDf0LzEdVQub1Wd2u46hr
	W7+zLE3v1+MYp2uVc7vDXQwqT4foeiw4VxHerMRWn6XEUpyRaKjFXFScCABg9QMLjwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFIsWRmVeSWpSXmKPExsVy+t9jQd1VhnHBBocvWFm8PKRpMed8C4tF
	9ysZi/v3fjJZXN41h81ixvl9TBaLtv1ntlg/4zWLxdk5h5gcOD22rLzJ5LFz1l12j20HVD36
	tqxi9Pi8SS6ANaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfVVsnF
	J0DXLTMH6BwlhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGENY8baQxdZCj5w
	V+w7dpO9gfEjZxcjJ4eEgInE5zNz2CBsMYkL99YD2VwcQgLTGSVaJ21hB0kICfQzSbx/mgpi
	swmYSRxctBosLiLgLPG7eQ0rSAOzwDpGiU9vDjOBJIQFXCVuvt/FCmKzCKhKTNh9HszmBYo/
	vn0cyOYA2qYgMWeSDUiYU8BN4ur6c4wQu1wllvb+YJ7AyLuAkWEVo2hqQXJBcVJ6rpFecWJu
	cWleul5yfu4mRnBMPZPewbiqweIQowAHoxIPb8Sc2GAh1sSy4srcQ4wSHMxKIrz7JeKChXhT
	EiurUovy44tKc1KLDzEmAx01kVlKNDkfGO95JfGGxibmpsamliYWJmaWpAkrifMebLUOFBJI
	TyxJzU5NLUgtgtnCxMEp1cA447DdHPPX6RutdT4ePD9nn1vzBTOhVQ8apxZ+MhK22jAj6lYQ
	u5s4S5zSnkeqok/NonvDxE3ebr+dO62NNbH0YGFU3teaXRnaaVXvkwxO/TT+LHr9df7lGd0z
	PvkEPHq/cor8rNuzg30io8LUbT8uufaVMehxe8atz24n7/74Masz1Lc17T67EktxRqKhFnNR
	cSIAiwPKRe0CAAA=
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
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
CC: David S. Miller <davem@davemloft.net>
CC: Vladimir Zapolskiy <vzapolskiy@gmail.com>
TO: <linux-crypto@vger.kernel.org>
CC: <linux-samsung-soc@vger.kernel.org>
---
Changes since v7:
Added Acked-by from Herbert Xu
Changes since v6:
None

 drivers/crypto/s5p-sss.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 0ffc042..ea7d478 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -645,7 +645,11 @@ static int s5p_aes_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	clk_enable(pdata->clk);
+	err = clk_prepare_enable(pdata->clk);
+	if (err < 0) {
+		dev_err(dev, "Enabling SSS clk failed, err %d\n", err);
+		return err;
+	}
 
 	spin_lock_init(&pdata->lock);
 
@@ -706,7 +710,7 @@ static int s5p_aes_probe(struct platform_device *pdev)
 	tasklet_kill(&pdata->tasklet);
 
  err_irq:
-	clk_disable(pdata->clk);
+	clk_disable_unprepare(pdata->clk);
 
 	s5p_dev = NULL;
 
@@ -726,7 +730,7 @@ static int s5p_aes_remove(struct platform_device *pdev)
 
 	tasklet_kill(&pdata->tasklet);
 
-	clk_disable(pdata->clk);
+	clk_disable_unprepare(pdata->clk);
 
 	s5p_dev = NULL;
 
-- 
1.7.9.5

