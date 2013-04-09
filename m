Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937210Ab3DIJrg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:47:36 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:9225 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933110Ab3DIJrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:47:33 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-f2-5163e3b30272
From: Vivek Gautam <gautam.vivek@samsung.com>
To: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org, a.zummo@towertech.it,
        kgene.kim@samsung.com, dianders@chromium.org
Subject: [PATCH RFC] rtc: rtc-s3c: use clk_prepare_enable and
 clk_disable_unprepare
Date: Tue, 09 Apr 2013 15:15:44 +0530
Message-id: <1365500744-14839-1-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsWyRsSkTnfz4+RAg8PL5C2WXLzKbnF22UE2
	i94FV9ksLu+aw2Yx4/w+Jov9nR2MDmwesxsusnjsmXiSzaNvyypGj+nzfjJ5fN4kF8AaxWWT
	kpqTWZZapG+XwJXR86WVuWBiRMX8FV2MDYxfPbsYOTkkBEwk7m84ygRhi0lcuLeeDcQWEljK
	KNFw06SLkQOsZtMjni5GLqDwdEaJP7M+MkE4U5gk/jz7xQLSwCagK9H0dhcjiC0iYCOxclY/
	K4jNLJAtsXZTM9gCYYFQiZUth9hAhrIIqErcOi8AYvIKeEgceaQEcYKCxJvbz5hBxksI/GeT
	OPq2G+weFgEBiW+TD7FA3CMrsekAM0S9pMTBFTdYJjAKLmBkWMUomlqQXFCclF5kqlecmFtc
	mpeul5yfu4kRGKan/z2buIPx/gHrQ4zJQOMmMkuJJucDwzyvJN7Q2MzIwtTE1NjI3NKMNGEl
	cV71FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYwm53IETmxROBxaVpzie7pdSOL5vrvL
	5MRnz+ZmZO9P5Uw++T3sPd/mDUbZIhNCNv6WaOF5lO389WWPh/TaZ2pZrOzq6U1r+W4eSolP
	tL3g4Br7c3HYdekkhYNcS7TWsx8rs9759+XmqzIrL6+RuDk7iKlhj9K0LXJMunrfGVjadtut
	Mwy+pKLEUpyRaKjFXFScCADimfjxaQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCIsWRmVeSWpSXmKPExsVy+t9jQd3Nj5MDDX5cErVYcvEqu8XZZQfZ
	LHoXXGWzuLxrDpvFjPP7mCz2d3YwOrB5zG64yOKxZ+JJNo++LasYPabP+8nk8XmTXABrVAOj
	TUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QCUoKZYk5
	pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwhrGjJ4vrcwFEyMq5q/oYmxg/OrZxcjB
	ISFgIrHpEU8XIyeQKSZx4d56ti5GLg4hgemMEn9mfWSCcKYwSfx59osFpIpNQFei6e0uRhBb
	RMBGYuWsflYQm1kgW2LtpmYmEFtYIFRiZcshNpAFLAKqErfOC4CYvAIeEkceKUHsUpB4c/sZ
	8wRG7gWMDKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxguPgmfQOxlUNFocYBTgYlXh4LzxJ
	ChRiTSwrrsw9xCjBwawkwttyJzlQiDclsbIqtSg/vqg0J7X4EGMy0O6JzFKiyfnAGM0riTc0
	NjE3NTa1NLEwMbMkTVhJnPdgq3WgkEB6YklqdmpqQWoRzBYmDk6pBka9D+cyyo6tmlzgVZHr
	PlOJo9LvOffy4vD5oRoZYY1ejCW9j6wi6l+LHTT9u1Dl7b/+O5tcuQ4+9Hs3Q/NMV+MVpdZT
	N9zr7lufXS19ZqPC2YBPC9tvz7yltKlQ5gCX2n+R3CVHXDJjv1RFCtrwrNtx89+W9EO35Q80
	psrOOdt4o+SUxNPNGWuVWIozEg21mIuKEwH+gju6xwIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert clk_enable/clk_disable to clk_prepare_enable/clk_disable_unprepare
