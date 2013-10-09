Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065Ab3JIFtv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 01:49:51 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:38134 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab3JIFtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 01:49:50 -0400
X-AuditID: cbfee68e-b7f756d000004512-ea-5254ee7c5649
From: Sangjung Woo <sangjung.woo@samsung.com>
To: Guan Xuetao <gxt@mprc.pku.edu.cn>, Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
        Sangjung Woo <sangjung.woo@samsung.com>
Subject: [PATCH] rtc: rtc-puv3: use dev_dbg() instead of pr_debug()
Date: Wed, 09 Oct 2013 14:49:43 +0900
Message-id: <1381297783-24658-1-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsWyRsSkSLfmXUiQwcy7/BZLLl5ltzh44xu7
	xeVdc9gs9nd2MFos2FPiwOqxZ+JJNo/Hey09+rasYvSYPu8nk8fnTXIBrFFcNimpOZllqUX6
	dglcGc/m/GEp+ChbcejxJqYGxjcSXYycHBICJhLbTxxghLDFJC7cW8/WxcjFISSwlFHiwq/D
	LDBFrZM/sUAkFjFKtHadYgdJCAm0MUmc7TQDsdkEdCWeHLjMDGKLCPhJ7F1wCcjm4GAWSJe4
	9UMVJCws4CyxY3If2DIWAVWJU/3vwMbwCnhIPG67zwJSLiGgIDFnkg3IKgmBz2wS716ug6oX
	kPg2+RBUjazEpgPMEKdJShxccYNlAqPgAkaGVYyiqQXJBcVJ6UVGesWJucWleel6yfm5mxiB
	oXn637O+HYw3D1gfYkwGGjeRWUo0OR8Y2nkl8YbGZkYWpiamxkbmlmakCSuJ86q1WAcKCaQn
	lqRmp6YWpBbFF5XmpBYfYmTi4JRqYFx64uyK8l2KTSnN3IIV/Pf/avBf1rjlGLnY/HTXQheT
	XRfu/+0rqVmq8Cy0S2DBapPorGizOVONJj0/z//p/Ms3j4XTtWPnHpDU/auod2eCzclS349G
	HCV7bk5UZ2W+FyZvtzu19j3fXgNez9s6YktUvLLNLvfI6nWqJ2souQsuyuHsT42aosRSnJFo
	qMVcVJwIACgzQy1jAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLIsWRmVeSWpSXmKPExsVy+t9jAd2adyFBBh0X2S2WXLzKbnHwxjd2
	i8u75rBZ7O/sYLRYsKfEgdVjz8STbB6P91p69G1Zxegxfd5PJo/Pm+QCWKMaGG0yUhNTUosU
	UvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgHYrKZQl5pQChQISi4uV
	9O0wTQgNcdO1gGmM0PUNCYLrMTJAAwlrGDOezfnDUvBRtuLQ401MDYxvJLoYOTkkBEwkWid/
	YoGwxSQu3FvP1sXIxSEksIhRorXrFDtIQkigjUnibKcZiM0moCvx5MBlZhBbRMBPYu+CS0A2
	BwezQLrErR+qIGFhAWeJHZP7GEFsFgFViVP978DG8Ap4SDxuu88CUi4hoCAxZ5LNBEbuBYwM
	qxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCA/+Z1A7GlQ0WhxgFOBiVeHgf8IcECbEmlhVX
	5h5ilOBgVhLhzVsIFOJNSaysSi3Kjy8qzUktPsSYDLR8IrOUaHI+MCrzSuINjU3MjCyNzA0t
	jIzNSRNWEuc90GodKCSQnliSmp2aWpBaBLOFiYNTqoGRjz12qVvZgXLPBqavoYEcidOSsgXT
	w9re/TJ4t/FUv+8mJ5nM5/eMHrr8bs46vkBP3pyPNYtN8iGfiXp0ktsLzWVd8Z1MHtlP5FIb
	n59vCnmft63z3ORIPbfr+pevFWg3s82oX6unfVU8Mmj25KJZyVIve51vqipdvfbo09zPXuKH
	t25LFFZiKc5INNRiLipOBAA7EXgDwAIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because dev_*() are used along with pr_debug() function in this code,
the debug message is not tidy. This patch converts from pr_debug() to
dev_dbg() since dev_*() are encouraged to use in device driver code.

Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>
---
 drivers/rtc/rtc-puv3.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/rtc/rtc-puv3.c b/drivers/rtc/rtc-puv3.c
