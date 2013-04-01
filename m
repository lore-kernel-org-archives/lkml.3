Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759019Ab3DAJtV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 05:49:21 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:58622 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758213Ab3DAJtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 05:49:19 -0400
X-AuditID: cbfee690-b7f656d0000007e3-f4-5159581e0861
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
In-reply-to: <000c01ce2ebd$2a1307f0$7e3917d0$%han@samsung.com>
Subject: [PATCH 22/27] rtc: rtc-rs5c348: use devm_*() functions
Date: Mon, 01 Apr 2013 18:49:17 +0900
Message-id: <002101ce2ebe$2d2fe2e0$878fa8a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4uvSmu8Ej3RSKpRZmzfFm2iz9KEwAAPjqA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zfV25iMhAgxOnRC2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKWDL/EnvBfu6KP22/GRsYt3F2MXJySAiYSMw9co0RwhaTuHBvPVsXIxeHkMAyRomP
	+96xwhQtvrqaGSKxiFFiYs9/JpCEkMAvRomfra4gNpuAmsSXL4fZuxg5OEQE9CXaWjRA6pkF
	ehklzvTuZoeot5X4cfY7M4jNKWAn8WbhPEaQemEBe4nmL7UgYRYBVYn7n5aDjecFKm85sJ0F
	whaU+DH5HpjNLKAlsX7ncSYIW15i85q3zCBjJATUJR791QUJiwgYSZy/vZQVokREYt+Ld4wg
	50gI3GOX6P+znwVil4DEt8mHWCB6ZSU2HWCGeFdS4uCKGywTGCVmIdk8C8nmWUg2z0KyYgEj
	yypG0dSC5ILipPQiE73ixNzi0rx0veT83E2MkDidsIPx3gHrQ4zJQOsnMkuJJucD4zyvJN7Q
	2MzIwtTE1NjI3NKMNGElcV71FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYxy5ReyOU8s
	CEppmH780csDhwWUfAuiNNXV5nDd6oy1OORpvPz4K35z08LjPi+yvQWfTe8QuBfxyv+hDdMD
	g3uzTihtS/L4/sjtTi/X690rej6cFc5KNd0Z7H9tNo8Z1/s3E/lm7Em5OFfA8LVd0Im++h8J
	ttYBlwJPHZqoVeD5MSprw/HCP7eVWIozEg21mIuKEwFisliw6QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jAV25iMhAg72rBS2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzFgy/xJ7wX7uij9tvxkbGLdxdjFyckgImEgs
	vrqaGcIWk7hwbz1bFyMXh5DAIkaJiT3/mUASQgK/GCV+trqC2GwCahJfvhxm72Lk4BAR0Jdo
	a9EAqWcW6GWUONO7mx2i3lbix9nvYEM5Bewk3iycxwhSLyxgL9H8pRYkzCKgKnH/03Kw8bxA
	5S0HtrNA2IISPybfA7OZBbQk1u88zgRhy0tsXvOWGWSMhIC6xKO/uiBhEQEjifO3l7JClIhI
	7HvxjnECo9AsJJNmIZk0C8mkWUhaFjCyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQITgLP
	pHcwrmqwOMQowMGoxMMbcSEiUIg1say4MvcQowQHs5IIr883oBBvSmJlVWpRfnxRaU5q8SHG
	ZKBHJzJLiSbnAxNUXkm8obGJmZGlkZmFkYm5OWnCSuK8B1utA4UE0hNLUrNTUwtSi2C2MHFw
	SjUwxjX4nT5W/0Te0sgqudKxZWviWRk38dXP9t24o39MtNBg75spBo25LKUeT1YqhaxLyFv/
	6W0n14T8o/si+/dsn/Dya9v9m7r7Fh4J/FBo4ftYrsBrz9UTFT1ccsHxmaUBP9NWS2rW8W84
	dT3VetuS3UmXT3gW99z55uTMfk/sm3/l1NWnvnrcVGIpzkg01GIuKk4EAPHY1SBGAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-rs5c348.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/rtc/rtc-rs5c348.c b/drivers/rtc/rtc-rs5c348.c
index 72ef10b..2c37df3 100644
--- a/drivers/rtc/rtc-rs5c348.c
+++ b/drivers/rtc/rtc-rs5c348.c
@@ -158,7 +158,8 @@ static int rs5c348_probe(struct spi_device *spi)
 	struct rtc_device *rtc;
 	struct rs5c348_plat_data *pdata;
 
-	pdata = kzalloc(sizeof(struct rs5c348_plat_data), GFP_KERNEL);
+	pdata = devm_kzalloc(&spi->dev, sizeof(struct rs5c348_plat_data),
+				GFP_KERNEL);
 	if (!pdata)
 		return -ENOMEM;
 	spi->dev.platform_data = pdata;
@@ -202,7 +203,7 @@ static int rs5c348_probe(struct spi_device *spi)
 	if (ret & RS5C348_BIT_24H)
 		pdata->rtc_24h = 1;
 
-	rtc = rtc_device_register(rs5c348_driver.driver.name, &spi->dev,
+	rtc = devm_rtc_device_register(&spi->dev, rs5c348_driver.driver.name,
 				  &rs5c348_rtc_ops, THIS_MODULE);
 
 	if (IS_ERR(rtc)) {
@@ -214,18 +215,11 @@ static int rs5c348_probe(struct spi_device *spi)
 
 	return 0;
  kfree_exit:
-	kfree(pdata);
 	return ret;
 }
 
 static int rs5c348_remove(struct spi_device *spi)
 {
-	struct rs5c348_plat_data *pdata = spi->dev.platform_data;
-	struct rtc_device *rtc = pdata->rtc;
-
-	if (rtc)
-		rtc_device_unregister(rtc);
-	kfree(pdata);
 	return 0;
 }
 
-- 
1.7.2.5


