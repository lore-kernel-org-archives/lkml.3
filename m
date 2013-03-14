Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755075Ab3CNIWS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 04:22:18 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:16413 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab3CNIWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 04:22:15 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-32-514188b627ff
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
In-reply-to: <008401ce208b$5c9dc6f0$15d954d0$%han@samsung.com>
Subject: [PATCH 23/30] rtc: rtc-rx4581: use devm_rtc_device_register()
Date: Thu, 14 Mar 2013 17:22:14 +0900
Message-id: <009a01ce208d$0853cbb0$18fb6310$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4gi1x0RMHvEnZmRRqxNJmQP3DTwgAAaGow
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zA91tHY6BBjv36VgsuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CVceFlP1vBZfaKLwtesTUwLmbrYuTkkBAwkdh04DkLhC0mceHeeqA4F4eQwDJGiX1L
	d8AVzTu6lhkiMZ1RYsem94wQzi9GiZ7+62BVbAJqEl++HGbvYuTgEBHQl2hr0QCpYRboZZQ4
	07sbLC4kYCtx/b8diMkpYCexYb0YSKewgJvEvkv3mEFsFgFVifOHNrCD2LxA1Yd+L2WBsAUl
	fky+B2YzC2hJrN95nAnClpfYvOYtM8hICQF1iUd/dUHCIgJGEjMmTGeFKBGR2PfiHSPEK/fY
	JTauT4RYJSDxbfIhFohWWWA4MEOUSEocXHGDZQKjxCwki2chWTwLyeJZSDYsYGRZxSiaWpBc
	UJyUXmSsV5yYW1yal66XnJ+7iRESpf07GO8esD7EmAy0fiKzlGhyPjDK80riDY3NjCxMTUyN
	jcwtzUgTVhLnVWuxDhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAKHm0yF77XIMNc/2OtyYs
	NmUsR74ner7LdNgTXLJ6Kp+qeuiulsPZy20END/ML4jovm0ZvL9tmr6ufVNt2cI5V+cIrmjm
	b9Ju6RTccGty1V4fPp8whd9erB+c2G/FHzh5l2ctu6Xp6+lRj/bmiHUfP/rdZcMECZVSY4VF
	0y+Vvf9h2msicW6ZEktxRqKhFnNRcSIA69w3v+gCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jQd1tHY6BBv+va1gsuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmHHhZT9bwWX2ii8LXrE1MC5m62Lk5JAQMJGY
	d3QtM4QtJnHh3nqgOBeHkMB0Rokdm94zQji/GCV6+q+DdbAJqEl8+XKYvYuRg0NEQF+irUUD
	pIZZoJdR4kzvbrC4kICtxPX/diAmp4CdxIb1YiCdwgJuEvsu3QPbxSKgKnH+0AZ2EJsXqPrQ
	76UsELagxI/J98BsZgEtifU7jzNB2PISm9e8ZQYZKSGgLvHory5IWETASGLGhOmsECUiEvte
	vGOcwCg0C8mkWUgmzUIyaRaSlgWMLKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgpPAM6kd
	jCsbLA4xCnAwKvHwHuh3CBRiTSwrrsw9xCjBwawkwuvp5RgoxJuSWFmVWpQfX1Sak1p8iDEZ
	6NGJzFKiyfnABJVXEm9obGJmZGlkZmFkYm5OmrCSOO+BVutAIYH0xJLU7NTUgtQimC1MHJxS
	DYxTVr9PfiM5JapyQcYrbf/drxfZTtl0rPffx77JxddVP694meY3gUHO1e3XXff16k/vuZ37
	U3ZaMv+I5es86SURztdnPH6/svow0/sHU5kPna+7cOBunlDiol/iinOe71p26K9U6opM+Q8P
	L805/vf0SpHspX/uhfX1b7DKq/uSbWvVYVF0YlfvOiWW4oxEQy3mouJEALy14oVGAwAA
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
 drivers/rtc/rtc-rx4581.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-rx4581.c b/drivers/rtc/rtc-rx4581.c
index 599ec73..d1b88db 100644
--- a/drivers/rtc/rtc-rx4581.c
+++ b/drivers/rtc/rtc-rx4581.c
@@ -273,8 +273,8 @@ static int rx4581_probe(struct spi_device *spi)
 	if (res != 0)
 		return res;
 
-	rtc = rtc_device_register("rx4581",
-				&spi->dev, &rx4581_rtc_ops, THIS_MODULE);
+	rtc = devm_rtc_device_register(&spi->dev, "rx4581",
+				&rx4581_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc))
 		return PTR_ERR(rtc);
 
@@ -284,9 +284,6 @@ static int rx4581_probe(struct spi_device *spi)
 
 static int rx4581_remove(struct spi_device *spi)
 {
-	struct rtc_device *rtc = dev_get_drvdata(&spi->dev);
-
-	rtc_device_unregister(rtc);
 	return 0;
 }
 
-- 
1.7.2.5


