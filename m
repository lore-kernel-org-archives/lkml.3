Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab3EBFvI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 01:51:08 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:47527 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab3EBFvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 01:51:03 -0400
X-AuditID: cbfee690-b7f136d000000fea-cc-5181fec6c040
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Wim Van Sebroeck'" <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, "'Guenter Roeck'" <linux@roeck-us.net>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH RESEND 3/7] watchdog: mv64x60_wdt: use devm_ioremap()
Date: Thu, 02 May 2013 14:51:01 +0900
Message-id: <000601ce46f9$072aa780$157ff680$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5G+QF6SAiSM+VCQTOFRqlrESSs4A==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsVy+t8zA91j/xoDDRbMELKYs34Nm8XlhZdY
	LS7vmsNmcWPdPnaLJwvPMFncmvGC1YHN49pmMY8TM36zeOz83sDu0bdlFaPH501yAaxRXDYp
	qTmZZalF+nYJXBnNXzwKvrBV7DhyiaWB8R5rFyMnh4SAicSz1efZIWwxiQv31rN1MXJxCAks
	Y5Q4e+EkI0zRmk/fmSES0xkl1mx9zQ7h/GKUWPRuLlg7m4CaxJcvh4FsDg4RAX2JthYNkBpm
	gQ2MEif//wWrERZwlVj6ZiMjSA2LgKrEjdMcIGFeAUuJxf8Os0LYghI/Jt9jAbGZBbQk1u88
	zgRhy0tsXvOWGeIgBYkdZ18zQqzSk9i/2wuiRERi34t3jCBrJQSOsUscP7sMrJ5FQEDi2+RD
	LCD1EgKyEpsOQI2RlDi44gbLBEaxWUg2z0KyeRaSzbOQrFjAyLKKUTS1ILmgOCm9yESvODG3
	uDQvXS85P3cTIyT+JuxgvHfA+hBjMtD6icxSosn5wPjNK4k3NDYzsjA1MTU2Mrc0I01YSZxX
	vcU6UEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAPjlPBZWiuvpT/V/KBX5/xBQL3h3qylNcf6
	v1ZctTBT2ckvWb3Qf6pN/zy/FwIrF03Y3CKm7Pjbm/VkynX//JOZ0i0ZqruU1F8tPeTV+3Zh
	6sOcxSG/Gqw23GKKXOTtMfUYs9CGvdOC3t9V2CubYa0ZGZP8+lqhWpFhXNa3krsHLSu4I2SD
	hKqVWIozEg21mIuKEwHzaSF/1QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPKsWRmVeSWpSXmKPExsVy+t9jQd1j/xoDDX5947WYs34Nm8XlhZdY
	LS7vmsNmcWPdPnaLJwvPMFncmvGC1YHN49pmMY8TM36zeOz83sDu0bdlFaPH501yAaxRDYw2
	GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUAXKCmUJeaU
	AoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzmr94FHxhq9hx5BJLA+M91i5GTg4J
	AROJNZ++M0PYYhIX7q1n62Lk4hASmM4osWbra3YI5xejxKJ3c9lBqtgE1CS+fDkMZHNwiAjo
	S7S1aIDUMAtsYJQ4+f8vWI2wgKvE0jcbGUFqWARUJW6c5gAJ8wpYSiz+d5gVwhaU+DH5HguI
	zSygJbF+53EmCFteYvOat1AHKUjsOPuaEWKVnsT+3V4QJSIS+168Y5zAKDALyaRZSCbNQjJp
	FpKWBYwsqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCo/uZ9A7GVQ0WhxgFOBiVeHg/6DYG
	CrEmlhVX5h5ilOBgVhLhXfAaKMSbklhZlVqUH19UmpNafIgxGejPicxSosn5wMSTVxJvaGxi
	ZmRpZGZhZGJuTpqwkjjvwVbrQCGB9MSS1OzU1ILUIpgtTBycUg2MRdnPFHqT7u2z0axMz5ze
	wDMp+cdXhq/rhThOOP9O+h72OyBecvpXtiyOjO31bTZRTvfVU+Y3bnbXO7IidSmvnlQTd/Gc
	5+p/W4ruxCdZvhNXKpynZfY63m2Lv/JuRt43P/j+3P5aVqS/4SPzjw3hHDltxwIdjoQW6LeG
	PU7xldJ+oLz8IqsSS3FGoqEWc1FxIgDk4fboMgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_ioremap() to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/watchdog/mv64x60_wdt.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/watchdog/mv64x60_wdt.c b/drivers/watchdog/mv64x60_wdt.c
index c7fb878..e4cf980 100644
--- a/drivers/watchdog/mv64x60_wdt.c
+++ b/drivers/watchdog/mv64x60_wdt.c
@@ -276,7 +276,7 @@ static int mv64x60_wdt_probe(struct platform_device *dev)
 	if (!r)
 		return -ENODEV;
 
-	mv64x60_wdt_regs = ioremap(r->start, resource_size(r));
+	mv64x60_wdt_regs = devm_ioremap(&dev->dev, r->start, resource_size(r));
 	if (mv64x60_wdt_regs == NULL)
 		return -ENOMEM;
 
@@ -293,8 +293,6 @@ static int mv64x60_wdt_remove(struct platform_device *dev)
 
 	mv64x60_wdt_handler_disable();
 
-	iounmap(mv64x60_wdt_regs);
-
 	return 0;
 }
 
-- 
1.7.2.5