index 402732c..9167bb0 100644
--- a/drivers/rtc/rtc-puv3.c
+++ b/drivers/rtc/rtc-puv3.c
@@ -57,7 +57,7 @@ static void puv3_rtc_setaie(int to)
 {
 	unsigned int tmp;
 
-	pr_debug("%s: aie=%d\n", __func__, to);
+	dev_dbg(dev, "%s: aie=%d\n", __func__, to);
 
 	tmp = readl(RTC_RTSR) & ~RTC_RTSR_ALE;
 
@@ -71,7 +71,7 @@ static int puv3_rtc_setpie(struct device *dev, int enabled)
 {
 	unsigned int tmp;
 
-	pr_debug("%s: pie=%d\n", __func__, enabled);
+	dev_debug(dev, "%s: pie=%d\n", __func__, enabled);
 
 	spin_lock_irq(&puv3_rtc_pie_lock);
 	tmp = readl(RTC_RTSR) & ~RTC_RTSR_HZE;
@@ -90,7 +90,7 @@ static int puv3_rtc_gettime(struct device *dev, struct rtc_time *rtc_tm)
 {
 	rtc_time_to_tm(readl(RTC_RCNR), rtc_tm);
 
-	pr_debug("read time %02x.%02x.%02x %02x/%02x/%02x\n",
+	dev_dbg(dev, "read time %02x.%02x.%02x %02x/%02x/%02x\n",
 		 rtc_tm->tm_year, rtc_tm->tm_mon, rtc_tm->tm_mday,
 		 rtc_tm->tm_hour, rtc_tm->tm_min, rtc_tm->tm_sec);
 
@@ -101,7 +101,7 @@ static int puv3_rtc_settime(struct device *dev, struct rtc_time *tm)
 {
 	unsigned long rtc_count = 0;
 
-	pr_debug("set time %02d.%02d.%02d %02d/%02d/%02d\n",
+	dev_dbg(dev, "set time %02d.%02d.%02d %02d/%02d/%02d\n",
 		 tm->tm_year, tm->tm_mon, tm->tm_mday,
 		 tm->tm_hour, tm->tm_min, tm->tm_sec);
 
@@ -119,7 +119,7 @@ static int puv3_rtc_getalarm(struct device *dev, struct rtc_wkalrm *alrm)
 
 	alrm->enabled = readl(RTC_RTSR) & RTC_RTSR_ALE;
 
-	pr_debug("read alarm %02x %02x.%02x.%02x %02x/%02x/%02x\n",
+	dev_dbg(dev, "read alarm %02x %02x.%02x.%02x %02x/%02x/%02x\n",
 		 alrm->enabled,
 		 alm_tm->tm_year, alm_tm->tm_mon, alm_tm->tm_mday,
 		 alm_tm->tm_hour, alm_tm->tm_min, alm_tm->tm_sec);
@@ -132,7 +132,7 @@ static int puv3_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 	struct rtc_time *tm = &alrm->time;
 	unsigned long rtcalarm_count = 0;
 
-	pr_debug("puv3_rtc_setalarm: %d, %02x/%02x/%02x %02x.%02x.%02x\n",
+	dev_dbg(dev, "puv3_rtc_setalarm: %d, %02x/%02x/%02x %02x.%02x.%02x\n",
 		 alrm->enabled,
 		 tm->tm_mday & 0xff, tm->tm_mon & 0xff, tm->tm_year & 0xff,
 		 tm->tm_hour & 0xff, tm->tm_min & 0xff, tm->tm_sec);
@@ -140,7 +140,7 @@ static int puv3_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 	rtc_tm_to_time(tm, &rtcalarm_count);
 	writel(rtcalarm_count, RTC_RTAR);
 
-	puv3_rtc_setaie(alrm->enabled);
+	puv3_rtc_setaie(&dev->dev, alrm->enabled);
 
 	if (alrm->enabled)
 		enable_irq_wake(puv3_rtc_alarmno);
@@ -227,7 +227,7 @@ static int puv3_rtc_remove(struct platform_device *dev)
 	rtc_device_unregister(rtc);
 
 	puv3_rtc_setpie(&dev->dev, 0);
-	puv3_rtc_setaie(0);
+	puv3_rtc_setaie(&dev->dev, 0);
 
 	release_resource(puv3_rtc_mem);
 	kfree(puv3_rtc_mem);
@@ -241,7 +241,7 @@ static int puv3_rtc_probe(struct platform_device *pdev)
 	struct resource *res;
 	int ret;
 
-	pr_debug("%s: probe=%p\n", __func__, pdev);
+	dev_dbg(&pdev->dev, "%s: probe=%p\n", __func__, pdev);
 
 	/* find the IRQs */
 	puv3_rtc_tickno = platform_get_irq(pdev, 1);
@@ -256,7 +256,7 @@ static int puv3_rtc_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	pr_debug("PKUnity_rtc: tick irq %d, alarm irq %d\n",
+	dev_dbg(&pdev->dev, "PKUnity_rtc: tick irq %d, alarm irq %d\n",
 		 puv3_rtc_tickno, puv3_rtc_alarmno);
 
 	/* get the memory region */
-- 
1.7.9.5