calls as required by common clock framework, to get rid of
WARN_ON on prepare_count.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---

This fixes the warnings in the boot log coming out of enabling
the common clock framework in exynos platform.

However, on doing system suspend/resume using rtc wake mechanism
we still get following warning dump for the first time we suspend
using commands:
    echo +10 > /sys/class/rtc/rtc0/wakealarm
    echo mem > /sys/power/state

[   12.530000] ------------[ cut here ]------------
[   12.530000] WARNING: at kernel/mutex.c:199 __mutex_lock_slowpath+0x2c0/0x340()
[   12.530000] Modules linked in:
[   12.530000] [<80014c60>] (unwind_backtrace+0x0/0xf8) from [<8001ebd0>] (warn_slowpath_common+0x54/0x68)
[   12.530000] [<8001ebd0>] (warn_slowpath_common+0x54/0x68) from [<8001ec00>] (warn_slowpath_null+0x1c/0x24)
[   12.530000] [<8001ec00>] (warn_slowpath_null+0x1c/0x24) from [<8033f548>] (__mutex_lock_slowpath+0x2c0/0x340)
[   12.530000] [<8033f548>] (__mutex_lock_slowpath+0x2c0/0x340) from [<8033f5d4>] (mutex_lock+0xc/0x24)
[   12.530000] [<8033f5d4>] (mutex_lock+0xc/0x24) from [<80299e18>] (clk_prepare+0x18/0x34)
[   12.530000] [<80299e18>] (clk_prepare+0x18/0x34) from [<802862d8>] (s3c_rtc_alarmirq+0x1c/0x98)
[   12.530000] [<802862d8>] (s3c_rtc_alarmirq+0x1c/0x98) from [<8006ad78>] (handle_irq_event_percpu+0x54/0x194)
[   12.530000] [<8006ad78>] (handle_irq_event_percpu+0x54/0x194) from [<8006aef4>] (handle_irq_event+0x3c/0x5c)
[   12.530000] [<8006aef4>] (handle_irq_event+0x3c/0x5c) from [<8006db00>] (handle_fasteoi_irq+0xa4/0x134)
[   12.530000] [<8006db00>] (handle_fasteoi_irq+0xa4/0x134) from [<8006a594>] (generic_handle_irq+0x30/0x40)
[   12.530000] [<8006a594>] (generic_handle_irq+0x30/0x40) from [<8000f4fc>] (handle_IRQ+0x40/0x90)
[   12.530000] [<8000f4fc>] (handle_IRQ+0x40/0x90) from [<80008544>] (gic_handle_irq+0x38/0x68)
[   12.530000] [<80008544>] (gic_handle_irq+0x38/0x68) from [<8000e200>] (__irq_svc+0x40/0x70)
[   12.530000] Exception stack(0x8182be60 to 0x8182bea8)
[   12.530000] be60: 00000000 00000000 0000000c ffffffff 60000013 8049fc50 00000000 80479a10
[   12.530000] be80: 60000013 ee97de98 804799c0 00000001 0000000d 8182bea8 803412dc 803412e0
[   12.530000] bea0: 60000013 ffffffff
[   12.530000] [<8000e200>] (__irq_svc+0x40/0x70) from [<803412e0>] (_raw_spin_unlock_irqrestore+0x10/0x38)
[   12.530000] [<803412e0>] (_raw_spin_unlock_irqrestore+0x10/0x38) from [<80070bc4>] (resume_irqs+0x9c/0xb8)
[   12.530000] [<80070bc4>] (resume_irqs+0x9c/0xb8) from [<8021d528>] (dpm_resume_start+0xc/0x18)
[   12.530000] [<8021d528>] (dpm_resume_start+0xc/0x18) from [<800544ac>] (suspend_devices_and_enter+0x118/0x2e4)
[   12.530000] [<800544ac>] (suspend_devices_and_enter+0x118/0x2e4) from [<80054814>] (pm_suspend+0x19c/0x214)
[   12.530000] [<80054814>] (pm_suspend+0x19c/0x214) from [<80053a58>] (state_store+0x120/0x12c)
[   12.530000] [<80053a58>] (state_store+0x120/0x12c) from [<801ae9d8>] (kobj_attr_store+0x14/0x20)
[   12.530000] [<801ae9d8>] (kobj_attr_store+0x14/0x20) from [<801092c8>] (sysfs_write_file+0xfc/0x17c)
[   12.530000] [<801092c8>] (sysfs_write_file+0xfc/0x17c) from [<800b0d84>] (vfs_write+0xa8/0x138)
[   12.530000] [<800b0d84>] (vfs_write+0xa8/0x138) from [<800b10e4>] (sys_write+0x40/0x68)
[   12.530000] [<800b10e4>] (sys_write+0x40/0x68) from [<8000e600>] (ret_fast_syscall+0x0/0x30)
[   12.530000] ---[ end trace 8643216fba2e8cb5 ]---

 drivers/rtc/rtc-s3c.c |   58 ++++++++++++++++++++++++------------------------
 1 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
