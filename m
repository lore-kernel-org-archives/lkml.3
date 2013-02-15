Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935563Ab3BOHaE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 02:30:04 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:58564 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935388Ab3BOHaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 02:30:01 -0500
X-AuditID: cbfee68d-b7f4f6d000004209-13-511de3f8ef1b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <002b01ce0b4d$865ca950$9315fbf0$%han@samsung.com>
In-reply-to: <002b01ce0b4d$865ca950$9315fbf0$%han@samsung.com>
Subject: [PATCH V3 08/11] rtc: rtc-vr41xx: use dev_info() instead of printk()
Date: Fri, 15 Feb 2013 16:30:00 +0900
Message-id: <003201ce0b4e$43371100$c9a53300$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4LTYY6VzXwCUtKTcq8t8M0FTt2HQAAKf8Q
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDIsWRmVeSWpSXmKPExsVy+t8zY90fj2UDDX7vULO4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZh3p5CuaxVTw5Po29gbGXtYuRk0NCwERi8cVWZghbTOLCvfVs
	XYxcHEICyxgl5vQvYIYpmnTiMhOILSQwnVHiy7wiCHs2k8TZraUgNpuAmsSXL4fZuxg5OEQE
	9CXaWjRA5jAL9DJKnOndzQ5Rbysx9fc3sMWcAnYSqyd1gMWFBXwlHqyZATafRUBVYuHd46wg
	c3iB6t89UQYJ8woISvyYfI8FxGYW0JLYvK2JFcKWl9i85i0zSLmEgLrEo7+6IGERASOJy923
	GCFKRCT2vXjHCHKOhMAidokVs76yQqwSkPg2+RALRK+sxKYDUN9KShxccYNlAqPELCSbZyHZ
	PAvJ5llIVixgZFnFKJpakFxQnJReZKhXnJhbXJqXrpecn7uJERJTvTsYbx+wPsSYDLR+IrOU
	aHI+MCbzSuINjY1NzExMTcwtTc1NSRNWEueVuyQTKCSQnliSmp2aWpBaFF9UmpNafIiRiYNT
	qoExzMhOIP2H4D3xp2+W68283NasdPKM9SvX/W9/WP9d3szts69wxXfT/c2qazdLKAkIxiU9
	6OE8c2mvqdY8029Pl76fEipWOelCs2rqF9bIGZXPohx1E7rsck/8YtLW31IlwlASGrjwjuOt
	ZEGXCqkTKSHhjkb/mY81CPeJlmmpPklMOvLN/4QSS3FGoqEWc1FxIgBsBfhDvwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkleLIzCtJLcpLzFFi42I5/e+xoO6Px7KBBms3KVpc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjEO9PAXz2CqeHJ/G3sDY
	y9rFyMkhIWAiMenEZSYIW0ziwr31bCC2kMB0Rokv84og7NlMEme3loLYbAJqEl++HGbvYuTg
	EBHQl2hr0ehi5OJgFuhllDjTu5sdot5WYurvb2DzOQXsJFZP6gCLCwv4SjxYMwNsF4uAqsTC
	u8dZQebwAtW/e6IMEuYVEJT4MfkeC4jNLKAlsXlbEyuELS+xec1bZpByCQF1iUd/dUHCIgJG
	Epe7bzFClIhI7HvxjnECo9AsJJNmIZk0C8mkWUhaFjCyrGIUTS1ILihOSs810itOzC0uzUvX
	S87P3cQIjthn0jsYVzVYHGIU4GBU4uEVkJANFGJNLCuuzD3EKMHBrCTCK3cLKMSbklhZlVqU
	H19UmpNafIgxGejPicxSosn5wGSSVxJvaGxiZmRpZGZhZGJuTpqwkjgv46knAUIC6Yklqdmp
	qQWpRTBbmDg4pRoYA8Wt8rZe1rnkEv/Qe0LrrGyW+5vST1nePHQp8rDMoX/7TiVPLftepGUs
	F9wkIuKvN/9R6M0JeWeT4lYEFS5bzLT1302BmxFnpNbY51z82HM1ypDp/0bjLSkd2xVW/2fZ
	PKvp8U47rTTXqP11MyPduzkjxBj4Tfd5mx0+7LHIzJXXLUvg7cXVSizFGYmGWsxFxYkAqxXW
	exwDAAA=
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

 drivers/rtc/rtc-vr41xx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-vr41xx.c b/drivers/rtc/rtc-vr41xx.c
index 6c3774c..f91be04 100644
--- a/drivers/rtc/rtc-vr41xx.c
+++ b/drivers/rtc/rtc-vr41xx.c
@@ -352,7 +352,7 @@ static int rtc_probe(struct platform_device *pdev)
 	disable_irq(aie_irq);
 	disable_irq(pie_irq);
 
-	printk(KERN_INFO "rtc: Real Time Clock of NEC VR4100 series\n");
+	dev_info(&pdev->dev, "Real Time Clock of NEC VR4100 series\n");
 
 	return 0;
 
-- 
1.7.2.5


