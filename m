Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935567Ab3BOHaj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 02:30:39 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:61100 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935388Ab3BOHai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 02:30:38 -0500
X-AuditID: cbfee68f-b7f656d000000d78-96-511de41cc2d7
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <002b01ce0b4d$865ca950$9315fbf0$%han@samsung.com>
In-reply-to: <002b01ce0b4d$865ca950$9315fbf0$%han@samsung.com>
Subject: [PATCH V3 09/11] rtc: rtc-sun4v: use pr_warn() instead of printk()
Date: Fri, 15 Feb 2013 16:30:36 +0900
Message-id: <003301ce0b4e$58edb0d0$0ac91270$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4LTYY6VzXwCUtKTcq8t8M0FTt2HQAAL3Lg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t8zI13ZJ7KBBocvMFpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mro12Bfe4Kt6/XMXWwHiSo4uRk0NCwERi0+sHjBC2mMSFe+vZ
	uhi5OIQEljFK/Nn0DCjBAVa0psEcIr6IUWLTpMlQRbOZJJ48OMIM0s0moCbx5cthdpAGEQF9
	ibYWDZAaZoFeRokzvbvZQWqEBGwlpv7+xgpicwrYSaye1AFWLyzgLbH4QSZImEVAVaJ3wySw
	g3iBytevfQllC0r8mHyPBcRmFtCS2LytiRXClpfYvOYtM8Sd6hKP/uqChEUEjCSmflsMVSIi
	se/FO0aQcyQEFrFL/F2zjwVil4DEt8mHWCB6ZSU2HWCGhIOkxMEVN1gmMErMQrJ5FpLNs5Bs
	noVkxQJGllWMoqkFyQXFSelFxnrFibnFpXnpesn5uZsYIVHVv4Px7gHrQ4zJQOsnMkuJJucD
	ozKvJN7Q2NjEzMTUxNzS1NyUNGElcV75SzKBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhiD
	pfMauxkucYnXTFthWDPxfniQbFfJVMnztiu9VRg3CUimZryq5fo88auAcWqPqk4Qx/bERf5G
	FTNX2Soxi7Ad2OK59czDqfZzTVpfGte415xi5H2QoduTcFO27eeq7rBLDyfzvFxTGqDwQ0jl
	xsKiJMN+nqqQjNk8fal+Jyb42+z6Le7AoMRSnJFoqMVcVJwIAJy5xdzAAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupileLIzCtJLcpLzFFi42I5/e+xgK7ME9lAg3MHrSwu75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jRtdGu4J7XBXvX65ia2A8
	ydHFyMEhIWAisabBvIuRE8gUk7hwbz1bFyMXh5DAIkaJTZMmQzmzmSSePDjCDFLFJqAm8eXL
	YXaQZhEBfYm2Fg2QGmaBXkaJM7272UFqhARsJab+/sYKYnMK2EmsntQBVi8s4C2x+EEmSJhF
	QFWid8MkRhCbF6h8/dqXULagxI/J91hAbGYBLYnN25pYIWx5ic1r3jJD3Kwu8eivLkhYRMBI
	Yuq3xVAlIhL7XrxjnMAoNAvJpFlIJs1CMmkWkpYFjCyrGEVTC5ILipPSc430ihNzi0vz0vWS
	83M3MYJj9pn0DsZVDRaHGAU4GJV4eAUkZAOFWBPLiitzDzFKcDArifDK3QIK8aYkVlalFuXH
	F5XmpBYfYkwGenQis5Rocj4wneSVxBsam5gZWRqZWRiZmJuTJqwkzst46kmAkEB6Yklqdmpq
	QWoRzBYmDk6pBsalMZq/7+05vG2qAovL4Y02f5xnP7w9mynoLo/6rLsP9O95RD2o3Jz8mvum
	2s/2EGOf67+aO7dHXvAKPtS/Q+NT8bcljfUHV4b7dUWYBktwLljywyKkTaAwsnK27e8NX6a1
	B7r0Kz3ctXxx87sGEe0Q53XZPKWqysrBu+d0ary4tkzh8q/q+D1KLMUZiYZazEXFiQAcNHCX
	HQMAAA==
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


