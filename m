Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935455Ab3BOGmK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 01:42:10 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:32673 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935353Ab3BOGmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 01:42:08 -0500
X-AuditID: cbfee68f-b7f656d000000d78-71-511dd8b8456d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH V2 01/11] rtc: use dev_warn()/dev_dbg()/pr_err() instead of
 printk()
Date: Fri, 15 Feb 2013 15:42:00 +0900
Message-id: <001e01ce0b47$8edd1480$ac973d80$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4LR47AXgjtu6e1Qmq7gnKtv11nag==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOIsWRmVeSWpSXmKPExsVy+t8zfd2dN2QDDf5dZLS4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZn3fPYSrYL1yx+s1+lgbGD/xdjJwcEgImEqu7/7NC2GISF+6t
	Z+ti5OIQEljGKLFowzRmmKJJm/6ygdhCAosYJZ7csYcoms0k0XCpiREkwSagJvHly2H2LkYO
	DhEBfYm2Fg2QGmaBXkaJM7272UFqhAXCJBY+7gAbxCKgKnFizlQwm1fAVmJf6wVGCFtQ4sfk
	eywgNrOAlsTmbU2sELa8xOY1b5lB5ksIqEs8+qsLEhYR0JM4cOcYG0SJiMS+F+8YQfZKCHSz
	S7ybexxql4DEt8mHWCB6ZSU2HYD6S1Li4IobLBMYxWYh2TwLyeZZSDbPQrJiASPLKkbR1ILk
	guKk9CJjveLE3OLSvHS95PzcTYyQSOnfwXj3gPUhxmSg9ROZpUST84GRllcSb2hsbGJmYmpi
	bmlqbkqasJI4r/wlmUAhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjHPef6izK30pzhzze3n7
	7Qun0171sKcFRzzgVV/j9vnjzqsrbp3d/2xbVZBtshzj5v3+vTsmXlvkffwbS8E0LctS771q
	BzV5EqSFfS6XiXgebf317fAPyT9/Fp02eZTlyjmt8LmH3s13a6QPnzfubpe//3efWpqCim/S
	G+fMHHelEyEH/qT++qfEUpyRaKjFXFScCAAboiCbqgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCIsWRmVeSWpSXmKPExsVy+t9jAd0dN2QDDd6ssbK4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGZ93z2Eq2C9csfrNfpYG
	xg/8XYycHBICJhKTNv1lg7DFJC7cWw9mCwksYpR4cse+i5ELyJ7NJNFwqYkRJMEmoCbx5cth
	9i5GDg4RAX2JthYNkBpmgV5GiTO9u9lBaoQFwiQWPu4AG8QioCpxYs5UMJtXwFZiX+sFRghb
	UOLH5HssIDazgJbE5m1NrBC2vMTmNW+ZQeZLCKhLPPqrCxIWEdCTOHDnGBtEiYjEvhfvGCcw
	CsxCMmkWkkmzkEyahaRlASPLKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzgOHwmtYNxZYPF
	IUYBDkYlHl4BCdlAIdbEsuLK3EOMEhzMSiK8a0KAQrwpiZVVqUX58UWlOanFhxiTgR6dyCwl
	mpwPTBF5JfGGxiZmRpZGZhZGJubmpAkrifMynnoSICSQnliSmp2aWpBaBLOFiYNTqoGR2SRp
	zqOzQm48HtlxZ/TkFI/EHhJW9vr5zzm7Q+19/PxMzpBa5ubX9mfD8t+f0p2RpnyzS/5DHtOd
	bpmYlOdxEakfVE+4evor/lj5mC9wE5fmN9bJlzyPPte1Mzo696X/hd18yuvklQV2ZQgW2jrz
	vev52Ont4m/m5WFtafPr9EO1m2uLLimxFGckGmoxFxUnAgCmDlZEBwMAAA==
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
Changes since v1:
- Repalce pr_warn(), pr_debug() with dev_warn(), dev_dbg()

 drivers/rtc/class.c   |    4 +++-
 drivers/rtc/rtc-dev.c |   11 ++++++-----
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index 26388f1..9b742d3 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -11,6 +11,8 @@
  * published by the Free Software Foundation.
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/rtc.h>
 #include <linux/kdev_t.h>
@@ -261,7 +263,7 @@ static int __init rtc_init(void)
 {
 	rtc_class = class_create(THIS_MODULE, "rtc");
 	if (IS_ERR(rtc_class)) {
-		printk(KERN_ERR "%s: couldn't create class\n", __FILE__);
+		pr_err("couldn't create class\n");
 		return PTR_ERR(rtc_class);
 	}
 	rtc_class->suspend = rtc_suspend;
diff --git a/drivers/rtc/rtc-dev.c b/drivers/rtc/rtc-dev.c
index 9a86b4b..d049393 100644
--- a/drivers/rtc/rtc-dev.c
+++ b/drivers/rtc/rtc-dev.c
@@ -11,6 +11,8 @@
  * published by the Free Software Foundation.
 */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/rtc.h>
 #include <linux/sched.h>
@@ -462,7 +464,7 @@ void rtc_dev_prepare(struct rtc_device *rtc)
 		return;
 
 	if (rtc->id >= RTC_DEV_MAX) {
-		pr_debug("%s: too many RTC devices\n", rtc->name);
+		dev_dbg(&rtc->dev, "%s: too many RTC devices\n", rtc->name);
 		return;
 	}
 
@@ -480,10 +482,10 @@ void rtc_dev_prepare(struct rtc_device *rtc)
 void rtc_dev_add_device(struct rtc_device *rtc)
 {
 	if (cdev_add(&rtc->char_dev, rtc->dev.devt, 1))
-		printk(KERN_WARNING "%s: failed to add char device %d:%d\n",
+		dev_warn(&rtc->dev, "%s: failed to add char device %d:%d\n",
 			rtc->name, MAJOR(rtc_devt), rtc->id);
 	else
-		pr_debug("%s: dev (%d:%d)\n", rtc->name,
+		dev_dbg(&rtc->dev, "%s: dev (%d:%d)\n", rtc->name,
 			MAJOR(rtc_devt), rtc->id);
 }
 
@@ -499,8 +501,7 @@ void __init rtc_dev_init(void)
 
 	err = alloc_chrdev_region(&rtc_devt, 0, RTC_DEV_MAX, "rtc");
 	if (err < 0)
-		printk(KERN_ERR "%s: failed to allocate char dev region\n",
-			__FILE__);
+		pr_err("failed to allocate char dev region\n");
 }
 
 void __exit rtc_dev_exit(void)
-- 
1.7.2.5


