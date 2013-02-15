Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935376Ab3BOGCt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 01:02:49 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:44589 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab3BOGCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 01:02:48 -0500
X-AuditID: cbfee68e-b7fc26d000001938-f6-511dcf86cb3a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001201ce0b41$4900c4d0$db024e70$%han@samsung.com>
In-reply-to: <001201ce0b41$4900c4d0$db024e70$%han@samsung.com>
Subject: [PATCH 09/11] rtc: rtc-sun4v: use pr_warn() instead of printk()
Date: Fri, 15 Feb 2013 15:02:46 +0900
Message-id: <001a01ce0b42$138e19f0$3aaa4dd0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4LQUiQnZ5yIGDDRaO8BQe4Zm4AfgAALIrg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t8zA92287KBBuf/aVtc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MOWu/sBes46po3RrcwLico4uRk0NCwESi5858JghbTOLCvfVs
	XYxcHEICyxglPu+dzwJT1Hl5FzNEYjqjRN/G01BVs5kkZn1+CNbOJqAm8eXLYfYuRg4OEQF9
	ibYWDZAaZoFeRokzvbvZQWqEBGwlJnxaxwxicwrYSXz/85ANxBYW8JBY8Poj2DYWAVWJhjNr
	wGp4gerbf59lh7AFJX5MvgdWwyygJbF5WxMrhC0vsXnNW2aQvRIC6hKP/uqChEUEjCTu35kP
	VS4ise/FO0aQeyQEFrFL7Oh4ywqxS0Di2+RDLBC9shKbDjBDPCwpcXDFDZYJjBKzkGyehWTz
	LCSbZyFZsYCRZRWjaGpBckFxUnqRkV5xYm5xaV66XnJ+7iZGSGT17WC8ecD6EGMy0PqJzFKi
	yfnAyMwriTc0NjYxMzE1Mbc0NTclTVhJnFf+kkygkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6p
	BkarsxxPw7yr2tRYP0/d+FJb8vlivZxa2d8Xniu5pUw71qKjuHzno6fJ/VL9gSKK4tvLpoU3
	/N9tMO2MitvCE2I+z+UO9LtUf9gmfvBaREZNn79FldI/e3GfvpAJYZKXd3LWf8/oC2gPktfg
	aGucHVfYvEq5377i5taEDKcM4ZuMT3W4i2valFiKMxINtZiLihMBqVNzYcICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xoG7bedlAg76PqhaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xY87aL+wF67gqWrcGNzAu
	5+hi5OSQEDCR6Ly8ixnCFpO4cG89WxcjF4eQwHRGib6Np6Gc2UwSsz4/ZAKpYhNQk/jy5TB7
	FyMHh4iAvkRbiwZIDbNAL6PEmd7d7CA1QgK2EhM+rQObyilgJ/H9z0M2EFtYwENiweuPLCA2
	i4CqRMOZNWA1vED17b/PskPYghI/Jt8Dq2EW0JLYvK2JFcKWl9i85i0zyF4JAXWJR391QcIi
	AkYS9+/MhyoXkdj34h3jBEahWUgmzUIyaRaSSbOQtCxgZFnFKJpakFxQnJSea6hXnJhbXJqX
	rpecn7uJERy3z6R2MK5ssDjEKMDBqMTDKyAhGyjEmlhWXJl7iFGCg1lJhHdNCFCINyWxsiq1
	KD++qDQntfgQYzLQoxOZpUST84EpJa8k3tDYxMzI0sjMwsjE3Jw0YSVxXsZTTwKEBNITS1Kz
	U1MLUotgtjBxcEo1MJZ/2/6Bt9LllgT3vNsXw5Yc51kc05xlFPzs2KqVGaIH8zk7OZ9n/JTi
	nsAvczO5fa38xxuCn3hjsl7+0pd+I86Vk3kqbM2Fr3tm39/re2ZSjWyR/OQvGh3LDFiE80vn
	ctpdLTtf3ZflMmddyIN12Rsmx1RcF2VTDOB8qP3hWLX87Tt2V/rjJZRYijMSDbWYi4oTAfKt
	1PcfAwAA
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


