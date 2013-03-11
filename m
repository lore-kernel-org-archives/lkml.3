Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab3CKGcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 02:32:21 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:36603 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab3CKGcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 02:32:19 -0400
X-AuditID: cbfee68d-b7f786d000005188-c5-513d7a72b6ee
From: Jingoo Han <jg1.han@samsung.com>
To: "'Anton Vorontsov'" <anton@enomsg.org>
Cc: "'David Woodhouse'" <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <007101ce1e21$f39efcc0$dadcf640$%han@samsung.com>
In-reply-to: <007101ce1e21$f39efcc0$dadcf640$%han@samsung.com>
Subject: [PATCH 04/14] power: da9052-battery: use devm_kzalloc()
Date: Mon, 11 Mar 2013 15:32:18 +0900
Message-id: <007401ce1e22$2d958ca0$88c0a5e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4eIfOI6J7YtEddQ/Gjh19YaZUzVAAAC83g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t8zQ92iKttAg1k7pC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGxmWH2QqeclT82ubXwDifvYuRk0NCwERi97TjLBC2mMSFe+vZ
	uhi5OIQEljFKLL5yhwWmaNHiG4wQiUWMEvOvbmCFcGYzSUx4uJYNpIpNQE3iy5fDYGNFBDQk
	2lZPAetmFsiXOHzoMpgtJGArsfvnC0YQm1PATuLGsktgvcICDhLTZ2wD62URUJW48P83M4jN
	C1T/fcNSVghbUOLH5HtQM7UkNm9rYoWw5SU2r3kLVM8BdKm6xKO/uhAnGEm07FrFBlEiIrHv
	xTuwByQE5rFLLF+9iglil4DEt8mHWCB6ZSU2HWCGeFhS4uCKGywTGCVmIdk8C8nmWUg2z0Ky
	YgEjyypG0dSC5ILipPQiQ73ixNzi0rx0veT83E2MkMjq3cF4+4D1IcZkoPUTmaVEk/OBkZlX
	Em9obGZkYWpiamxkbmlGmrCSOK9ai3WgkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBkZZSfkt
	XIyyE206OZK9uicaqJtGGPHMVnqYmhcYZPj2RVTMVH8Lr0vRSsJnfCboNM8Qm+Ty6Uoj56kZ
	6eYOK33l20/0T+szEXTgMdbLyTj2Sp1dx25iuNuxypL9ZzYf5q1U4mu4orJqd2Gml8TNAxOZ
	k5cfM39ivGv610lzWSZum33i+sZABiWW4oxEQy3mouJEACjqsy7CAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgG5RlW2gwb7Z4haXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xY+Oyw2wFTzkqfm3za2Cc
	z97FyMkhIWAisWjxDUYIW0ziwr31bF2MXBxCAosYJeZf3cAK4cxmkpjwcC0bSBWbgJrEly+H
	wbpFBDQk2lZPYQGxmQXyJQ4fugxmCwnYSuz++QJsKqeAncSNZZfAeoUFHCSmz9gG1ssioCpx
	4f9vZhCbF6j++4alrBC2oMSPyfegZmpJbN7WxAphy0tsXvMWqJ4D6FJ1iUd/dSFOMJJo2bWK
	DaJERGLfi3eMExiFZiGZNAvJpFlIJs1C0rKAkWUVo2hqQXJBcVJ6rqFecWJucWleul5yfu4m
	RnDcPpPawbiyweIQowAHoxIP7wQd20Ah1sSy4srcQ4wSHMxKIrwrN9kECvGmJFZWpRblxxeV
	5qQWH2JMBnp0IrOUaHI+MKXklcQbGpuYGVkamVkYmZibkyasJM57oNU6UEggPbEkNTs1tSC1
	CGYLEwenVAPjnN7c7Z8XuPC8Ot87vedIyL/KZV7nxLK/rwrbuUgn5shCB61q063zP/12sZ6v
	NzVHqll9WrRcrPLmf/lTWR4yzdjm8vXr5DXvCvYKX11mttLo4qWYpwsS074xTOTm/CDWsWpX
	07Hf2ysfbk6Z0lt+fJGL7vojcYwlsapmj1887t++o9Hw9MkqAyWW4oxEQy3mouJEAExFDGQf	AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_kzalloc() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/power/da9052-battery.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/power/da9052-battery.c b/drivers/power/da9052-battery.c
index 08193fe..f8f4c0f 100644
--- a/drivers/power/da9052-battery.c
+++ b/drivers/power/da9052-battery.c
@@ -594,7 +594,8 @@ static s32 da9052_bat_probe(struct platform_device *pdev)
 	int ret;
 	int i;
 
-	bat = kzalloc(sizeof(struct da9052_battery), GFP_KERNEL);
+	bat = devm_kzalloc(&pdev->dev, sizeof(struct da9052_battery),
+				GFP_KERNEL);
 	if (!bat)
 		return -ENOMEM;
 
@@ -635,7 +636,6 @@ err:
 	while (--i >= 0)
 		da9052_free_irq(bat->da9052, da9052_bat_irq_bits[i], bat);
 
-	kfree(bat);
 	return ret;
 }
 static int da9052_bat_remove(struct platform_device *pdev)
@@ -647,7 +647,6 @@ static int da9052_bat_remove(struct platform_device *pdev)
 		da9052_free_irq(bat->da9052, da9052_bat_irq_bits[i], bat);
 
 	power_supply_unregister(&bat->psy);
-	kfree(bat);
 
 	return 0;
 }
-- 
1.7.2.5


