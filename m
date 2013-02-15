Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935445Ab3BOHYq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 02:24:46 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:40469 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935392Ab3BOHYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 02:24:45 -0500
X-AuditID: cbfee691-b7f556d000001a24-e2-511de2bbf062
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH V3 01/11] rtc: use dev_warn()/dev_dbg()/pr_err() instead of
 printk()
Date: Fri, 15 Feb 2013 16:24:43 +0900
Message-id: <002b01ce0b4d$865ca950$9315fbf0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4LTYY6VzXwCUtKTcq8t8M0FTt2HQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGIsWRmVeSWpSXmKPExsVy+t8zA93dj2QDDe40GVpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M39PWMhVcF65Ys/czWwNjo0AXIyeHhICJxM1dpxkhbDGJC/fW
	s3UxcnEICSxjlOhZ840Rpuj1/2aoxHRGiW+TfrCAJIQEZjNJTJ2gBGKzCahJfPlymL2LkYND
	REBfoq1FA6SeWaCXUeJM7252kBphgTCJt50gGzg5WARUJXbt/84CUs8rYCtxa3kOSJhXQFDi
	x+R7YOOZBbQkNm9rYoWw5SU2r3nLDFIuIaAu8eivLkhYREBP4tmV6ewQJSIS+168YwRZKyHQ
	zy7xYvcfRohVAhLfJh9igeiVldh0gBniLUmJgytusExgFJuFZPMsJJtnIdk8C8mKBYwsqxhF
	UwuSC4qT0otM9YoTc4tL89L1kvNzNzFC4mTiDsb7B6wPMSYDrZ/ILCWanA+Ms7ySeENjYxMz
	E1MTc0tTc1PShJXEeeUvyQQKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYPTcdy0s7GSV78v4
	N0UXBUXfuVzhy/xQ9EY74vqHQ30cm5xnpLmvfXhmzveW9nMz9u+/d8NK6Ij+iUzmD7lMyjPk
	tJbtLd7OmLKA5zHfjxu3tHyT2VLM3BbYe4qKisnsjzSRuu6Sfk1bqHft2ifsJ3P+P16u/dpM
	/pTaSbbpn6eav8r9E/Xl2x0lluKMREMt5qLiRACpA8/DqQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t9jQd3dj2QDDe716Fhc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjN/T1jIVXBeuWLP3M1sD
	Y6NAFyMnh4SAicTr/81sELaYxIV764FsLg4hgemMEt8m/WABSQgJzGaSmDpBCcRmE1CT+PLl
	MHsXIweHiIC+RFuLBkg9s0Avo8SZ3t3sIDXCAmESbzvXgw1lEVCV2LX/OwtIPa+ArcSt5Tkg
	YV4BQYkfk++BjWcW0JLYvK2JFcKWl9i85i0zSLmEgLrEo7+6IGERAT2JZ1ems0OUiEjse/GO
	cQKjwCwkk2YhmTQLyaRZSFoWMLKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiOwmdSOxhX
	NlgcYhTgYFTi4RWQkA0UYk0sK67MPcQowcGsJMIrdwsoxJuSWFmVWpQfX1Sak1p8iDEZ6M+J
	zFKiyfnABJFXEm9obGJmZGlkZmFkYm5OmrCSOC/jqScBQgLpiSWp2ampBalFMFuYODilGhhF
	c86rXUl/zbi3nie6Yucz3vsT166Wjg8q6P6gY6Fqu2vu/wn+qYvO/Phw9NV6+d/ORruTPTyD
	zyoccgxIznpgvaxf9pH77TMvPvefN3r4gH15uMXP/UL7dry9/uRn9RWps4stHQ1sX2Q/VNaW
	1NX/J7/3WNXtrBuGtQVevpqpdy0anvFXFgspsRRnJBpqMRcVJwIAXdUrAwYDAAA=
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

No Changes since v2:

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


