Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899Ab3CFF3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 00:29:32 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:48419 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533Ab3CFF3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 00:29:30 -0500
X-AuditID: cbfee68f-b7f6a6d000004969-32-5136d43918ae
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
In-reply-to: <004301ce1a2b$3ad77e00$b0867a00$%han@samsung.com>
Subject: [PATCH 07/30] rtc: rtc-ds1553: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 14:29:29 +0900
Message-id: <004901ce1a2b$92f8fc30$b8eaf490$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aKzqYzbgO1ZcaTfGsrpjfTnOAiQAAEwOQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t8zQ13LK2aBBm93yFpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MvTcqCpZyVuy8t4e5gfEGexcjJ4eEgInE76P9zBC2mMSFe+vZ
	uhi5OIQEljFKzN58H65o0/p5jBCJRYwSm38uY4ZwZjNJ3Hm2kRGkik1ATeLLl8NAHRwcIgL6
	Em0tGiA1zAK9jBJneneDTRISsJW42r0KbB2ngJ3E8sezWEBsYQE3iel7m5lAbBYBVYmdW2eD
	2bxA9ZdPfmKBsAUlfky+B2YzC2hJrN95nAnClpfYvOYtM8heCQF1iUd/dUHCIgJGEtu37GWD
	KBGR2PfiHdgDEgLL2CVuz1rIDrFLQOLb5EMsEL2yEpsOQENCUuLgihssExglZiHZPAvJ5llI
	Ns9CsmIBI8sqRtHUguSC4qT0ImO94sTc4tK8dL3k/NxNjJDI6t/BePeA9SHGZKD1E5mlRJPz
	gZGZVxJvaGxsYmZiamJuaWpuSpqwkjiv/CWZQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2M
	6q//NPx+56X9hev7cn+ZzCLB5mtO8RsP+swUu3BK5bPcU7UPbq3z3mevyxLSkv2bUS88xevc
	3Xk+bR6TVkVXJYvJ8T99EnLC2Evn4B+m/RaOPYHTpOf+cmmLK9BOY+Ze7bo7UeXBPCvR+xNk
	rdyWa29SSTdvDF7feWrX9rmJ+3esvrNn1exjSizFGYmGWsxFxYkA/J4Rg8ICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgK7lFbNAg1XLxCwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxt4bFQVLOSt23tvD3MB4
	g72LkZNDQsBEYtP6eYwQtpjEhXvr2boYuTiEBBYxSmz+uYwZwpnNJHHn2UawKjYBNYkvXw4D
	dXNwiAjoS7S1aIDUMAv0Mkqc6d0NNlVIwFbiavcqZhCbU8BOYvnjWSwgtrCAm8T0vc1MIDaL
	gKrEzq2zwWxeoPrLJz+xQNiCEj8m3wOzmQW0JNbvPM4EYctLbF7zlhlkr4SAusSjv7ogYREB
	I4ntW/ayQZSISOx78Y5xAqPQLCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrPNdQrTswtLs1L
	10vOz93ECI7bZ1I7GFc2WBxiFOBgVOLhtVAyCxRiTSwrrsw9xCjBwawkwst1BijEm5JYWZVa
	lB9fVJqTWnyIMRno0YnMUqLJ+cCUklcSb2hsYmZkaWRmYWRibk6asJI4L+OpJwFCAumJJanZ
	qakFqUUwW5g4OKUaGHMluqdPKNHV3T0jL+AHA5fVkswyu9zkexszZ/80uV038VltXfrdV5fk
	9fcpLRAxEuD+xBoZNedNHufal59isiTW9DwQ+Fq2ei+X8Y494R/37GDY1StyxOSvtf3ey+/n
	P4zYfSRhxQPHl0kTFNYmchhnubuUn+pXWb42+QG3fG6hyseXU25G/FJiKc5INNRiLipOBACS
	/zqsHwMAAA==
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
 drivers/rtc/rtc-ds1553.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-ds1553.c b/drivers/rtc/rtc-ds1553.c
index 25ce062..387289b 100644
--- a/drivers/rtc/rtc-ds1553.c
+++ b/drivers/rtc/rtc-ds1553.c
@@ -326,15 +326,14 @@ static int ds1553_rtc_probe(struct platform_device *pdev)
 		}
 	}
 
-	rtc = rtc_device_register(pdev->name, &pdev->dev,
+	rtc = devm_rtc_device_register(pdev->name, &pdev->dev,
 				  &ds1553_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
 	pdata->rtc = rtc;
 
 	ret = sysfs_create_bin_file(&pdev->dev.kobj, &ds1553_nvram_attr);
-	if (ret)
-		rtc_device_unregister(rtc);
+
 	return ret;
 }
 
@@ -343,7 +342,6 @@ static int ds1553_rtc_remove(struct platform_device *pdev)
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 
 	sysfs_remove_bin_file(&pdev->dev.kobj, &ds1553_nvram_attr);
-	rtc_device_unregister(pdata->rtc);
 	if (pdata->irq > 0)
 		writeb(0, pdata->ioaddr + RTC_INTERRUPTS);
 	return 0;
-- 
1.7.2.5


