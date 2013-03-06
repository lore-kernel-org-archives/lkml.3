Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab3CFH4O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:56:14 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:53699 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755759Ab3CFH4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:56:09 -0500
X-AuditID: cbfee68d-b7f636d0000009be-3f-5136f6989673
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
In-reply-to: <007b01ce1a3e$cd9f3260$68dd9720$%han@samsung.com>
Subject: [PATCH V2 26/30] rtc: rtc-tps65910: use devm_rtc_device_register()
Date: Wed, 06 Mar 2013 16:56:08 +0900
Message-id: <009401ce1a40$0f91de10$2eb59a30$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4aPs2G+X8TED9/S2OjRUc7S5yKjAAAThnQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsVy+t8zA90Z38wCDR7Ol7S4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZh48VFDzirDjXOYO5gXEWRxcjJ4eEgInEocaDrBC2mMSFe+vZ
	uhi5OIQEljFKNLztYocpete+mRkisYhR4sanG0wQzmwmidW/PzCCVLEJqEl8+XIYqIODQ0RA
	X6KtRQOkhlmgl1HiTO9usLiQgK1EzzwekHJOATuJKRMfgy0QFvCWmPHtOxOIzSKgKvFuxSMw
	mxeo/ObDN4wQtqDEj8n3WEBsZgEtifU7jzNB2PISm9e8ZQYZLyGgLvHory5IWETASGL1r+fM
	ECUiEvtevGOEKFnGLjEtDWKTgMS3yYdYIMKyEpsOMEN8KylxcMUNlgmMErOQ7J2FZO8sJHtn
	IVmwgJFlFaNoakFyQXFSepGhXnFibnFpXrpecn7uJkZITPXuYLx9wPoQYzLQ+onMUqLJ+cCY
	zCuJNzQ2NjEzMTUxtzQ1NyVNWEmcV+6STKCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGRju+
	nEvpKTJykxZUBUfu1xLv3PPsxZH4AgmR5Lw/CtdlVfjiZ0VIb46LaPORWZPX/u3t/Oli/2Rl
	WqumbCq47D7rTtLxpqk8pQYzo2NOVmin87XG5qglGff96bs+f0WuRnB6htDqXWJvRZfdsc9s
	1XP026YXs1FA4G2pmlbt3DxZtZfKK7iVWIozEg21mIuKEwFBjbMfvwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xgO6Mb2aBBj8+ilhc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjMPHCgoecVac65zB3MA4
	i6OLkZNDQsBE4l37ZmYIW0ziwr31bF2MXBxCAosYJW58usEE4cxmklj9+wMjSBWbgJrEly+H
	2bsYOThEBPQl2lo0QGqYBXoZJc707gaLCwnYSvTM4wEp5xSwk5gy8TE7iC0s4C0x49t3JhCb
	RUBV4t2KR2A2L1D5zYdvGCFsQYkfk++xgNjMAloS63ceZ4Kw5SU2r3nLDDJeQkBd4tFfXZCw
	iICRxOpfz5khSkQk9r14xziBUWgWkkmzkEyahWTSLCQtCxhZVjGKphYkFxQnpeca6RUn5haX
	5qXrJefnbmIER+0z6R2MqxosDjEKcDAq8fBOUDELFGJNLCuuzD3EKMHBrCTCy3UGKMSbklhZ
	lVqUH19UmpNafIgxGejRicxSosn5wISSVxJvaGxiZmRpZGZhZGJuTpqwkjgv46knAUIC6Ykl
	qdmpqQWpRTBbmDg4pRoYrbvrL0///MF5zZ7Jb3csaqsQKjzssvv2N5GTv3pm6dY13Zx+9xHz
	nZpalpUT+3+VTBXaJSDCFHBwhtrSoqefTERXBF+vFPsnLrT85/JVNeUPP8YyFx7evEyj0177
	1j39UoXavbk/K8t3eWfr3dqiKf+gxX3VE74J7uu3/Ay4pZ7LYBHoL+O6TomlOCPRUIu5qDgR
	AKW91H0eAwAA
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
Changes since v1:
- used 'struct device *dev' as the first argument

 drivers/rtc/rtc-tps65910.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-tps65910.c b/drivers/rtc/rtc-tps65910.c
index 8bd8115..ef5d199 100644
--- a/drivers/rtc/rtc-tps65910.c
+++ b/drivers/rtc/rtc-tps65910.c
@@ -276,7 +276,7 @@ static int tps65910_rtc_probe(struct platform_device *pdev)
 	tps_rtc->irq = irq;
 	device_set_wakeup_capable(&pdev->dev, 1);
 
-	tps_rtc->rtc = rtc_device_register(pdev->name, &pdev->dev,
+	tps_rtc->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 		&tps65910_rtc_ops, THIS_MODULE);
 	if (IS_ERR(tps_rtc->rtc)) {
 		ret = PTR_ERR(tps_rtc->rtc);
@@ -295,12 +295,8 @@ static int tps65910_rtc_probe(struct platform_device *pdev)
  */
 static int tps65910_rtc_remove(struct platform_device *pdev)
 {
-	/* leave rtc running, but disable irqs */
-	struct tps65910_rtc *tps_rtc = platform_get_drvdata(pdev);
-
 	tps65910_rtc_alarm_irq_enable(&pdev->dev, 0);
 
-	rtc_device_unregister(tps_rtc->rtc);
 	return 0;
 }
 
-- 
1.7.2.5


