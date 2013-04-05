Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964801Ab3DEBrc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 21:47:32 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:45453 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185Ab3DEBrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 21:47:31 -0400
X-AuditID: cbfee68d-b7f786d000005188-fc-515e2d3140f4
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/7] rtc: rtc-rx4581: use spi_set_drvdata()
Date: Fri, 05 Apr 2013 10:47:28 +0900
Message-id: <000101ce319f$87f2a3f0$97d7ebd0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4xn4fH39zvwb7bR32L9HOXANRbig==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsVy+t8zA11D3bhAg+fzJSyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKuPL8MlPBKdaK281XGRsYz7B0MXJwSAiYSNxbq9vFyAlkiklcuLeeDcQWEljGKNF+
	PAIibiKxZ9Ep5i5GLqD4IkaJns9v2SCcX4wSjw/OAetgE1CT+PLlMDvIUBEBfYm2Fg2QGmaB
	XkaJM7272UFqhAWsJZo3TwarZxFQleg7tZ8JpJ5XwFZi370gkDCvgKDEj8n3WEBsZgEtifU7
	jzNB2PISm9e8ZYa4WV3i0V+wm0UE9CQ2TVrAClEiIrHvxTtGkLUSAqfYJb5t+Ay1SkDi2+RD
	UP/KSmw6wAzxl6TEwRU3WCYwis1CsnkWks2zkGyehWTFAkaWVYyiqQXJBcVJ6UWGesWJucWl
	eel6yfm5mxghUde7g/H2AetDjMlA6ycyS4km5wOjNq8k3tDYzMjC1MTU2Mjc0ow0YSVxXrUW
	60AhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjDECS0r1Wk5IMG2aGPgqZvOXK7M2W531zlw6
	M2Hem6XJZfn7xKp/Kk/xkD91XHPhrhkdrmVFdk1sCm8nHjb6cPrI2xkTeJyM85bOfdVXtyF9
	vrrEPauH3gcPPFaWj2IWPvJQ+9XisGMcnLku505ffmi/Ryb6Tvuxc7J1e0KOvf264UpDwvec
	qeeVWIozEg21mIuKEwF0Z/gJ0AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jAV1D3bhAg2nrhC2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzLjy/DJTwSnWitvNVxkbGM+wdDFyckgImEjs
	WXSKGcIWk7hwbz1bFyMXh5DAIkaJns9voZxfjBKPD85hA6liE1CT+PLlMHsXIweHiIC+RFuL
	BkgNs0Avo8SZ3t3sIDXCAtYSzZsng9WzCKhK9J3azwRSzytgK7HvXhBImFdAUOLH5HtgRzAL
	aEms33mcCcKWl9i85i0zSLmEgLrEo7+6IGERAT2JTZMWsEKUiEjse/GOcQKjwCwkk2YhmTQL
	yaRZSFoWMLKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAiO62fSOxhXNVgcYhTgYFTi4c3o
	iw0UYk0sK67MPcQowcGsJMK7ky8uUIg3JbGyKrUoP76oNCe1+BBjMtCfE5mlRJPzgSknryTe
	0NjEzMjSyMzCyMTcnDRhJXHeg63WgUIC6YklqdmpqQWpRTBbmDg4pRoYFedcVDq0OuNnRsrL
	8n/20gypywM4t6XwrJuoeyd+nfB6z8nZrOzZ3mrOmc7HdHhMjntUvPzqovtXn/nS/n9ZmqmH
	bsaWCCZMVeERd9bb3RrXtY3j+V8B/XeXp/+f///lmts2XCkvesJ/886SlWze+1cveMuk5v1l
	m2qz+vdrZb3q1J/JvLlciaU4I9FQi7moOBEA1RJ9Pi8DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper functions for getting and setting the driver data using
spi_device instead of using dev_{get|set}_drvdata with &spi->dev, so we
can directly pass a struct spi_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-rx4581.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-rx4581.c b/drivers/rtc/rtc-rx4581.c
index d1b88db..84eb08d 100644
--- a/drivers/rtc/rtc-rx4581.c
+++ b/drivers/rtc/rtc-rx4581.c
@@ -278,7 +278,7 @@ static int rx4581_probe(struct spi_device *spi)
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
 
-	dev_set_drvdata(&spi->dev, rtc);
+	spi_set_drvdata(spi, rtc);
 	return 0;
 }
 
-- 
1.7.2.5


