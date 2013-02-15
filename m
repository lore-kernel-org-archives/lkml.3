Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab3BOGrx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 01:47:53 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:53110 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab3BOGrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 01:47:52 -0500
X-AuditID: cbfee691-b7f556d000001a24-dc-511dda162441
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001e01ce0b47$8edd1480$ac973d80$%han@samsung.com>
In-reply-to: <001e01ce0b47$8edd1480$ac973d80$%han@samsung.com>
Subject: [PATCH V2 09/11] rtc: rtc-sun4v: use pr_warn() instead of printk()
Date: Fri, 15 Feb 2013 15:47:50 +0900
Message-id: <002701ce0b48$5f5f3930$1e1dab90$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4LR47AXgjtu6e1Qmq7gnKtv11nagAAL34w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFIsWRmVeSWpSXmKPExsVy+t8zI12xW7KBBgvOGlpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MlpXaBce4Kn4d8m1g3MHRxcjJISFgItH+dS07hC0mceHeerYu
	Ri4OIYFljBL/ez8xwxQ1bp4IViQkMJ1RYspXDoii2UwS/xs/soEk2ATUJL58OQxUxMEhIqAv
	0daiAVLDLNDLKHGmdzdYXEjAVmLqbWcQk1PATuL9dFOQTmEBb4mtm7pZQWwWAVWJXXtngtm8
	QNVL7r5hhrAFJX5MvscCYjMLaEls3tbECmHLS2xe85YZZKSEgLrEo7+6EAcYSaw5GwBRISKx
	78U7RpBjJASms0vsP/yeEWKVgMS3yYdYIFplJTYdgHpWUuLgihssExglZiFZPAvJ4llIFs9C
	smIBI8sqRtHUguSC4qT0IlO94sTc4tK8dL3k/NxNjJB4mriD8f4B60OMyUDrJzJLiSbnA+Mx
	ryTe0NjYxMzE1MTc0tTclDRhJXFe+UsygUIC6YklqdmpqQWpRfFFpTmpxYcYmTg4pRoYa59c
	jeBbunnBlEdMLH9z+LtuHg+YfdqX54+iIveyd/e+ZB+K3sWcvuNyRtPTd2WqVbsD5GU1q1zK
	ZCY4z646IJfa5XZxykaL8uvqRbM2zD/fd/TTJrfgXVZvSnxue0yfJjtP4nbbzNTbOvoPLswQ
	Z7mkKbjt4J2/a170M9wSd3s2t9ucM+DaMiWW4oxEQy3mouJEAC8bbJi9AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnleLIzCtJLcpLzFFi42I5/e+xoK7YLdlAg2ttOhaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xo2WldsExropfh3wbGHdw
	dDFyckgImEg0bp7IDmGLSVy4t54NxBYSmM4oMeUrUA0XkD2bSeJ/40ewBJuAmsSXL4eBGjg4
	RAT0JdpaNEBqmAV6GSXO9O4GiwsJ2EpMve0MYnIK2Em8n24K0iks4C2xdVM3K4jNIqAqsWvv
	TDCbF6h6yd03zBC2oMSPyfdYQGxmAS2JzduaWCFseYnNa94yg4yUEFCXePRXF+IAI4k1ZwMg
	KkQk9r14xziBUWgWkkGzkAyahWTQLCQtCxhZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIE
	R+sz6R2MqxosDjEKcDAq8fAKSMgGCrEmlhVX5h5ilOBgVhLhXRMCFOJNSaysSi3Kjy8qzUkt
	PsSYDPTnRGYp0eR8YCLJK4k3NDYxM7I0MrMwMjE3J01YSZyX8dSTACGB9MSS1OzU1ILUIpgt
	TBycUg2MYtNdw2aEcH1a9FVj36k9S1JMK3LcZzoym3SVNujfX/H9v8i8Dw+mLeDo3MW/0HtK
	jdI16z+CDPtORFnNX2Re7bqkSV2oyib8waPVjCn6K+4uXbvkfMrnjtptZ3qsDx140mz/1iO4
	6I2nYWg0z6zwsL5dp9f4zY2ZW36rI/nG5ImXLTduuO2QpMRSnJFoqMVcVJwIACZJDQQaAwAA
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

 drivers/rtc/rtc-sun4v.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/rtc/rtc-sun4v.c b/drivers/rtc/rtc-sun4v.c
index 5b22610..59b5c2d 100644
--- a/drivers/rtc/rtc-sun4v.c
+++ b/drivers/rtc/rtc-sun4v.c
@@ -3,6 +3,8 @@
  * Copyright (C) 2008 David S. Miller <davem@davemloft.net>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/delay.h>
@@ -26,10 +28,10 @@ retry:
 			udelay(100);
 			goto retry;
 		}
-		printk(KERN_WARNING "SUN4V: tod_get() timed out.\n");
+		pr_warn("tod_get() timed out.\n");
 		return 0;
 	}
-	printk(KERN_WARNING "SUN4V: tod_get() not supported.\n");
+	pr_warn("tod_get() not supported.\n");
 	return 0;
 }
 
@@ -53,10 +55,10 @@ retry:
 			udelay(100);
 			goto retry;
 		}
-		printk(KERN_WARNING "SUN4V: tod_set() timed out.\n");
+		pr_warn("tod_set() timed out.\n");
 		return -EAGAIN;
 	}
-	printk(KERN_WARNING "SUN4V: tod_set() not supported.\n");
+	pr_warn("tod_set() not supported.\n");
 	return -EOPNOTSUPP;
 }
 
-- 
1.7.2.5


