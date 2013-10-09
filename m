Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab3JIGhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 02:37:47 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:38061 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab3JIGhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 02:37:46 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-c9-5254f9592614
From: Sangjung Woo <sangjung.woo@samsung.com>
To: Guan Xuetao <gxt@mprc.pku.edu.cn>, Alessandro Zummo <a.zummo@towertech.it>
Cc: Joe Perches <joe@perches.com>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, Sangjung Woo <sangjung.woo@samsung.com>
Subject: [PATCH v2] rtc: rtc-puv3: use dev_dbg() instead of pr_debug()
Date: Wed, 09 Oct 2013 15:36:05 +0900
Message-id: <1381300565-27203-1-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsWyRsSkUDfyZ0iQweJXhhZLLl5ltzh44xu7
	xez7j1ksLu+aw2axv7OD0WLBnhIHNo89E0+yeTzea+nxZdU1Zo++LasYPabP+8nk8XmTXABb
	FJdNSmpOZllqkb5dAlfG2muzWAomyFd8//6evYHxvWQXIyeHhICJxPfVl1ggbDGJC/fWs4HY
	QgJLGSX2/fGHqdn9bhJrFyMXUHwRo8Tiae/YIJw2JomtR/6CdbMJ6Eo8OXCZGcQWEfCT2Lvg
	EjNIEbNAG6PE+1M7wIqEBdwkjrx5D1bEIqAq8aelHSzOK+Ah0bFlF3sXIwfQOgWJOZNsQHol
	BP6zSczY9JgJol5A4tvkQywQNbISmw4wQ1wnKXFwxQ2WCYyCCxgZVjGKphYkFxQnpReZ6BUn
	5haX5qXrJefnbmIEhuzpf88m7GC8d8D6EGMy0LiJzFKiyfnAkM8riTc0NjOyMDUxNTYytzQj
	TVhJnFe9xTpQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6PVM7XQW0X3D3wu/qPXtcx4V6jS
	1INabMwvPm20L42razQOvyhw1lTHITaiLJVvc/5W/+uKVau0i3Uy71zeNyv+vY+G/RS1Dzcf
	fX/4WDtUdcbaRxxMV076nw/9UvK8PLFapu/Ab842F8kDzOlHgxS4N3vy7r29OLvi/Psl0veF
	Zt489LjXu1aJpTgj0VCLuag4EQBUz2jhbwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t9jAd3InyFBBjO/alosuXiV3eLgjW/s
	FrPvP2axuLxrDpvF/s4ORosFe0oc2Dz2TDzJ5vF4r6XHl1XXmD36tqxi9Jg+7yeTx+dNcgFs
	UQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAVygp
	lCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCWsYM9Zem8VSMEG+4vv39+wNjO8l
	uxg5OSQETCR2v5vECmGLSVy4t56ti5GLQ0hgEaPE4mnvoJw2JomtR/6ygFSxCehKPDlwmRnE
	FhHwk9i74BIzSBGzQBujxPtTO8CKhAXcJI68eQ9WxCKgKvGnpR0szivgIdGxZRd7FyMH0DoF
	iTmTbCYwci9gZFjFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERwTz6R3MK5qsDjEKMDBqMTD
	+4A/JEiINbGsuDL3EKMEB7OSCG/eQqAQb0piZVVqUX58UWlOavEhxmSg5ROZpUST84HxmlcS
	b2hsYmZkaWRuaGFkbE6asJI478FW60AhgfTEktTs1NSC1CKYLUwcnFINjK2WBi1P3hW//aKi
	smf7wQPpnBlCj+RS+GIafph2F8vv4NDfnFD3XW3VFV9J79NvVUpDIrc9mBwsfGe9+hGhXmUm
	XqU/f576nq9ruvsgw5+BwVx6/37L6R/WbPw6+dtGRv7jrOL5mv7MDVc+74i43nF32sLHzb/d
	bV+t+ChonxLO2rT1n+ilq0osxRmJhlrMRcWJAPswHq/NAgAA
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
 drivers/rtc/rtc-puv3.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/rtc/rtc-puv3.c b/drivers/rtc/rtc-puv3.c
index 402732c..1ecfe3b 100644
--- a/drivers/rtc/rtc-puv3.c
+++ b/drivers/rtc/rtc-puv3.c
@@ -53,11 +53,11 @@ static irqreturn_t puv3_rtc_tickirq(int irq, void *id)
 }
 
 /* Update control registers */
-static void puv3_rtc_setaie(int to)
+static void puv3_rtc_setaie(struct device *dev, int to)
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