index fb994e9..75637ad 100644
--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -65,12 +65,12 @@ static void s3c_rtc_alarm_clk_enable(bool enable)
 	spin_lock_irqsave(&s3c_rtc_alarm_clk_lock, irq_flags);
 	if (enable) {
 		if (!alarm_clk_enabled) {
-			clk_enable(rtc_clk);
+			clk_prepare_enable(rtc_clk);
 			alarm_clk_enabled = true;
 		}
 	} else {
 		if (alarm_clk_enabled) {
-			clk_disable(rtc_clk);
+			clk_disable_unprepare(rtc_clk);
 			alarm_clk_enabled = false;
 		}
 	}
@@ -83,13 +83,13 @@ static irqreturn_t s3c_rtc_alarmirq(int irq, void *id)
 {
 	struct rtc_device *rdev = id;
 
-	clk_enable(rtc_clk);
+	clk_prepare_enable(rtc_clk);
 	rtc_update_irq(rdev, 1, RTC_AF | RTC_IRQF);
 
 	if (s3c_rtc_cpu_type == TYPE_S3C64XX)
 		writeb(S3C2410_INTP_ALM, s3c_rtc_base + S3C2410_INTP);
 
-	clk_disable(rtc_clk);
+	clk_disable_unprepare(rtc_clk);
 
 	s3c_rtc_alarm_clk_enable(false);
 
@@ -100,13 +100,13 @@ static irqreturn_t s3c_rtc_tickirq(int irq, void *id)
 {
 	struct rtc_device *rdev = id;
 
-	clk_enable(rtc_clk);
+	clk_prepare_enable(rtc_clk);
 	rtc_update_irq(rdev, 1, RTC_PF | RTC_IRQF);
 
 	if (s3c_rtc_cpu_type == TYPE_S3C64XX)
 		writeb(S3C2410_INTP_TIC, s3c_rtc_base + S3C2410_INTP);
 
-	clk_disable(rtc_clk);
+	clk_disable_unprepare(rtc_clk);
 	return IRQ_HANDLED;
 }
 
@@ -117,14 +117,14 @@ static int s3c_rtc_setaie(struct device *dev, unsigned int enabled)
 
 	dev_dbg(dev, "%s: aie=%d\n", __func__, enabled);
 
-	clk_enable(rtc_clk);
+	clk_prepare_enable(rtc_clk);
 	tmp = readb(s3c_rtc_base + S3C2410_RTCALM) & ~S3C2410_RTCALM_ALMEN;
 
 	if (enabled)
 		tmp |= S3C2410_RTCALM_ALMEN;
 
 	writeb(tmp, s3c_rtc_base + S3C2410_RTCALM);
-	clk_disable(rtc_clk);
+	clk_disable_unprepare(rtc_clk);
 
 	s3c_rtc_alarm_clk_enable(enabled);
 
@@ -141,7 +141,7 @@ static int s3c_rtc_setfreq(struct device *dev, int freq)
 	if (!is_power_of_2(freq))
 		return -EINVAL;
 
-	clk_enable(rtc_clk);
+	clk_prepare_enable(rtc_clk);
 	spin_lock_irq(&s3c_rtc_pie_lock);
 
 	if (s3c_rtc_cpu_type != TYPE_S3C64XX) {
@@ -163,7 +163,7 @@ static int s3c_rtc_setfreq(struct device *dev, int freq)
 
 	writel(tmp, s3c_rtc_base + S3C2410_TICNT);
 	spin_unlock_irq(&s3c_rtc_pie_lock);
-	clk_disable(rtc_clk);
+	clk_disable_unprepare(rtc_clk);
 
 	return 0;
 }
@@ -175,7 +175,7 @@ static int s3c_rtc_gettime(struct device *dev, struct rtc_time *rtc_tm)
 	unsigned int have_retried = 0;
 	void __iomem *base = s3c_rtc_base;
 
-	clk_enable(rtc_clk);
+	clk_prepare_enable(rtc_clk);
  retry_get_time:
 	rtc_tm->tm_min  = readb(base + S3C2410_RTCMIN);
 	rtc_tm->tm_hour = readb(base + S3C2410_RTCHOUR);
@@ -209,7 +209,7 @@ static int s3c_rtc_gettime(struct device *dev, struct rtc_time *rtc_tm)
 
 	rtc_tm->tm_mon -= 1;
 
-	clk_disable(rtc_clk);
+	clk_disable_unprepare(rtc_clk);
 	return rtc_valid_tm(rtc_tm);
 }
 
