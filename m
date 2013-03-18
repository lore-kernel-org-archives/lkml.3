Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab3CRJ3k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 05:29:40 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:32706 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab3CRJ3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 05:29:38 -0400
X-AuditID: cbfee68f-b7f4a6d000001436-6e-5146de81e494
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 01/10] rtc: rtc-at91rm9200: switch to using SIMPLE_DEV_PM_OPS
Date: Mon, 18 Mar 2013 18:29:36 +0900
Message-id: <01b701ce23bb$1b79b2a0$526d17e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4juxtMJTZWEDnPSfOGR4wzonE6SA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t8zA93Ge26BBgsXiVksuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CVcX7mPKaCf5wVCz+vZG5g7OXoYuTkkBAwkZj+bB8zhC0mceHeerYuRi4OIYFljBIX
	1p9lhSlqvn+aCcQWEpjOKLFuRzZE0S9Gif59N8ASbAJqEl++HGbvYuTgEBHQl2hr0QCpYRbo
	ZZQ407ubHaRGWMBXomtWHwtIDYuAqsSzBimQMK+ArcTWB60sELagxI/J98BsZgEtifU7jzNB
	2PISm9e8ZQZplRBQl3j0VxckLCKgJ/Fu4QZmiBIRiX0v3jGCrJUQOMYucffpZ7A5LAICEt8m
	H2KB6JWV2HQA6l9JiYMrbrBMYBSbhWTzLCSbZyHZPAvJigWMLKsYRVMLkguKk9KLjPWKE3OL
	S/PS9ZLzczcxQuKufwfj3QPWhxiTgdZPZJYSTc4Hxm1eSbyhsZmRhamJqbGRuaUZacJK4rxq
	LdaBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhhj3DprXm3+/9fEML9vGef++7LTJh/icr2l
	dMok96bjrsbjuZw/XMMmC86IfeswO1EqYOEnWVZz++Knr6J+LA7rFVhqn/dm8pGlGisUP24s
	fGWhqnsvuG3DYrM03iSew8teXJzGs9Kv4XhYyGL9Ngm+7pknw25MEeFbKbKgmo9z4nKp+S8u
	z7ZWYinOSDTUYi4qTgQA2X3K59ECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jQd3Ge26BBm0NQhZLLl5lt5izfg2b
	xeWFl1gtLu+aw2axv7OD0YHVY8/Ek2weJ2b8ZvHo27KK0WP6vJ9MHp83yQWwRjUw2mSkJqak
	Fimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVdSKEvMKQUKBSQW
	Fyvp22GaEBripmsB0xih6xsSBNdjZIAGEtYxZpyfOY+p4B9nxcLPK5kbGHs5uhg5OSQETCSa
	759mgrDFJC7cW88GYgsJTGeUWLcju4uRC8j+xSjRv+8GWBGbgJrEly+H2bsYOThEBPQl2lo0
	QGqYBXoZJc707mYHqREW8JXomtXHAlLDIqAq8axBCiTMK2ArsfVBKwuELSjxY/I9MJtZQEti
	/c7jTBC2vMTmNW+ZQVolBNQlHv3VBQmLCOhJvFu4gRmiRERi34t3jBMYBWYhmTQLyaRZSCbN
	QtKygJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwVD+T3sG4qsHiEKMAB6MSD++O9W6B
	QqyJZcWVuYcYJTiYlUR4HW8DhXhTEiurUovy44tKc1KLDzEmA/05kVlKNDkfmHDySuINjU3M
	jCyNzCyMTMzNSRNWEuc92GodKCSQnliSmp2aWpBaBLOFiYNTqoHR947aIokXe5+bzftt1xag
	GzV16zJ+c79nz2Jys76we/87blEQuPPU/ozz51celD13Jij1bkJFZ4FfwsLrm/yCA1+1O9sU
	Rh7NW5DEP537YYVUmPj3/Tdm/OF8Njuv4CqTvs11pf1+l07cvaoUW7B7/rxLnbvnseTc5Zgj
	lv3/3fO4aIkZ6UfPK7EUZyQaajEXFScCAM9dRxkuAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to using SIMPLE_DEV_PM_OPS  macro to declare the driver's
pm_ops. It reduces code size.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-at91rm9200.c |   16 ++++------------
 1 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
index f63c8fe..f07bd31 100644
--- a/drivers/rtc/rtc-at91rm9200.c
+++ b/drivers/rtc/rtc-at91rm9200.c
@@ -337,7 +337,7 @@ static int __exit at91_rtc_remove(struct platform_device *pdev)
 	return 0;
 }
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 
 /* AT91RM9200 RTC Power management control */
 
@@ -369,24 +369,16 @@ static int at91_rtc_resume(struct device *dev)
 	}
 	return 0;
 }
-
-static const struct dev_pm_ops at91_rtc_pm = {
-	.suspend =	at91_rtc_suspend,
-	.resume =	at91_rtc_resume,
-};
-
-#define at91_rtc_pm_ptr	&at91_rtc_pm
-
-#else
-#define at91_rtc_pm_ptr	NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(at91_rtc_pm_ops, at91_rtc_suspend, at91_rtc_resume);
+
 static struct platform_driver at91_rtc_driver = {
 	.remove		= __exit_p(at91_rtc_remove),
 	.driver		= {
 		.name	= "at91_rtc",
 		.owner	= THIS_MODULE,
-		.pm	= at91_rtc_pm_ptr,
+		.pm	= &at91_rtc_pm_ops,
 	},
 };
 
-- 
1.7.2.5


