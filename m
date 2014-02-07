Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840AbaBGH6l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 02:58:41 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:19588 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbaBGH6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 02:58:39 -0500
X-AuditID: cbfee68e-b7f566d000002344-09-52f4922e489b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Lars-Peter Clausen'" <lars@metafoo.de>
References: <000401cf23d9$d1df6e30$759e4a90$%han@samsung.com>
In-reply-to: <000401cf23d9$d1df6e30$759e4a90$%han@samsung.com>
Subject: [PATCH 3/4] rtc: rtc-jz4740: Use devm_ioremap_resource()
Date: Fri, 07 Feb 2014 16:58:38 +0900
Message-id: <000701cf23da$688e1b60$39aa5220$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8j2dGo+e7pmAi4QKyN7t2QoeNN8wAAHcHg
Content-language: ko
x-cr-hashedpuzzle: G8ew KvW6 N/Xw XSWi a/5h b0oP gzym lzJm pdSE qDmm rex2 vl4S
 2IGY 4J7g 7rdJ
 ABGgUA==;6;YQAuAHoAdQBtAG0AbwBAAHQAbwB3AGUAcgB0AGUAYwBoAC4AaQB0ADsAYQBrAHAAbQBAAGwAaQBuAHUAeAAtAGYAbwB1AG4AZABhAHQAaQBvAG4ALgBvAHIAZwA7AGoAZwAxAC4AaABhAG4AQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBsAGEAcgBzAEAAbQBlAHQAYQBmAG8AbwAuAGQAZQA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwByAHQAYwAtAGwAaQBuAHUAeABAAGcAbwBvAGcAbABlAGcAcgBvAHUAcABzAC4AYwBvAG0A;Sosha1_v1;7;{F3DCDA8A-6B7E-4509-86B1-B85ED23127BE};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Fri,
 07 Feb 2014 07:58:27
 GMT;WwBQAEEAVABDAEgAIAAzAC8ANABdACAAcgB0AGMAOgAgAHIAdABjAC0AagB6ADQANwA0ADAAOgAgAFUAcwBlACAAZABlAHYAbQBfAGkAbwByAGUAbQBhAHAAXwByAGUAcwBvAHUAcgBjAGUAKAApAA==
x-cr-puzzleid: {F3DCDA8A-6B7E-4509-86B1-B85ED23127BE}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t8zI129SV+CDFZsFrRYcvEqu8Wc9WvY
	LC4vvMRqsWTyfFaLy7vmsFns7+xgdGDz2DPxJJvHiRm/WTyWvDnE6tG3ZRWjx/R5P5k8Pm+S
	C2CL4rJJSc3JLEst0rdL4Mro2rCYpaCXv2LjCo4Gxm08XYycHBICJhKzuq+zQ9hiEhfurWfr
	YuTiEBJYxiix7GYnE0zRzQkzWUFsIYHpjBInTohAFP1ilJj8agpYEZuAmsSXL4eBJnFwiAjo
	S7S1aIDUMAtsZ5RoeLqGCaLZVmLhy05mEJtTwE6if08f2FBhAUeJqbsWsYHYLAKqElNut4LF
	eYHqL0w8xA5hC0r8mHyPBcRmFtCSWL/zOBOELS+xec1bZpC9EgLqEo/+6oKERQSMJFbtu88M
	USIise/FO0aQeyQEGtgkXp5+xQLxmKnEkrZfzBCJXg6J5hf/WSCOEJD4NvkQC8RQWYlNB5gh
	6iUlDq64wTKBUWoWkpNmITlpFpKTZiHZvYCRZRWjaGpBckFxUnqRkV5xYm5xaV66XnJ+7iZG
	SLT37WC8ecD6EGMy0PqJzFKiyfnAZJFXEm9obGZkYWpiamxkbmlGmrCSOO+ih0lBQgLpiSWp
	2ampBalF8UWlOanFhxiZODilGhizTF+/Pzdh+5tpnHZGU27myH6bPjf3jrqwdpbXvaZYE8Wk
	g39auV5VvNfpcuVRbV6scmLXknt7r9/mksqYKMmzYE2Wvbmcw/N9T1dGK12S1MtsO8T3IeB+
	e4bD4UkT7y/+fdNpqfnLJia5TUaPNTvWu4Z1nM4TKpzkZcJ/LGduhDnLFU9O7V1KLMUZiYZa
	zEXFiQBQWP+bDAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGKsWRmVeSWpSXmKPExsVy+t9jQV29SV+CDC5P5bVYcvEqu8Wc9WvY
	LC4vvMRqsWTyfFaLy7vmsFns7+xgdGDz2DPxJJvHiRm/WTyWvDnE6tG3ZRWjx/R5P5k8Pm+S
	C2CLamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAG6
	Q0mhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeY0bVhMUtBL3/FxhUcDYzb
	eLoYOTkkBEwkbk6YyQphi0lcuLeeDcQWEpjOKHHihEgXIxeQ/YtRYvKrKUwgCTYBNYkvXw6z
	dzFycIgI6Eu0tWiA1DALbGeUaHi6hgmi2VZi4ctOZhCbU8BOon9PH9gCYQFHiam7FoEtYBFQ
	lZhyuxUszgtUf2HiIXYIW1Dix+R7LCA2s4CWxPqdx5kgbHmJzWveMoPslRBQl3j0VxckLCJg
	JLFq331miBIRiX0v3jGC3CMh0MAm8fL0KxaIx0wllrT9Yp7AKDILyYpZSFbMQrJiFpJZCxhZ
	VjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEp5Jn0jsYVzVYHGIU4GBU4uE9sfRzkBBrYllx
	Ze4hRgkOZiUR3p8NX4KEeFMSK6tSi/Lji0pzUosPMSYDQ2Ais5Rocj4wzeWVxBsam5gZWRqZ
	WRiZmJuTJqwkznuw1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA6PERyHZqQ/EMpczvw1/k7bnqNV5
	nsSjRgz3GI1OSpYtibr2eUt/QKx9m3fH2cVZunfX/Ovia//3QGb9qTkOn59whjZz3ru6K8hi
	S/a3F2HxLq1/bD/YBO5zfbd18f0N/isPT+ue1vmrehv71LDFO8q4LvB7PHq7sKEuLWX74Z9n
	ZlawcjRe+cmrxFKckWioxVxUnAgAGOyXrGkDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_ioremap_resource() in order to make the code simpler,
