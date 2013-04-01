Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758287Ab3DAJuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 05:50:18 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:48039 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757714Ab3DAJuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 05:50:13 -0400
X-AuditID: cbfee690-b7f656d0000007e3-05-51595854a43e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
In-reply-to: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
Subject: [PATCH 25/27] rtc: rtc-sa1100: use devm_*() functions
Date: Mon, 01 Apr 2013 18:50:12 +0900
Message-id: <002401ce2ebe$4db38e40$e91aaac0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4uvSmu8Ej3RSKpRZmzfFm2iz9KEwAARjeA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zA92QiMhAg6ezFS2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKODlxFXPBV76Kqas3MTYwLuLpYuTkkBAwkXjzdhsThC0mceHeerYuRi4OIYFljBI7
	Zl5ihyk6+bGdGSKxiFHi+YLbrBDOL0aJvb+bwdrZBNQkvnw5DNTBwSEioC/R1qIBUsMs0Mso
	caZ3N9gkIQFbiR9nvzOD2JwCdhJvFs5jBLGFgewz608ygvSyCKhKNB30AAnzApVvWPuSCcIW
	lPgx+R4LiM0soCWxfudxJghbXmLzmrfMIK0SAuoSj/7qgoRFBIwkLm54DlUiIrHvxTtGkHMk
	BO6xS7S9/AY2h0VAQOLb5EMsEL2yEpsOMEP8KylxcMUNlgmMErOQbJ6FZPMsJJtnIVmxgJFl
	FaNoakFyQXFSepGJXnFibnFpXrpecn7uJkZIpE7YwXjvgPUhxmSg9ROZpUST84GRnlcSb2hs
	ZmRhamJqbGRuaUaasJI4r3qLdaCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxvy9hzf/SBTR
	mSjwy6j5mI9RkTdz5PXOQ7eCtyyXvZ5ntkjt+CfWF1vqHpSfXnmrJN6CcWFR9o7ti372RYS8
	i5xq3vBeZlbTzCk+376lJdtun/PvfLh+ZnVA/NQ+no/HQ8ScGa3eN0s/uzrlX5nuFMvLNupf
	rr5zuZJ19mrh5Sdqt2S/LmsOTlNiKc5INNRiLipOBAAwkzFe6gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jAd2QiMhAg60TZS2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzDg5cRVzwVe+iqmrNzE2MC7i6WLk5JAQMJE4
	+bGdGcIWk7hwbz1bFyMXh5DAIkaJ5wtus0I4vxgl9v5uZgKpYhNQk/jy5TB7FyMHh4iAvkRb
	iwZIDbNAL6PEmd7d7CA1QgK2Ej/OfgebyilgJ/Fm4TxGEFsYyD6z/iQjSC+LgKpE00EPkDAv
	UPmGtS+ZIGxBiR+T77GA2MwCWhLrdx5ngrDlJTavecsM0iohoC7x6K8uSFhEwEji4obnUCUi
	EvtevGOcwCg0C8mkWUgmzUIyaRaSlgWMLKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgtPA
	M+kdjKsaLA4xCnAwKvHwRlyICBRiTSwrrsw9xCjBwawkwuvzDSjEm5JYWZValB9fVJqTWnyI
	MRnoz4nMUqLJ+cAUlVcSb2hsYmZkaWRmYWRibk6asJI478FW60AhgfTEktTs1NSC1CKYLUwc
	nFINjNbrFxzwWvrCKHfJRv2QiYcb+ty6ORbaOHyfr5uX6MZd5KDcsFhMS/OioZrDEf5bgTqC
	n4Wm/63/83PWgyc2Lxc5H7uy+Z/gusoss/n/LeJf5zy6JnSwa3Oh/rv+3CXz/j0vXWwtwt1+
	vrz/7hG3x4tt1K3aXH+YJ34/sdig19mA0ypiCduMF0osxRmJhlrMRcWJAM8Xu89HAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-sa1100.c |   17 +++++------------
 1 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/drivers/rtc/rtc-sa1100.c b/drivers/rtc/rtc-sa1100.c
index 7e0a088..0060560 100644
--- a/drivers/rtc/rtc-sa1100.c
+++ b/drivers/rtc/rtc-sa1100.c
@@ -234,14 +234,13 @@ static int sa1100_rtc_probe(struct platform_device *pdev)
 	if (irq_1hz < 0 || irq_alarm < 0)
 		return -ENODEV;
 
-	info = kzalloc(sizeof(struct sa1100_rtc), GFP_KERNEL);
+	info = devm_kzalloc(&pdev->dev, sizeof(struct sa1100_rtc), GFP_KERNEL);
 	if (!info)
 		return -ENOMEM;
-	info->clk = clk_get(&pdev->dev, NULL);
+	info->clk = devm_clk_get(&pdev->dev, NULL);
 	if (IS_ERR(info->clk)) {
 		dev_err(&pdev->dev, "failed to find rtc clock source\n");
-		ret = PTR_ERR(info->clk);
-		goto err_clk;
+		return PTR_ERR(info->clk);
 	}
 	info->irq_1hz = irq_1hz;
 	info->irq_alarm = irq_alarm;
@@ -268,8 +267,8 @@ static int sa1100_rtc_probe(struct platform_device *pdev)
 
 	device_init_wakeup(&pdev->dev, 1);
 
-	rtc = rtc_device_register(pdev->name, &pdev->dev, &sa1100_rtc_ops,
-		THIS_MODULE);
+	rtc = devm_rtc_device_register(&pdev->dev, pdev->name, &sa1100_rtc_ops,
+					THIS_MODULE);
 
 	if (IS_ERR(rtc)) {
 		ret = PTR_ERR(rtc);
@@ -306,9 +305,6 @@ err_dev:
 	clk_disable_unprepare(info->clk);
 err_enable_clk:
 	platform_set_drvdata(pdev, NULL);
-	clk_put(info->clk);
-err_clk:
-	kfree(info);
 	return ret;
 }
 
@@ -317,11 +313,8 @@ static int sa1100_rtc_remove(struct platform_device *pdev)
 	struct sa1100_rtc *info = platform_get_drvdata(pdev);
 
 	if (info) {
-		rtc_device_unregister(info->rtc);
 		clk_disable_unprepare(info->clk);
-		clk_put(info->clk);
 		platform_set_drvdata(pdev, NULL);
-		kfree(info);
 	}
 
 	return 0;
-- 
1.7.2.5


