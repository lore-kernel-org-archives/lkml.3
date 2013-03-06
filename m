Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423Ab3CFFc5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 00:32:57 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:16989 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732Ab3CFFcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 00:32:55 -0500
X-AuditID: cbfee68d-b7f636d0000009be-f5-5136d506e772
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
In-reply-to: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
Subject: [PATCH 17/30] rtc: rtc-mxc: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 14:32:54 +0900
Message-id: <005301ce1a2c$0d5d61f0$281825d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aKzqYzbgO1ZcaTfGsrpjfTnOAiQAAMggw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t8zfV22q2aBBquWGFosuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CV8bm5n7HgDXtFx86DTA2Mx9i6GDk5JARMJDqO7WaFsMUkLtxbDxTn4hASWMYocal1
	CTtM0d/L51kgEtMZJe5dWM0I4fxilLj/+AQTSBWbgJrEly+HgTo4OEQE9CXaWjRAapgFehkl
	zvTuBpskJGArcbV7FTOIzSlgJ7H88SwWEFtYwFni2YXDYCexCKhKbH1/hhHE5gWqn3/zNSuE
	LSjxY/I9sHpmAS2J9TuPM0HY8hKb17xlBtkrIaAu8eivLkhYRMBI4m3PQlaIEhGJfS/egd0s
	IfCIXWLW9DtMELsEJL5NPsQC0SsrsekAM8TDkhIHV9xgmcAoMQvJ5llINs9CsnkWkhULGFlW
	MYqmFiQXFCelFxnqFSfmFpfmpesl5+duYoTEau8OxtsHrA8xJgOtn8gsJZqcD4z1vJJ4Q2Nj
	EzMTUxNzS1NzU9KElcR55S7JBAoJpCeWpGanphakFsUXleakFh9iZOLglGpgPHA06+zuj1tv
	2posuJaa+sWI/329gUf5h3Lvv4dW1PbN0V4bm1zQ6xzwjUMq+1+t2q48td/b/t18IzfD/FC3
	qYiRZ6zqYWtr71uTtkocMnpTeu52YP3k3IeTXhXeuvtv+8cY1jOSExeL2Z6bMclyY8EzE5d3
	s7RyTASttEtnfK0qucts5q3Lq8RSnJFoqMVcVJwIAK4Jp8/rAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jQV22q2aBBtu6dS2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzPjc3M9Y8Ia9omPnQaYGxmNsXYycHBICJhJ/
	L59ngbDFJC7cWw8U5+IQEpjOKHHvwmpGCOcXo8T9xyeYQKrYBNQkvnw5zN7FyMEhIqAv0dai
	AVLDLNDLKHGmdzc7SI2QgK3E1e5VzCA2p4CdxPLHs8A2CAs4Szy7cBhsM4uAqsTW92cYQWxe
	oPr5N1+zQtiCEj8m3wOrZxbQkli/8zgThC0vsXnNW2aQvRIC6hKP/uqChEUEjCTe9ixkhSgR
	kdj34h3jBEahWUgmzUIyaRaSSbOQtCxgZFnFKJpakFxQnJSea6hXnJhbXJqXrpecn7uJEZwI
	nkntYFzZYHGIUYCDUYmH10LJLFCINbGsuDL3EKMEB7OSCC/XGaAQb0piZVVqUX58UWlOavEh
	xmSgRycyS4km5wOTVF5JvKGxiZmRpZGZhZGJuTlpwkrivIynngQICaQnlqRmp6YWpBbBbGHi
	4JRqYDRx2HTzWmDSttdbBa8F83G8dpq4fMcbhX3cmn7asWfTlI6997m2SL3i6UXtz3Pb230Z
	qtMueFXOchHtvy9v8Gq/8/ZwS+3DRuvaCv9+S/5/W7Uu1OT139iF+bG7WkVz1xg9/fEhSMKg
	6lPIrY079ohbzur6pfNvmuXJ+5l7uvgMOTl+vV/7q1uJpTgj0VCLuag4EQBB4QGVSAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devm_rtc_device_register() is device managed and makes cleanup
paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-mxc.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-mxc.c b/drivers/rtc/rtc-mxc.c
index 1c3ef72..9569526 100644
--- a/drivers/rtc/rtc-mxc.c
+++ b/drivers/rtc/rtc-mxc.c
@@ -439,7 +439,7 @@ static int mxc_rtc_probe(struct platform_device *pdev)
 	if (pdata->irq >=0)
 		device_init_wakeup(&pdev->dev, 1);
 
-	rtc = rtc_device_register(pdev->name, &pdev->dev, &mxc_rtc_ops,
+	rtc = devm_rtc_device_register(pdev->name, &pdev->dev, &mxc_rtc_ops,
 				  THIS_MODULE);
 	if (IS_ERR(rtc)) {
 		ret = PTR_ERR(rtc);
@@ -464,8 +464,6 @@ static int mxc_rtc_remove(struct platform_device *pdev)
 {
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
-	rtc_device_unregister(pdata->rtc);
-
 	clk_disable_unprepare(pdata->clk);
 	platform_set_drvdata(pdev, NULL);
 
-- 
1.7.2.5


