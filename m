Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935384Ab3BOGEV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 01:04:21 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:44854 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824Ab3BOGEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 01:04:20 -0500
X-AuditID: cbfee68d-b7f4f6d000004209-ad-511dcfddd445
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001201ce0b41$4900c4d0$db024e70$%han@samsung.com>
In-reply-to: <001201ce0b41$4900c4d0$db024e70$%han@samsung.com>
Subject: [PATCH 11/11] rtc: rtc-cmos: use dev_warn()/dev_dbg() instead of
 printk()/pr_debug()
Date: Fri, 15 Feb 2013 15:04:13 +0900
Message-id: <001c01ce0b42$47774930$d665db90$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4LQUiQnZ5yIGDDRaO8BQe4Zm4AfgAAOuhw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t8zY92752UDDebvM7C4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZ92YfYyv4zlvx794StgbGSdxdjJwcEgImElO/7mSDsMUkLtxb
	D2YLCSxjlLi5JgemZsbG1exdjFxA8UWMEutf9bJBOLOZJBZdaGEGqWITUJP48uUwUBUHh4iA
	vkRbiwZIDbNAL6PEmd7d7BBTbSUmfFoHVs8pYCfx/c9DsG3CAvESN05OBqthEVCVmH19AVic
	F6j+/eatjBC2oMSPyfdYQGxmAS2JzduaWCFseYnNa94yg+yVEFCXePRXFyQsImAkcW7jKyaI
	EhGJfS/eMYLcIyGwjF1id88qJohdAhLfJh9igeiVldh0gBniYUmJgytusExglJiFZPMsJJtn
	Idk8C8mKBYwsqxhFUwuSC4qT0osM9YoTc4tL89L1kvNzNzFCIqt3B+PtA9aHGJOB1k9klhJN
	zgdGZl5JvKGxsYmZiamJuaWpuSlpwkrivHKXZAKFBNITS1KzU1MLUovii0pzUosPMTJxcEo1
	MLZZ7l53g730hrzb5UUTffru9LcacDVeqXqV8OZmOHNY8KM05WNWjFFFPyuZjiw7//Hv8aBU
	trM8Mj27PO/N4nr5KLzR6dmf9SIqSateZZzuObpfdo3sPOmoWY+WMe145qsxmSuNVc61/AVn
	0hz/7rsHlTdX/CqQNmT4vzk/6WDBRuOgk1y3limxFGckGmoxFxUnAgCDwtqHwgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+xgO7d87KBBu37tC0u75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxr3Zx9gKvvNW/Lu3hK2B
	cRJ3FyMnh4SAicSMjavZIWwxiQv31rN1MXJxCAksYpRY/6oXypnNJLHoQgszSBWbgJrEly+H
	gTo4OEQE9CXaWjRAapgFehklzvTuBpskJGArMeHTOrB6TgE7ie9/HrKB2MIC8RI3Tk4Gq2ER
	UJWYfX0BWJwXqP795q2MELagxI/J91hAbGYBLYnN25pYIWx5ic1r3jKD7JUQUJd49FcXJCwi
	YCRxbuMrJogSEYl9L94xTmAUmoVk0iwkk2YhmTQLScsCRpZVjKKpBckFxUnpuUZ6xYm5xaV5
	6XrJ+bmbGMGR+0x6B+OqBotDjAIcjEo8vAISsoFCrIllxZW5hxglOJiVRHjXhACFeFMSK6tS
	i/Lji0pzUosPMSYDPTqRWUo0OR+YVPJK4g2NTcyMLI3MLIxMzM1JE1YS52U89SRASCA9sSQ1
	OzW1ILUIZgsTB6dUA2PUNP6z9r+v/LVRffzK11r6yS/m4EKjtjC9iYozTrqW+4g1Xfyw9PeG
	qdxzFGpnTOhdFap/Ym6Z+Qyer+zeb08uYRM6kstqMfuEeQFzHuecgnlv+vk4r8u8dQ/l3WDJ
	Geh3bCdH4e72gy91Xgae230zVXrxYz1FN6fGSfN9pxSvs+3/s8BTb7ESS3FGoqEWc1FxIgDq
	iDRbIAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the checkpatch warning as below:

  WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-cmos.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 9deb9e4..af97c94 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -706,7 +706,7 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 			rtc_cmos_int_handler = hpet_rtc_interrupt;
 			err = hpet_register_irq_handler(cmos_interrupt);
 			if (err != 0) {
-				printk(KERN_WARNING "hpet_register_irq_handler "
+				dev_warn(dev, "hpet_register_irq_handler "
 						" failed in rtc_init().");
 				goto cleanup1;
 			}
@@ -731,8 +731,7 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 		goto cleanup2;
 	}
 
-	pr_info("%s: %s%s, %zd bytes nvram%s\n",
-		dev_name(&cmos_rtc.rtc->dev),
+	dev_info(dev, "%s%s, %zd bytes nvram%s\n",
 		!is_valid_irq(rtc_irq) ? "no alarms" :
 			cmos_rtc.mon_alrm ? "alarms up to one year" :
 			cmos_rtc.day_alrm ? "alarms up to one month" :
@@ -820,8 +819,7 @@ static int cmos_suspend(struct device *dev)
 			enable_irq_wake(cmos->irq);
 	}
 
-	pr_debug("%s: suspend%s, ctrl %02x\n",
-			dev_name(&cmos_rtc.rtc->dev),
+	dev_dbg(dev, "suspend%s, ctrl %02x\n",
 			(tmp & RTC_AIE) ? ", alarm may wake" : "",
 			tmp);
 
@@ -876,9 +874,7 @@ static int cmos_resume(struct device *dev)
 		spin_unlock_irq(&rtc_lock);
 	}
 
-	pr_debug("%s: resume, ctrl %02x\n",
-			dev_name(&cmos_rtc.rtc->dev),
-			tmp);
+	dev_dbg(dev, "resume, ctrl %02x\n", tmp);
 
 	return 0;
 }
-- 
1.7.2.5


