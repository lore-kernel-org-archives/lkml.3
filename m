Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab3BUIgs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 03:36:48 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:14189 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab3BUIgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 03:36:46 -0500
X-AuditID: cbfee68f-b7f656d000000d78-e5-5125dc9e645b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <00cc01ce100d$f42fddc0$dc8f9940$%han@samsung.com>
In-reply-to: <00cc01ce100d$f42fddc0$dc8f9940$%han@samsung.com>
Subject: [PATCH 09/12] rtc: rtc-palmas: use devm_request_threaded_irq()
Date: Thu, 21 Feb 2013 17:36:45 +0900
Message-id: <00d401ce100e$94f05cd0$bed11670$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4QDe9M0/OnFjrjTvSUwIYm7R1WAgAAJFgw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t8zY915d1QDDVYvZrW4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZf65sZi94y16xt/cqcwPjGbYuRk4OCQETiZW7z7JA2GISF+6t
	B4pzcQgJLGOU+DD9FSNM0Z22G0wQiemMEiefNjBCOLOZJHZdvskEUsUmoCbx5cth9i5GDg4R
	AX2JthYNkBpmgV5GiTO9u9lBaoQEbCXmfLjGDGJzCthJXN72hRXEFhZwl3j/ZSdYDYuAqsSB
	xX/BZvIC1X/e0MAGYQtK/Jh8D+xUZgEtifU7jzNB2PISm9e8ZQbZKyGgLvHory5IWETASOLl
	pW/MECUiEvtevAO7WUJgFbvEs+0/mCF2CUh8m3yIBaJXVmLTAWaIhyUlDq64wTKBUWIWks2z
	kGyehWTzLCQrFjCyrGIUTS1ILihOSi8y1itOzC0uzUvXS87P3cQIia3+HYx3D1gfYkwGWj+R
	WUo0OR8Ym3kl8YbGxiZmJqYm5pam5qakCSuJ88pfkgkUEkhPLEnNTk0tSC2KLyrNSS0+xMjE
	wSnVwBgmY/53+VMH/QnGbHvm56YntVo9vXW2dEv1V1GBP7axrLoM0pvlv3FWKwfz3Yxk2qEv
	PaWkVawmJ+mx9AZX2+VPjPXmvwm8H6rls1Dy5rsPCj/X36hY3qq4cvrLvUp3Mxy38n84OulR
	7RT5E6KTbzj4vlknOX367+WNif7tcVHG1nfOhtv1dyixFGckGmoxFxUnAgBP2cViwwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+xoO68O6qBBq23GC0u75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxp8rm9kL3rJX7O29ytzA
	eIati5GTQ0LAROJO2w0mCFtM4sK99UBxLg4hgemMEiefNjBCOLOZJHZdvglWxSagJvHly2H2
	LkYODhEBfYm2Fg2QGmaBXkaJM7272UFqhARsJeZ8uMYMYnMK2Elc3vaFFcQWFnCXeP9lJ1gN
	i4CqxIHFf8Fm8gLVf97QwAZhC0r8mHyPBcRmFtCSWL/zOBOELS+xec1bZpC9EgLqEo/+6oKE
	RQSMJF5e+sYMUSIise/FO8YJjEKzkEyahWTSLCSTZiFpWcDIsopRNLUguaA4KT3XSK84Mbe4
	NC9dLzk/dxMjOHKfSe9gXNVgcYhRgINRiYd3wUuVQCHWxLLiytxDjBIczEoivIq3VQOFeFMS
	K6tSi/Lji0pzUosPMSYDPTqRWUo0OR+YVPJK4g2NTcyMLI3MLIxMzM1JE1YS52U89SRASCA9
	sSQ1OzW1ILUIZgsTB6dUA+PkWZdXZPG7/BLi7rC9dDL0FlNMolRu9sv1L7IiZFKvmMvdOOYz
	I39Xn9dGm9cZAsq7l3fdeRO24+7FJT+3JClZqt08cVbuJEugRuYmsaeVy86btNue3OkacT3t
	qZtNw6/8roI9y2bt2/ZGhtnDT2vRr+SPeQIrPHNuBszdNMN8LYM/T6Zw5w8lluKMREMt5qLi
	RAC9oIo9IAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_request_threaded_irq() to make cleanup paths more simple.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-palmas.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-palmas.c b/drivers/rtc/rtc-palmas.c
index 59c4298..df9359c 100644
--- a/drivers/rtc/rtc-palmas.c
+++ b/drivers/rtc/rtc-palmas.c
@@ -272,7 +272,7 @@ static int palmas_rtc_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	ret = request_threaded_irq(palmas_rtc->irq, NULL,
+	ret = devm_request_threaded_irq(&pdev->dev, palmas_rtc->irq, NULL,
 			palmas_rtc_interrupt,
 			IRQF_TRIGGER_LOW | IRQF_ONESHOT |
 			IRQF_EARLY_RESUME,
@@ -292,7 +292,6 @@ static int palmas_rtc_remove(struct platform_device *pdev)
 	struct palmas_rtc *palmas_rtc = platform_get_drvdata(pdev);
 
 	palmas_rtc_alarm_irq_enable(&pdev->dev, 0);
-	free_irq(palmas_rtc->irq, palmas_rtc);
 	rtc_device_unregister(palmas_rtc->rtc);
 	return 0;
 }
-- 
1.7.2.5