and move 'struct resource *mem' from 'struct jz4740_rtc' to
jz4740_rtc_probe() because the 'mem' variable is used only in
jz4740_rtc_probe().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-jz4740.c |   24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

diff --git a/drivers/rtc/rtc-jz4740.c b/drivers/rtc/rtc-jz4740.c
index 1b126d2..717abb3 100644
--- a/drivers/rtc/rtc-jz4740.c
+++ b/drivers/rtc/rtc-jz4740.c
@@ -38,7 +38,6 @@
 #define JZ_RTC_CTRL_ENABLE	BIT(0)
 
 struct jz4740_rtc {
-	struct resource *mem;
 	void __iomem *base;
 
 	struct rtc_device *rtc;
@@ -216,6 +215,7 @@ static int jz4740_rtc_probe(struct platform_device *pdev)
 	int ret;
 	struct jz4740_rtc *rtc;
 	uint32_t scratchpad;
+	struct resource *mem;
 
 	rtc = devm_kzalloc(&pdev->dev, sizeof(*rtc), GFP_KERNEL);
 	if (!rtc)
@@ -227,25 +227,15 @@ static int jz4740_rtc_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	rtc->mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!rtc->mem) {
+	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!mem) {
 		dev_err(&pdev->dev, "Failed to get platform mmio memory\n");
 		return -ENOENT;
 	}
-
-	rtc->mem = devm_request_mem_region(&pdev->dev, rtc->mem->start,
-					resource_size(rtc->mem), pdev->name);
-	if (!rtc->mem) {
-		dev_err(&pdev->dev, "Failed to request mmio memory region\n");
-		return -EBUSY;
-	}
-
-	rtc->base = devm_ioremap_nocache(&pdev->dev, rtc->mem->start,
-					resource_size(rtc->mem));
-	if (!rtc->base) {
-		dev_err(&pdev->dev, "Failed to ioremap mmio memory\n");
-		return -EBUSY;
-	}
+	mem->flags &= ~IORESOURCE_CACHEABLE;
+	rtc->base = devm_ioremap_resource(&pdev->dev, mem);
+	if (IS_ERR(rtc->base))
+		return PTR_ERR(rtc->base);
 
 	spin_lock_init(&rtc->lock);
 
-- 
1.7.10.4


