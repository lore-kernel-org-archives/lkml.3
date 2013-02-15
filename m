Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935550Ab3BOHcO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 02:32:14 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:41591 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935388Ab3BOHcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 02:32:13 -0500
X-AuditID: cbfee68d-b7f4f6d000004209-27-511de47c795b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <002b01ce0b4d$865ca950$9315fbf0$%han@samsung.com>
In-reply-to: <002b01ce0b4d$865ca950$9315fbf0$%han@samsung.com>
Subject: [PATCH V3 11/11] rtc: rtc-cmos: use dev_warn()/dev_dbg() instead of
 printk()/pr_debug()
Date: Fri, 15 Feb 2013 16:32:11 +0900
Message-id: <003501ce0b4e$919e0510$b4da0f30$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4LTYY6VzXwCUtKTcq8t8M0FTt2HQAAPD0A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t8zI92aJ7KBBt3zOC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfG5mt/WAuW81Vc/fSapYFxC3cXIyeHhICJxJlDPWwQtpjEhXvr
	gWwuDiGBZYwSk3YsZoIp2tfXxwSRmM4o8a/rMlTVbCaJS7sOgbWzCahJfPlymL2LkYNDREBf
	oq1FA6SGWaCXUeJM7252kBohAVuJqb+/sYLYnAJ2EqsndYDFhQWSJBY2zmMBsVkEVCXu3N/H
	CGLzAtW//vuSFcIWlPgx+R5YDbOAlsTmbU2sELa8xOY1b5lB9koIqEs8+qsLEhYRMJL4MG8T
	M0SJiMS+F+8YQe6REFjGLnH74Qx2iF0CEt8mH2KB6JWV2HSAGeJhSYmDK26wTGCUmIVk8ywk
	m2ch2TwLyYoFjCyrGEVTC5ILipPSiwz1ihNzi0vz0vWS83M3MUJiq3cH4+0D1ocYk4HWT2SW
	Ek3OB8ZmXkm8obGxiZmJqYm5pam5KWnCSuK8cpdkAoUE0hNLUrNTUwtSi+KLSnNSiw8xMnFw
	SjUwzng9+Y7VL/vvc9VYtpRb7HtR/Grq7Oye+486Z8htqPm+lOHZSvbQRq6Lu6sq95fkL3l/
	Nf1TSOsRiZnbZ+878njj4gSzNDEB0d9992SfHdoieSVZ8Uf1nYteK/JrQhfWLzeV80otq7ut
	bidg1mkqVN35JePHfnPeR+xrX0Za+/p/iNX43fKSV4mlOCPRUIu5qDgRAB6tQrPDAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+xoG7NE9lAg+nvWSwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxuZrf1gLlvNVXP30mqWB
	cQt3FyMnh4SAicS+vj4mCFtM4sK99WxdjFwcQgLTGSX+dV2GcmYzSVzadYgNpIpNQE3iy5fD
	7F2MHBwiAvoSbS0aIDXMAr2MEmd6d7OD1AgJ2EpM/f2NFcTmFLCTWD2pAywuLJAksbBxHguI
	zSKgKnHn/j5GEJsXqP7135esELagxI/J98BqmAW0JDZva2KFsOUlNq95ywyyV0JAXeLRX12Q
	sIiAkcSHeZuYIUpEJPa9eMc4gVFoFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGukVJ+YW
	l+al6yXn525iBEfuM+kdjKsaLA4xCnAwKvHwCkjIBgqxJpYVV+YeYpTgYFYS4ZW7BRTiTUms
	rEotyo8vKs1JLT7EmAz06ERmKdHkfGBSySuJNzQ2MTOyNDKzMDIxNydNWEmcl/HUkwAhgfTE
	ktTs1NSC1CKYLUwcnFINjLwTgvhkt/3nERf4H3HdyOn1az+91mWiXj9nlFsvY7x2YvXpsy2n
	va3Tdy6zPy7NE8PMcjv5yy+lHpd1yXkySxa/PD41p42Tq+pDmfAc7kVdy8VeNN2cHV/6OzrK
	c3msLlOltvyb/yaG897p7OzpjJdpenykXmIj08reDS8v39sREhNlyv/hghJLcUaioRZzUXEi
	AKcOvj4gAwAA
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

No changes since v2:

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