@@ -229,14 +229,14 @@ static int s3c_rtc_settime(struct device *dev, struct rtc_time *tm)
 		return -EINVAL;
 	}
 
-	clk_enable(rtc_clk);
+	clk_prepare_enable(rtc_clk);
 	writeb(bin2bcd(tm->tm_sec),  base + S3C2410_RTCSEC);
 	writeb(bin2bcd(tm->tm_min),  base + S3C2410_RTCMIN);
 	writeb(bin2bcd(tm->tm_hour), base + S3C2410_RTCHOUR);
 	writeb(bin2bcd(tm->tm_mday), base + S3C2410_RTCDATE);
 	writeb(bin2bcd(tm->tm_mon + 1), base + S3C2410_RTCMON);
 	writeb(bin2bcd(year), base + S3C2410_RTCYEAR);
-	clk_disable(rtc_clk);
+	clk_disable_unprepare(rtc_clk);
 
 	return 0;
 }
@@ -247,7 +247,7 @@ static int s3c_rtc_getalarm(struct device *dev, struct rtc_wkalrm *alrm)
 	void __iomem *base = s3c_rtc_base;
 	unsigned int alm_en;
 
-	clk_enable(rtc_clk);
+	clk_prepare_enable(rtc_clk);
 	alm_tm->tm_sec  = readb(base + S3C2410_ALMSEC);
 	alm_tm->tm_min  = readb(base + S3C2410_ALMMIN);
 	alm_tm->tm_hour = readb(base + S3C2410_ALMHOUR);
@@ -299,7 +299,7 @@ static int s3c_rtc_getalarm(struct device *dev, struct rtc_wkalrm *alrm)
 	else
 		alm_tm->tm_year = -1;
 
-	clk_disable(rtc_clk);
+	clk_disable_unprepare(rtc_clk);
 	return 0;
 }
 
@@ -309,7 +309,7 @@ static int s3c_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 	void __iomem *base = s3c_rtc_base;
 	unsigned int alrm_en;
 
-	clk_enable(rtc_clk);
+	clk_prepare_enable(rtc_clk);
 	dev_dbg(dev, "s3c_rtc_setalarm: %d, %04d.%02d.%02d %02d:%02d:%02d\n",
 		 alrm->enabled,
 		 1900 + tm->tm_year, tm->tm_mon + 1, tm->tm_mday,
@@ -339,7 +339,7 @@ static int s3c_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 
 	s3c_rtc_setaie(dev, alrm->enabled);
 
-	clk_disable(rtc_clk);
+	clk_disable_unprepare(rtc_clk);
 	return 0;
 }
 
