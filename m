Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179AbaCEK4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 05:56:46 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:39848 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754857AbaCEK4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 05:56:45 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-b9-531702eb11ac
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Cc: a.zummo@towertech.it, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH] drivers: rtc: rtc-s3c: remove NO_IRQ macro
Date: Wed, 05 Mar 2014 20:12:55 +0900
Message-id: <1394017975-4963-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFLMWRmVeSWpSXmKPExsVy+t8zY93XTOLBBpcmmlksuXiV3eLyrjls
	Fou2fmG32N/ZwejA4rFn4kk2j74tqxg9ps/7yeTxeZNcAEsUl01Kak5mWWqRvl0CV8bklT3M
	BSfYK5ZuecrewLiCrYuRk0NCwETiTv8MVghbTOLCvfVAcS4OIYFljBK3VjUzwRSt7VzICJFY
	xCgx42ALK4TTxiTxeeFLsHY2AV2JJ+/nMoPYIgI2EocO3wCzmQUcJVZvOQFWIyxgLdF2eAmY
	zSKgKvGtrR3M5hVwl3gyfyFLFyMH0DYFiTmTbEDmSwjcZ5O48+w6E0S9gMS3yYegamQlNh1g
	hjhOUuLgihssExgFFzAyrGIUTS1ILihOSi8y1StOzC0uzUvXS87P3cQICceJOxjvH7A+xJgM
	NG4is5Rocj4wnPNK4g2NzYwsTE1MjY3MLc1IE1YS501/lBQkJJCeWJKanZpakFoUX1Sak1p8
	iJGJg1OqgXG202ZHt/91olrHL00O1n77yddlG0v+o8T9vqcT5J5+iXKzEVhwe3tnX/TcN3Fv
	vpxbW7rIceGM3gwVq9CAa+xrJmk4lGgzGddUXpI8+P66vsW6+1uY7EPC5Pasnrfh1w2+FTc1
	THfxGO/6XHZZk/PHV9Wz83ijH8pkPZXI/buTPYml8t276dxKLMUZiYZazEXFiQBKHeV3XQIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOIsWRmVeSWpSXmKPExsVy+t9jAd3XTOLBBnfmG1ksuXiV3eLyrjls
	Fou2fmG32N/ZwejA4rFn4kk2j74tqxg9ps/7yeTxeZNcAEtUA6NNRmpiSmqRQmpecn5KZl66
	rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBOJYWyxJxSoFBAYnGxkr4dpgmhIW66
	FjCNEbq+IUFwPUYGaCBhHWPG5JU9zAUn2CuWbnnK3sC4gq2LkZNDQsBEYm3nQkYIW0ziwr31
	QHEuDiGBRYwSMw62sEI4bUwSnxe+ZAWpYhPQlXjyfi4ziC0iYCNx6PANMJtZwFFi9ZYTYDXC
	AtYSbYeXgNksAqoS39rawWxeAXeJJ/MXsnQxcgBtU5CYM8lmAiP3AkaGVYyiqQXJBcVJ6bmG
	esWJucWleel6yfm5mxjBwf5MagfjygaLQ4wCHIxKPLwvOMSChVgTy4orcw8xSnAwK4nwprwA
	CvGmJFZWpRblxxeV5qQWH2JMBlo+kVlKNDkfGIl5JfGGxiZmRpZGZhZGJubmpAkrifMeaLUO
	FBJITyxJzU5NLUgtgtnCxMEp1cDIyGX8/Vd0wGuu5lp5Ey5vHc5Zs/ZNuqDpltPbm70xf/9z
	0zuh96QL/wmE9P4QS//U9FnR1W/e/RDn5tmRKfcKAjkzUh+xhbT9UeV1XPlqbYuVJ8cx3xsi
	RlaGN9dcNbO6Eh+3mzetrulhZHI/m8OOx8lzw5P1Wv8cNTO7JpH4t6kiKz7cUImlOCPRUIu5
	qDgRAJi5jsm6AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NO_IRQ may be defined as '(unsigned int) -1' in some architectures
(arm, sh ...), and either may not be defined in some architectures
(arm64) which can enable RTC_DRV_S3C.
Also since platform_get_irq returns err-code in case of any error,
we do not need to intialize s3c_rtc_alarmno and s3c_rtc_tickno.

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 drivers/rtc/rtc-s3c.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
index 7afd373..cf2ebdd 100644
--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -48,8 +48,8 @@ struct s3c_rtc_drv_data {
 
 static struct clk *rtc_clk;
 static void __iomem *s3c_rtc_base;
-static int s3c_rtc_alarmno = NO_IRQ;
-static int s3c_rtc_tickno  = NO_IRQ;
+static int s3c_rtc_alarmno;
+static int s3c_rtc_tickno;
 static enum s3c_cpu_type s3c_rtc_cpu_type;
 
 static DEFINE_SPINLOCK(s3c_rtc_pie_lock);
-- 
1.7.9.5

