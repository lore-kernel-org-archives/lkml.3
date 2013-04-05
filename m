Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161107Ab3DEBt2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 21:49:28 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:45760 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161029Ab3DEBt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 21:49:27 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-78-515e2d999031
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000101ce319f$87f2a3f0$97d7ebd0$%han@samsung.com>
In-reply-to: <000101ce319f$87f2a3f0$97d7ebd0$%han@samsung.com>
Subject: [PATCH 6/7] rtc: rtc-m41t93: use spi_set_drvdata()
Date: Fri, 05 Apr 2013 10:49:12 +0900
Message-id: <000601ce319f$c5f10070$51d30150$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4xn4fH39zvwb7bR32L9HOXANRbigAADMxw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zQ92ZunGBBu/OiFgsuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CVMbE3uuAUa0XT73dMDYxnWLoYOTkkBEwk5i59yAZhi0lcuLceyObiEBJYxijx5nMb
	K0zRnPvboRKLGCVOXupkhXB+MUocPHGYEaSKTUBN4suXw+xdjBwcIgL6Em0tGiA1zAK9jBJn
	enezg9QICdhKrP7TA7aaU8BO4uu8DWC9wgLWErvubgWrYRFQlfgycQdYDS9Q/e3jj9ghbEGJ
	H5PvgcWZBbQk1u88zgRhy0tsXvOWGWSvhIC6xKO/uiBhEQEjidtbP0GViEjse/GOEeQeCYF7
	7BL/Xu1kgtglIPFt8iEWiF5ZiU0HmCEelpQ4uOIGywRGiVlINs9CsnkWks2zkKxYwMiyilE0
	tSC5oDgpvchUrzgxt7g0L10vOT93EyMkUifuYLx/wPoQYzLQ+onMUqLJ+cBIzyuJNzQ2M7Iw
	NTE1NjK3NCNNWEmcV73FOlBIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDo9fMkjP18Xdc/6af
	0hO/wDd/sbkyxyxXLcZVv53vbOuoEZBadWZSqBJ7ztM9Vnr1q5w8jXIz2jqMqpdV/9limZTt
	KD3RRiM4YMcBfybWP6mfamf8K73+Wm27vAGD++wtqzL5DOwsdTcvX23p9ZUjSGm50ZWK31Jm
	h9nZH21jtZwXeDb6FetlJZbijERDLeai4kQAWyArh+oCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jAd2ZunGBBj9XCFgsuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmDGxN7rgFGtF0+93TA2MZ1i6GDk5JARMJObc
	384GYYtJXLi3Hsjm4hASWMQocfJSJyuE84tR4uCJw4wgVWwCahJfvhxm72Lk4BAR0Jdoa9EA
	qWEW6GWUONO7mx2kRkjAVmL1nx6wDZwCdhJf520A6xUWsJbYdXcrWA2LgKrEl4k7wGp4gepv
	H3/EDmELSvyYfA8sziygJbF+53EmCFteYvOat8wgeyUE1CUe/dUFCYsIGEnc3voJqkREYt+L
	d4wTGIVmIZk0C8mkWUgmzULSsoCRZRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcBp4JrWD
	cWWDxSFGAQ5GJR7ejL7YQCHWxLLiytxDjBIczEoivDv54gKFeFMSK6tSi/Lji0pzUosPMSYD
	PTqRWUo0OR+YovJK4g2NTcyMLI3MLIxMzM1JE1YS5z3Qah0oJJCeWJKanZpakFoEs4WJg1Oq
	gTHvTeDT+V1lX6xn7I/uWMBh8VKhLI0l4ZVT/7afuvwsZf6iFzk+VU701HNL5m9wffvx0nVZ
	+aLbj8Ti1JlelqZkNCQxstq+XbBlm/EXw2/zXgnv6BLeVlnyao50SKq7yvKQYK9VR/ef+PR/
	xbbenU0tnW+ssjZM7yu4Wbyf0/u7xKa14iUfniuxFGckGmoxFxUnAgANSR1mRwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper functions for getting and setting the driver data using
spi_device instead of using dev_{get|set}_drvdata with &spi->dev, so we
can directly pass a struct spi_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-m41t93.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-m41t93.c b/drivers/rtc/rtc-m41t93.c
index cfc21a1..9707d36 100644
--- a/drivers/rtc/rtc-m41t93.c
+++ b/drivers/rtc/rtc-m41t93.c
@@ -189,7 +189,7 @@ static int m41t93_probe(struct spi_device *spi)
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
 
-	dev_set_drvdata(&spi->dev, rtc);
+	spi_set_drvdata(spi, rtc);
 
 	return 0;
 }
-- 
1.7.2.5