@@ -347,7 +347,7 @@ static int s3c_rtc_proc(struct device *dev, struct seq_file *seq)
 {
 	unsigned int ticnt;
 
-	clk_enable(rtc_clk);
+	clk_prepare_enable(rtc_clk);
 	if (s3c_rtc_cpu_type == TYPE_S3C64XX) {
 		ticnt = readw(s3c_rtc_base + S3C2410_RTCCON);
 		ticnt &= S3C64XX_RTCCON_TICEN;
@@ -357,7 +357,7 @@ static int s3c_rtc_proc(struct device *dev, struct seq_file *seq)
 	}
 
 	seq_printf(seq, "periodic_IRQ\t: %s\n", ticnt  ? "yes" : "no");
-	clk_disable(rtc_clk);
+	clk_disable_unprepare(rtc_clk);
 	return 0;
 }
 
@@ -378,7 +378,7 @@ static void s3c_rtc_enable(struct platform_device *pdev, int en)
 	if (s3c_rtc_base == NULL)
 		return;
 
-	clk_enable(rtc_clk);
+	clk_prepare_enable(rtc_clk);
 	if (!en) {
 		tmp = readw(base + S3C2410_RTCCON);
 		if (s3c_rtc_cpu_type == TYPE_S3C64XX)
@@ -418,7 +418,7 @@ static void s3c_rtc_enable(struct platform_device *pdev, int en)
 				base + S3C2410_RTCCON);
 		}
 	}
-	clk_disable(rtc_clk);
+	clk_disable_unprepare(rtc_clk);
 }
 
 static int s3c_rtc_remove(struct platform_device *dev)
@@ -498,7 +498,7 @@ static int s3c_rtc_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	clk_enable(rtc_clk);
+	clk_prepare_enable(rtc_clk);
 
 	/* check to see if everything is setup correctly */
 
@@ -568,7 +568,7 @@ static int s3c_rtc_probe(struct platform_device *pdev)
 		goto err_alarm_irq;
 	}
 
-	clk_disable(rtc_clk);
+	clk_disable_unprepare(rtc_clk);
 
 	return 0;
 
@@ -578,7 +578,7 @@ static int s3c_rtc_probe(struct platform_device *pdev)
 
  err_nortc:
 	s3c_rtc_enable(pdev, 0);
-	clk_disable(rtc_clk);
+	clk_disable_unprepare(rtc_clk);
 
 	return ret;
 }
@@ -591,7 +591,7 @@ static int ticnt_save, ticnt_en_save;
 
 static int s3c_rtc_suspend(struct platform_device *pdev, pm_message_t state)
 {
-	clk_enable(rtc_clk);
+	clk_prepare_enable(rtc_clk);
 	/* save TICNT for anyone using periodic interrupts */
 	ticnt_save = readb(s3c_rtc_base + S3C2410_TICNT);
 	if (s3c_rtc_cpu_type == TYPE_S3C64XX) {
@@ -606,7 +606,7 @@ static int s3c_rtc_suspend(struct platform_device *pdev, pm_message_t state)
 		else
 			dev_err(&pdev->dev, "enable_irq_wake failed\n");
 	}
-	clk_disable(rtc_clk);
+	clk_disable_unprepare(rtc_clk);
 
 	return 0;
 }
@@ -615,7 +615,7 @@ static int s3c_rtc_resume(struct platform_device *pdev)
 {
 	unsigned int tmp;
 
-	clk_enable(rtc_clk);
+	clk_prepare_enable(rtc_clk);
 	s3c_rtc_enable(pdev, 1);
 	writeb(ticnt_save, s3c_rtc_base + S3C2410_TICNT);
 	if (s3c_rtc_cpu_type == TYPE_S3C64XX && ticnt_en_save) {
@@ -627,7 +627,7 @@ static int s3c_rtc_resume(struct platform_device *pdev)
 		disable_irq_wake(s3c_rtc_alarmno);
 		wake_en = false;
 	}
-	clk_disable(rtc_clk);
+	clk_disable_unprepare(rtc_clk);
 
 	return 0;
 }
-- 
1.7.6.5

