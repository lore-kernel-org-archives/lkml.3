Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161267Ab3BOGtD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 01:49:03 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:53278 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935345Ab3BOGtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 01:49:01 -0500
X-AuditID: cbfee68f-b7f656d000000d78-e9-511dda56e3bc
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001e01ce0b47$8edd1480$ac973d80$%han@samsung.com>
In-reply-to: <001e01ce0b47$8edd1480$ac973d80$%han@samsung.com>
Subject: [PATCH V2 11/11] rtc: rtc-cmos: use dev_warn()/dev_dbg() instead of
 printk()/pr_debug()
Date: Fri, 15 Feb 2013 15:48:54 +0900
Message-id: <002901ce0b48$8592bbe0$90b833a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4LR47AXgjtu6e1Qmq7gnKtv11nagAAONDA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zY92wW7KBBj8+mllc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MB5dPsxf081Usf/SErYFxMXcXIyeHhICJxP6lB1khbDGJC/fW
	s3UxcnEICSxjlPjUe44NpujKzG6oxHRGiQtH9jBBOLOZJL7un8YCUsUmoCbx5cth9i5GDg4R
	AX2JthYNkBpmgV5GiTO9u8HiQgK2ElNvO4OYnAJ2Eu+nm4J0CgskSfyZuoMZxGYRUJXo+9rJ
	DmLzAlV/ODqDEcIWlPgx+R7YJmYBLYnN25pYIWx5ic1r3jKDjJQQUJd49FcXJCwiYCQxZfFe
	NogSEYl9L94xQryyjF2i+XEyxCoBiW+TD7FAtMpKbDrADFEiKXFwxQ2WCYwSs5AsnoVk8Swk
	i2ch2bCAkWUVo2hqQXJBcVJ6kbFecWJucWleul5yfu4mRkhU9e9gvHvA+hBjMtD6icxSosn5
	wKjMK4k3NDY2MTMxNTG3NDU3JU1YSZxX/pJMoJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbG
	pgmnuAX3ZlRvYNzsy9KZnxm29XzXbLcIjUjO9Isfp087dttwK2/bIf5PH7uLn/m78PX9+Xzs
	R29i0ORg15TG304PrYRs+lK2XQhQ9NZKUWGRtJZaueJXT/LCT2e/HP927eCmyWt8L0/u8uNb
	8jjP80zKUQfpklW2jvzvNz/2zN5SwLY81v+YEktxRqKhFnNRcSIAO0jOLsACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+xoG7YLdlAg7XzjCwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxoPLp9kL+vkqlj96wtbA
	uJi7i5GTQ0LAROLKzG42CFtM4sK99UA2F4eQwHRGiQtH9jBBOLOZJL7un8YCUsUmoCbx5cth
	9i5GDg4RAX2JthYNkBpmgV5GiTO9u8HiQgK2ElNvO4OYnAJ2Eu+nm4J0CgskSfyZuoMZxGYR
	UJXo+9rJDmLzAlV/ODqDEcIWlPgx+R7YJmYBLYnN25pYIWx5ic1r3jKDjJQQUJd49FcXJCwi
	YCQxZfFeNogSEYl9L94xTmAUmoVk0iwkk2YhmTQLScsCRpZVjKKpBckFxUnpuUZ6xYm5xaV5
	6XrJ+bmbGMFR+0x6B+OqBotDjAIcjEo8vAISsoFCrIllxZW5hxglOJiVRHjXhACFeFMSK6tS
	i/Lji0pzUosPMSYDPTqRWUo0OR+YUPJK4g2NTcyMLI3MLIxMzM1JE1YS52U89SRASCA9sSQ1
	OzW1ILUIZgsTB6dUA2PA0/7rj3XOhM1+uedp7IFMSbv3pQXtbsqPird+kWQoeF6R+F1t/stG
	u9tR1ozv/tyeNddJ1zrrR27/qvO9nv+fCp3yMtqcPktgXuvlS9O//no7ZdOX9n7vvIlNrGsn
	vPJO3aGu4Crv/Gybh/e2ORWiNSIMDAyO+Qsud/bIZjzzbPynELCHR1SJpTgj0VCLuag4EQAs
	6Ra1HgMAAA==
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
No changes since v1:

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


