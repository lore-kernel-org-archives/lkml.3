Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295AbaJ0Frh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 01:47:37 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38469 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368AbaJ0Frd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 01:47:33 -0400
From: "pang.xunlei" <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        "pang.xunlei" <pang.xunlei@linaro.org>
Subject: [PATCH RFC 07/12] time: Rename rtc_time_to_tm() to rtc_time_to_tm_unsafe()
Date: Mon, 27 Oct 2014 13:46:37 +0800
Message-Id: <1414388802-5866-6-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414388802-5866-1-git-send-email-pang.xunlei@linaro.org>
References: <1414388802-5866-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel uses 32-bit signed value(time_t) for seconds since 1970-01-01:00:00:00, thus it
will overflow at 2038-01-19 03:14:08 on 32-bit systems. We call this "2038 safety" issue.

Currently, rtc_time_to_tm() deals with "unsigned long" which is 2038 unsafe on 32-bit systems.

As part of addressing 2038 saftey for in-kernel uses, this patch creates no creates no functional
change in existing users, renames rtc_time_to_tm() to rtc_time_to_tm_unsafe(), and changes all its
calling users correspondingly. The safe version of rtc_time_to_tm() will be added in the following patch.

Signed-off-by: pang.xunlei <pang.xunlei@linaro.org>
---
 arch/mips/sibyte/swarm/rtc_m41t81.c          |    2 +-
 arch/mips/sibyte/swarm/rtc_xicor1241.c       |    2 +-
 arch/sh/kernel/time.c                        |    2 +-
 arch/x86/kernel/rtc.c                        |    2 +-
 arch/x86/platform/intel-mid/intel_mid_vrtc.c |    2 +-
 drivers/power/charger-manager.c              |    2 +-
 drivers/rtc/interface.c                      |    4 ++--
 drivers/rtc/rtc-88pm80x.c                    |    8 ++++----
 drivers/rtc/rtc-88pm860x.c                   |    8 ++++----
 drivers/rtc/rtc-ab3100.c                     |    4 ++--
 drivers/rtc/rtc-ab8500.c                     |    4 ++--
 drivers/rtc/rtc-at32ap700x.c                 |    4 ++--
 drivers/rtc/rtc-at91sam9.c                   |    4 ++--
 drivers/rtc/rtc-au1xxx.c                     |    2 +-
 drivers/rtc/rtc-bfin.c                       |    2 +-
 drivers/rtc/rtc-coh901331.c                  |    4 ++--
 drivers/rtc/rtc-da9052.c                     |    2 +-
 drivers/rtc/rtc-davinci.c                    |    2 +-
 drivers/rtc/rtc-dev.c                        |    2 +-
 drivers/rtc/rtc-dm355evm.c                   |    2 +-
 drivers/rtc/rtc-ds1374.c                     |    4 ++--
 drivers/rtc/rtc-ds1511.c                     |    2 +-
 drivers/rtc/rtc-ds1553.c                     |    2 +-
 drivers/rtc/rtc-ds1672.c                     |    2 +-
 drivers/rtc/rtc-ds2404.c                     |    2 +-
 drivers/rtc/rtc-ep93xx.c                     |    2 +-
 drivers/rtc/rtc-imxdi.c                      |    4 ++--
 drivers/rtc/rtc-jz4740.c                     |    4 ++--
 drivers/rtc/rtc-lib.c                        |    6 +++---
 drivers/rtc/rtc-lpc32xx.c                    |    4 ++--
 drivers/rtc/rtc-ls1x.c                       |    2 +-
 drivers/rtc/rtc-mc13xxx.c                    |    4 ++--
 drivers/rtc/rtc-mpc5121.c                    |    2 +-
 drivers/rtc/rtc-mv.c                         |    2 +-
 drivers/rtc/rtc-mxc.c                        |    8 ++++----
 drivers/rtc/rtc-pcap.c                       |    4 ++--
 drivers/rtc/rtc-pl030.c                      |    4 ++--
 drivers/rtc/rtc-pl031.c                      |    6 +++---
 drivers/rtc/rtc-pm8xxx.c                     |    4 ++--
 drivers/rtc/rtc-ps3.c                        |    2 +-
 drivers/rtc/rtc-puv3.c                       |    4 ++--
 drivers/rtc/rtc-rs5c348.c                    |    4 ++--
 drivers/rtc/rtc-rx8025.c                     |    2 +-
 drivers/rtc/rtc-sa1100.c                     |    2 +-
 drivers/rtc/rtc-sh.c                         |    2 +-
 drivers/rtc/rtc-sirfsoc.c                    |    6 +++---
 drivers/rtc/rtc-snvs.c                       |    4 ++--
 drivers/rtc/rtc-starfire.c                   |    2 +-
 drivers/rtc/rtc-stk17ta8.c                   |    2 +-
 drivers/rtc/rtc-stmp3xxx.c                   |    4 ++--
 drivers/rtc/rtc-sun4v.c                      |    2 +-
 drivers/rtc/rtc-sun6i.c                      |    2 +-
 drivers/rtc/rtc-sysfs.c                      |    2 +-
 drivers/rtc/rtc-tegra.c                      |    4 ++--
 drivers/rtc/rtc-test.c                       |    2 +-
 drivers/rtc/rtc-tps6586x.c                   |    4 ++--
 drivers/rtc/rtc-tx4939.c                     |    4 ++--
 drivers/rtc/rtc-vr41xx.c                     |    4 ++--
 drivers/rtc/rtc-wm831x.c                     |    4 ++--
 drivers/rtc/rtc-xgene.c                      |    4 ++--
 drivers/rtc/systohc.c                        |    4 ++--
 drivers/staging/android/alarm-dev.c          |    2 +-
 include/linux/rtc.h                          |    2 +-
 kernel/power/suspend_test.c                  |    2 +-
 64 files changed, 104 insertions(+), 104 deletions(-)

diff --git a/arch/mips/sibyte/swarm/rtc_m41t81.c b/arch/mips/sibyte/swarm/rtc_m41t81.c
index c117804..9b239f1 100644
--- a/arch/mips/sibyte/swarm/rtc_m41t81.c
+++ b/arch/mips/sibyte/swarm/rtc_m41t81.c
@@ -147,7 +147,7 @@ int m41t81_set_time(unsigned long t)
 	unsigned long flags;
 
 	/* Note we don't care about the century */
-	rtc_time_to_tm(t, &tm);
+	rtc_time_to_tm_unsafe(t, &tm);
 
 	/*
 	 * Note the write order matters as it ensures the correctness.
diff --git a/arch/mips/sibyte/swarm/rtc_xicor1241.c b/arch/mips/sibyte/swarm/rtc_xicor1241.c
index ba9e4b40..a62787c 100644
--- a/arch/mips/sibyte/swarm/rtc_xicor1241.c
+++ b/arch/mips/sibyte/swarm/rtc_xicor1241.c
@@ -115,7 +115,7 @@ int xicor_set_time(unsigned long t)
 	int tmp;
 	unsigned long flags;
 
-	rtc_time_to_tm(t, &tm);
+	rtc_time_to_tm_unsafe(t, &tm);
 	tm.tm_year += 1900;
 
 	spin_lock_irqsave(&rtc_lock, flags);
diff --git a/arch/sh/kernel/time.c b/arch/sh/kernel/time.c
index 78a1632..06e6321 100644
--- a/arch/sh/kernel/time.c
+++ b/arch/sh/kernel/time.c
@@ -56,7 +56,7 @@ unsigned int get_rtc_time(struct rtc_time *tm)
 		struct timespec tv;
 
 		rtc_sh_get_time(&tv);
-		rtc_time_to_tm(tv.tv_sec, tm);
+		rtc_time_to_tm_unsafe(tv.tv_sec, tm);
 	}
 
 	return RTC_24H;
diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
index 820958d..e7f1bb9 100644
--- a/arch/x86/kernel/rtc.c
+++ b/arch/x86/kernel/rtc.c
@@ -44,7 +44,7 @@ int mach_set_rtc_mmss(const struct timespec *now)
 	struct rtc_time tm;
 	int retval = 0;
 
-	rtc_time_to_tm(nowtime, &tm);
+	rtc_time_to_tm_unsafe(nowtime, &tm);
 	if (!rtc_valid_tm(&tm)) {
 		retval = set_rtc_time(&tm);
 		if (retval)
diff --git a/arch/x86/platform/intel-mid/intel_mid_vrtc.c b/arch/x86/platform/intel-mid/intel_mid_vrtc.c
index 5685ca2..f5020b1 100644
--- a/arch/x86/platform/intel-mid/intel_mid_vrtc.c
+++ b/arch/x86/platform/intel-mid/intel_mid_vrtc.c
@@ -93,7 +93,7 @@ int vrtc_set_mmss(const struct timespec *now)
 	int year;
 	int retval = 0;
 
-	rtc_time_to_tm(now->tv_sec, &tm);
+	rtc_time_to_tm_unsafe(now->tv_sec, &tm);
 	if (!rtc_valid_tm(&tm) && tm.tm_year >= 72) {
 		/*
 		 * tm.year is the number of years since 1900, and the
diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index 060aa2c..0fc2cbb 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -1052,7 +1052,7 @@ static bool cm_setup_timer(void)
 
 			pr_info("Waking up after %lu secs\n", time - now);
 
-			rtc_time_to_tm(time, &tmp.time);
+			rtc_time_to_tm_unsafe(time, &tmp.time);
 			rtc_set_alarm(rtc_dev, &tmp);
 			cm_suspend_duration_ms += wakeup_ms;
 			return ret;
diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index eff42e9..d728234 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -97,7 +97,7 @@ int rtc_set_mmss(struct rtc_device *rtc, unsigned long secs)
 
 		err = rtc->ops->read_time(rtc->dev.parent, &old);
 		if (err == 0) {
-			rtc_time_to_tm(secs, &new);
+			rtc_time_to_tm_unsafe(secs, &new);
 
 			/*
 			 * avoid writing when we're going to change the day of
@@ -265,7 +265,7 @@ int __rtc_read_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 	case day:
 		dev_dbg(&rtc->dev, "alarm rollover: %s\n", "day");
 		t_alm += 24 * 60 * 60;
-		rtc_time_to_tm(t_alm, &alarm->time);
+		rtc_time_to_tm_unsafe(t_alm, &alarm->time);
 		break;
 
 	/* Month rollover ... if it's the 31th, an alarm on the 3rd will
diff --git a/drivers/rtc/rtc-88pm80x.c b/drivers/rtc/rtc-88pm80x.c
index ad10664..12404f0 100644
--- a/drivers/rtc/rtc-88pm80x.c
+++ b/drivers/rtc/rtc-88pm80x.c
@@ -106,7 +106,7 @@ static void rtc_next_alarm_time(struct rtc_time *next, struct rtc_time *now,
 	if (next_time < now_time) {
 		/* Advance one day */
 		next_time += 60 * 60 * 24;
-		rtc_time_to_tm(next_time, next);
+		rtc_time_to_tm_unsafe(next_time, next);
 	}
 }
 
@@ -125,7 +125,7 @@ static int pm80x_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	ticks = base + data;
 	dev_dbg(info->dev, "get base:0x%lx, RO count:0x%lx, ticks:0x%lx\n",
 		base, data, ticks);
-	rtc_time_to_tm(ticks, tm);
+	rtc_time_to_tm_unsafe(ticks, tm);
 	return 0;
 }
 
@@ -174,7 +174,7 @@ static int pm80x_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	dev_dbg(info->dev, "get base:0x%lx, RO count:0x%lx, ticks:0x%lx\n",
 		base, data, ticks);
 
-	rtc_time_to_tm(ticks, &alrm->time);
+	rtc_time_to_tm_unsafe(ticks, &alrm->time);
 	regmap_read(info->map, PM800_RTC_CONTROL, &ret);
 	alrm->enabled = (ret & PM800_ALARM1_EN) ? 1 : 0;
 	alrm->pending = (ret & (PM800_ALARM | PM800_ALARM_WAKEUP)) ? 1 : 0;
@@ -202,7 +202,7 @@ static int pm80x_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	dev_dbg(info->dev, "get base:0x%lx, RO count:0x%lx, ticks:0x%lx\n",
 		base, data, ticks);
 
-	rtc_time_to_tm(ticks, &now_tm);
+	rtc_time_to_tm_unsafe(ticks, &now_tm);
 	dev_dbg(info->dev, "%s, now time : %lu\n", __func__, ticks);
 	rtc_next_alarm_time(&alarm_tm, &now_tm, &alrm->time);
 	/* get new ticks for alarm in 24 hours */
diff --git a/drivers/rtc/rtc-88pm860x.c b/drivers/rtc/rtc-88pm860x.c
index 4fabd6f..fc88177 100644
--- a/drivers/rtc/rtc-88pm860x.c
+++ b/drivers/rtc/rtc-88pm860x.c
@@ -102,7 +102,7 @@ static void rtc_next_alarm_time(struct rtc_time *next, struct rtc_time *now,
 	if (next_time < now_time) {
 		/* Advance one day */
 		next_time += 60 * 60 * 24;
-		rtc_time_to_tm(next_time, next);
+		rtc_time_to_tm_unsafe(next_time, next);
 	}
 }
 
@@ -124,7 +124,7 @@ static int pm860x_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	dev_dbg(info->dev, "get base:0x%lx, RO count:0x%lx, ticks:0x%lx\n",
 		base, data, ticks);
 
-	rtc_time_to_tm(ticks, tm);
+	rtc_time_to_tm_unsafe(ticks, tm);
 
 	return 0;
 }
@@ -178,7 +178,7 @@ static int pm860x_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	dev_dbg(info->dev, "get base:0x%lx, RO count:0x%lx, ticks:0x%lx\n",
 		base, data, ticks);
 
-	rtc_time_to_tm(ticks, &alrm->time);
+	rtc_time_to_tm_unsafe(ticks, &alrm->time);
 	ret = pm860x_reg_read(info->i2c, PM8607_RTC1);
 	alrm->enabled = (ret & ALARM_EN) ? 1 : 0;
 	alrm->pending = (ret & (ALARM | ALARM_WAKEUP)) ? 1 : 0;
@@ -207,7 +207,7 @@ static int pm860x_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	dev_dbg(info->dev, "get base:0x%lx, RO count:0x%lx, ticks:0x%lx\n",
 		base, data, ticks);
 
-	rtc_time_to_tm(ticks, &now_tm);
+	rtc_time_to_tm_unsafe(ticks, &now_tm);
 	rtc_next_alarm_time(&alarm_tm, &now_tm, &alrm->time);
 	/* get new ticks for alarm in 24 hours */
 	rtc_tm_to_time_unsafe(&alarm_tm, &ticks);
diff --git a/drivers/rtc/rtc-ab3100.c b/drivers/rtc/rtc-ab3100.c
index 0beb865..dcc954d 100644
--- a/drivers/rtc/rtc-ab3100.c
+++ b/drivers/rtc/rtc-ab3100.c
@@ -105,7 +105,7 @@ static int ab3100_rtc_read_time(struct device *dev, struct rtc_time *tm)
 					(u64) (AB3100_RTC_CLOCK_RATE * 2));
 	}
 
-	rtc_time_to_tm(time, tm);
+	rtc_time_to_tm_unsafe(time, tm);
 
 	return rtc_valid_tm(tm);
 }
@@ -138,7 +138,7 @@ static int ab3100_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 		((u64) buf[1] << 24) | ((u64) buf[0] << 16);
 	time = (unsigned long) (fat_time / (u64) (AB3100_RTC_CLOCK_RATE * 2));
 
-	rtc_time_to_tm(time, &alarm->time);
+	rtc_time_to_tm_unsafe(time, &alarm->time);
 
 	return rtc_valid_tm(&alarm->time);
 }
diff --git a/drivers/rtc/rtc-ab8500.c b/drivers/rtc/rtc-ab8500.c
index 1d326dc..4ecb940 100644
--- a/drivers/rtc/rtc-ab8500.c
+++ b/drivers/rtc/rtc-ab8500.c
@@ -129,7 +129,7 @@ static int ab8500_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	/* Add back the initially subtracted number of seconds */
 	secs += get_elapsed_seconds(AB8500_RTC_EPOCH);
 
-	rtc_time_to_tm(secs, tm);
+	rtc_time_to_tm_unsafe(secs, tm);
 	return rtc_valid_tm(tm);
 }
 
@@ -213,7 +213,7 @@ static int ab8500_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 	/* Add back the initially subtracted number of seconds */
 	secs += get_elapsed_seconds(AB8500_RTC_EPOCH);
 
-	rtc_time_to_tm(secs, &alarm->time);
+	rtc_time_to_tm_unsafe(secs, &alarm->time);
 
 	return rtc_valid_tm(&alarm->time);
 }
diff --git a/drivers/rtc/rtc-at32ap700x.c b/drivers/rtc/rtc-at32ap700x.c
index 26500c0..9875937 100644
--- a/drivers/rtc/rtc-at32ap700x.c
+++ b/drivers/rtc/rtc-at32ap700x.c
@@ -73,7 +73,7 @@ static int at32_rtc_readtime(struct device *dev, struct rtc_time *tm)
 	unsigned long now;
 
 	now = rtc_readl(rtc, VAL);
-	rtc_time_to_tm(now, tm);
+	rtc_time_to_tm_unsafe(now, tm);
 
 	return 0;
 }
@@ -96,7 +96,7 @@ static int at32_rtc_readalarm(struct device *dev, struct rtc_wkalrm *alrm)
 	struct rtc_at32ap700x *rtc = dev_get_drvdata(dev);
 
 	spin_lock_irq(&rtc->lock);
-	rtc_time_to_tm(rtc->alarm_time, &alrm->time);
+	rtc_time_to_tm_unsafe(rtc->alarm_time, &alrm->time);
 	alrm->enabled = rtc_readl(rtc, IMR) & RTC_BIT(IMR_TOPI) ? 1 : 0;
 	alrm->pending = rtc_readl(rtc, ISR) & RTC_BIT(ISR_TOPI) ? 1 : 0;
 	spin_unlock_irq(&rtc->lock);
diff --git a/drivers/rtc/rtc-at91sam9.c b/drivers/rtc/rtc-at91sam9.c
index 6d83959..ddfaa40 100644
--- a/drivers/rtc/rtc-at91sam9.c
+++ b/drivers/rtc/rtc-at91sam9.c
@@ -92,7 +92,7 @@ static int at91_rtc_readtime(struct device *dev, struct rtc_time *tm)
 	if (secs != secs2)
 		secs = rtt_readl(rtc, VR);
 
-	rtc_time_to_tm(offset + secs, tm);
+	rtc_time_to_tm_unsafe(offset + secs, tm);
 
 	dev_dbg(dev, "%s: %4d-%02d-%02d %02d:%02d:%02d\n", "readtime",
 		1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
@@ -167,7 +167,7 @@ static int at91_rtc_readalarm(struct device *dev, struct rtc_wkalrm *alrm)
 
 	memset(alrm, 0, sizeof(*alrm));
 	if (alarm != ALARM_DISABLED && offset != 0) {
-		rtc_time_to_tm(offset + alarm, tm);
+		rtc_time_to_tm_unsafe(offset + alarm, tm);
 
 		dev_dbg(dev, "%s: %4d-%02d-%02d %02d:%02d:%02d\n", "readalarm",
 			1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
diff --git a/drivers/rtc/rtc-au1xxx.c b/drivers/rtc/rtc-au1xxx.c
index 4949259..3bcff88 100644
--- a/drivers/rtc/rtc-au1xxx.c
+++ b/drivers/rtc/rtc-au1xxx.c
@@ -34,7 +34,7 @@ static int au1xtoy_rtc_read_time(struct device *dev, struct rtc_time *tm)
 
 	t = alchemy_rdsys(AU1000_SYS_TOYREAD);
 
-	rtc_time_to_tm(t, tm);
+	rtc_time_to_tm_unsafe(t, tm);
 
 	return rtc_valid_tm(tm);
 }
diff --git a/drivers/rtc/rtc-bfin.c b/drivers/rtc/rtc-bfin.c
index 7910191..78ee806 100644
--- a/drivers/rtc/rtc-bfin.c
+++ b/drivers/rtc/rtc-bfin.c
@@ -103,7 +103,7 @@ static inline unsigned long rtc_bfin_to_time(u32 rtc_bfin)
 }
 static inline void rtc_bfin_to_tm(u32 rtc_bfin, struct rtc_time *tm)
 {
-	rtc_time_to_tm(rtc_bfin_to_time(rtc_bfin), tm);
+	rtc_time_to_tm_unsafe(rtc_bfin_to_time(rtc_bfin), tm);
 }
 
 /**
diff --git a/drivers/rtc/rtc-coh901331.c b/drivers/rtc/rtc-coh901331.c
index 4d6e290..da9cb8b 100644
--- a/drivers/rtc/rtc-coh901331.c
+++ b/drivers/rtc/rtc-coh901331.c
@@ -80,7 +80,7 @@ static int coh901331_read_time(struct device *dev, struct rtc_time *tm)
 	clk_enable(rtap->clk);
 	/* Check if the time is valid */
 	if (readl(rtap->virtbase + COH901331_VALID)) {
-		rtc_time_to_tm(readl(rtap->virtbase + COH901331_CUR_TIME), tm);
+		rtc_time_to_tm_unsafe(readl(rtap->virtbase + COH901331_CUR_TIME), tm);
 		clk_disable(rtap->clk);
 		return rtc_valid_tm(tm);
 	}
@@ -104,7 +104,7 @@ static int coh901331_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 	struct coh901331_port *rtap = dev_get_drvdata(dev);
 
 	clk_enable(rtap->clk);
-	rtc_time_to_tm(readl(rtap->virtbase + COH901331_ALARM), &alarm->time);
+	rtc_time_to_tm_unsafe(readl(rtap->virtbase + COH901331_ALARM), &alarm->time);
 	alarm->pending = readl(rtap->virtbase + COH901331_IRQ_EVENT) & 1U;
 	alarm->enabled = readl(rtap->virtbase + COH901331_IRQ_MASK) & 1U;
 	clk_disable(rtap->clk);
diff --git a/drivers/rtc/rtc-da9052.c b/drivers/rtc/rtc-da9052.c
index 23dce8a..715f816 100644
--- a/drivers/rtc/rtc-da9052.c
+++ b/drivers/rtc/rtc-da9052.c
@@ -89,7 +89,7 @@ static int da9052_set_alarm(struct da9052_rtc *rtc, struct rtc_time *rtc_tm)
 
 	if (rtc_tm->tm_sec > 0) {
 		alm_time += 60 - rtc_tm->tm_sec;
-		rtc_time_to_tm(alm_time, rtc_tm);
+		rtc_time_to_tm_unsafe(alm_time, rtc_tm);
 	}
 	BUG_ON(rtc_tm->tm_sec); /* it will cause repeated irqs if not zero */
 
diff --git a/drivers/rtc/rtc-davinci.c b/drivers/rtc/rtc-davinci.c
index 915d625..a1c3afe 100644
--- a/drivers/rtc/rtc-davinci.c
+++ b/drivers/rtc/rtc-davinci.c
@@ -438,7 +438,7 @@ static int davinci_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alm)
 		rtc_tm_to_time_unsafe(&alm->time, &then);
 
 		if (then < now) {
-			rtc_time_to_tm(now + 24 * 60 * 60, &tm);
+			rtc_time_to_tm_unsafe(now + 24 * 60 * 60, &tm);
 			alm->time.tm_mday = tm.tm_mday;
 			alm->time.tm_mon = tm.tm_mon;
 			alm->time.tm_year = tm.tm_year;
diff --git a/drivers/rtc/rtc-dev.c b/drivers/rtc/rtc-dev.c
index 6145ba9..aefcad9 100644
--- a/drivers/rtc/rtc-dev.c
+++ b/drivers/rtc/rtc-dev.c
@@ -321,7 +321,7 @@ static long rtc_dev_ioctl(struct file *file,
 
 			/* alarm may need to wrap into tomorrow */
 			if (then < now) {
-				rtc_time_to_tm(now + 24 * 60 * 60, &tm);
+				rtc_time_to_tm_unsafe(now + 24 * 60 * 60, &tm);
 				alarm.time.tm_mday = tm.tm_mday;
 				alarm.time.tm_mon = tm.tm_mon;
 				alarm.time.tm_year = tm.tm_year;
diff --git a/drivers/rtc/rtc-dm355evm.c b/drivers/rtc/rtc-dm355evm.c
index b07d0ee..729f981 100644
--- a/drivers/rtc/rtc-dm355evm.c
+++ b/drivers/rtc/rtc-dm355evm.c
@@ -78,7 +78,7 @@ static int dm355evm_rtc_read_time(struct device *dev, struct rtc_time *tm)
 
 	dev_dbg(dev, "read timestamp %08x\n", time.value);
 
-	rtc_time_to_tm(le32_to_cpu(time.value), tm);
+	rtc_time_to_tm_unsafe(le32_to_cpu(time.value), tm);
 	return 0;
 }
 
diff --git a/drivers/rtc/rtc-ds1374.c b/drivers/rtc/rtc-ds1374.c
index 12e3b26..398a97e 100644
--- a/drivers/rtc/rtc-ds1374.c
+++ b/drivers/rtc/rtc-ds1374.c
@@ -148,7 +148,7 @@ static int ds1374_read_time(struct device *dev, struct rtc_time *time)
 
 	ret = ds1374_read_rtc(client, &itime, DS1374_REG_TOD0, 4);
 	if (!ret)
-		rtc_time_to_tm(itime, time);
+		rtc_time_to_tm_unsafe(itime, time);
 
 	return ret;
 }
@@ -195,7 +195,7 @@ static int ds1374_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 	if (ret)
 		goto out;
 
-	rtc_time_to_tm(now + cur_alarm, &alarm->time);
+	rtc_time_to_tm_unsafe(now + cur_alarm, &alarm->time);
 	alarm->enabled = !!(cr & DS1374_REG_CR_WACE);
 	alarm->pending = !!(sr & DS1374_REG_SR_AF);
 
diff --git a/drivers/rtc/rtc-ds1511.c b/drivers/rtc/rtc-ds1511.c
index b13d139..ed6116c 100644
--- a/drivers/rtc/rtc-ds1511.c
+++ b/drivers/rtc/rtc-ds1511.c
@@ -281,7 +281,7 @@ static int ds1511_rtc_read_time(struct device *dev, struct rtc_time *rtc_tm)
 
 	if (rtc_valid_tm(rtc_tm) < 0) {
 		dev_err(dev, "retrieved date/time is not valid.\n");
-		rtc_time_to_tm(0, rtc_tm);
+		rtc_time_to_tm_unsafe(0, rtc_tm);
 	}
 	return 0;
 }
diff --git a/drivers/rtc/rtc-ds1553.c b/drivers/rtc/rtc-ds1553.c
index ab56893..6e27f9d 100644
--- a/drivers/rtc/rtc-ds1553.c
+++ b/drivers/rtc/rtc-ds1553.c
@@ -131,7 +131,7 @@ static int ds1553_rtc_read_time(struct device *dev, struct rtc_time *tm)
 
 	if (rtc_valid_tm(tm) < 0) {
 		dev_err(dev, "retrieved date/time is not valid.\n");
-		rtc_time_to_tm(0, tm);
+		rtc_time_to_tm_unsafe(0, tm);
 	}
 	return 0;
 }
diff --git a/drivers/rtc/rtc-ds1672.c b/drivers/rtc/rtc-ds1672.c
index a4888db..c03bbb3 100644
--- a/drivers/rtc/rtc-ds1672.c
+++ b/drivers/rtc/rtc-ds1672.c
@@ -62,7 +62,7 @@ static int ds1672_get_datetime(struct i2c_client *client, struct rtc_time *tm)
 
 	time = (buf[3] << 24) | (buf[2] << 16) | (buf[1] << 8) | buf[0];
 
-	rtc_time_to_tm(time, tm);
+	rtc_time_to_tm_unsafe(time, tm);
 
 	dev_dbg(&client->dev, "%s: tm is secs=%d, mins=%d, hours=%d, "
 		"mday=%d, mon=%d, year=%d, wday=%d\n",
diff --git a/drivers/rtc/rtc-ds2404.c b/drivers/rtc/rtc-ds2404.c
index fc209dc..adf7804 100644
--- a/drivers/rtc/rtc-ds2404.c
+++ b/drivers/rtc/rtc-ds2404.c
@@ -206,7 +206,7 @@ static int ds2404_read_time(struct device *dev, struct rtc_time *dt)
 	ds2404_read_memory(dev, 0x203, 4, (u8 *)&time);
 	time = le32_to_cpu(time);
 
-	rtc_time_to_tm(time, dt);
+	rtc_time_to_tm_unsafe(time, dt);
 	return rtc_valid_tm(dt);
 }
 
diff --git a/drivers/rtc/rtc-ep93xx.c b/drivers/rtc/rtc-ep93xx.c
index 5e4f5dc..68bd63a 100644
--- a/drivers/rtc/rtc-ep93xx.c
+++ b/drivers/rtc/rtc-ep93xx.c
@@ -65,7 +65,7 @@ static int ep93xx_rtc_read_time(struct device *dev, struct rtc_time *tm)
 
 	 time = __raw_readl(ep93xx_rtc->mmio_base + EP93XX_RTC_DATA);
 
-	rtc_time_to_tm(time, tm);
+	rtc_time_to_tm_unsafe(time, tm);
 	return 0;
 }
 
diff --git a/drivers/rtc/rtc-imxdi.c b/drivers/rtc/rtc-imxdi.c
index 53fc4bc..7dc501f 100644
--- a/drivers/rtc/rtc-imxdi.c
+++ b/drivers/rtc/rtc-imxdi.c
@@ -200,7 +200,7 @@ static int dryice_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	unsigned long now;
 
 	now = __raw_readl(imxdi->ioaddr + DTCMR);
-	rtc_time_to_tm(now, tm);
+	rtc_time_to_tm_unsafe(now, tm);
 
 	return 0;
 }
@@ -245,7 +245,7 @@ static int dryice_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 	u32 dcamr;
 
 	dcamr = __raw_readl(imxdi->ioaddr + DCAMR);
-	rtc_time_to_tm(dcamr, &alarm->time);
+	rtc_time_to_tm_unsafe(dcamr, &alarm->time);
 
 	/* alarm is enabled if the interrupt is enabled */
 	alarm->enabled = (__raw_readl(imxdi->ioaddr + DIER) & DIER_CAIE) != 0;
diff --git a/drivers/rtc/rtc-jz4740.c b/drivers/rtc/rtc-jz4740.c
index a1379cc..9f3b559 100644
--- a/drivers/rtc/rtc-jz4740.c
+++ b/drivers/rtc/rtc-jz4740.c
@@ -122,7 +122,7 @@ static int jz4740_rtc_read_time(struct device *dev, struct rtc_time *time)
 	if (timeout == 0)
 		return -EIO;
 
-	rtc_time_to_tm(secs, time);
+	rtc_time_to_tm_unsafe(secs, time);
 
 	return rtc_valid_tm(time);
 }
@@ -147,7 +147,7 @@ static int jz4740_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	alrm->enabled = !!(ctrl & JZ_RTC_CTRL_AE);
 	alrm->pending = !!(ctrl & JZ_RTC_CTRL_AF);
 
-	rtc_time_to_tm(secs, &alrm->time);
+	rtc_time_to_tm_unsafe(secs, &alrm->time);
 
 	return rtc_valid_tm(&alrm->time);
 }
diff --git a/drivers/rtc/rtc-lib.c b/drivers/rtc/rtc-lib.c
index 829eef8..34bcca9 100644
--- a/drivers/rtc/rtc-lib.c
+++ b/drivers/rtc/rtc-lib.c
@@ -48,7 +48,7 @@ EXPORT_SYMBOL(rtc_year_days);
 /*
  * Convert seconds since 01-01-1970 00:00:00 to Gregorian date.
  */
-void rtc_time_to_tm(unsigned long time, struct rtc_time *tm)
+void rtc_time_to_tm_unsafe(unsigned long time, struct rtc_time *tm)
 {
 	unsigned int month, year;
 	int days;
@@ -88,7 +88,7 @@ void rtc_time_to_tm(unsigned long time, struct rtc_time *tm)
 
 	tm->tm_isdst = 0;
 }
-EXPORT_SYMBOL(rtc_time_to_tm);
+EXPORT_SYMBOL(rtc_time_to_tm_unsafe);
 
 /*
  * Does the rtc_time represent a valid date/time?
@@ -151,7 +151,7 @@ struct rtc_time rtc_ktime_to_tm(ktime_t kt)
 	/* Round up any ns */
 	if (ts.tv_nsec)
 		ts.tv_sec++;
-	rtc_time_to_tm(ts.tv_sec, &ret);
+	rtc_time_to_tm_unsafe(ts.tv_sec, &ret);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(rtc_ktime_to_tm);
diff --git a/drivers/rtc/rtc-lpc32xx.c b/drivers/rtc/rtc-lpc32xx.c
index da235f2..38c8ebe 100644
--- a/drivers/rtc/rtc-lpc32xx.c
+++ b/drivers/rtc/rtc-lpc32xx.c
@@ -68,7 +68,7 @@ static int lpc32xx_rtc_read_time(struct device *dev, struct rtc_time *time)
 	struct lpc32xx_rtc *rtc = dev_get_drvdata(dev);
 
 	elapsed_sec = rtc_readl(rtc, LPC32XX_RTC_UCOUNT);
-	rtc_time_to_tm(elapsed_sec, time);
+	rtc_time_to_tm_unsafe(elapsed_sec, time);
 
 	return rtc_valid_tm(time);
 }
@@ -97,7 +97,7 @@ static int lpc32xx_rtc_read_alarm(struct device *dev,
 {
 	struct lpc32xx_rtc *rtc = dev_get_drvdata(dev);
 
-	rtc_time_to_tm(rtc_readl(rtc, LPC32XX_RTC_MATCH0), &wkalrm->time);
+	rtc_time_to_tm_unsafe(rtc_readl(rtc, LPC32XX_RTC_MATCH0), &wkalrm->time);
 	wkalrm->enabled = rtc->alarm_enabled;
 	wkalrm->pending = !!(rtc_readl(rtc, LPC32XX_RTC_INTSTAT) &
 		LPC32XX_RTC_INTSTAT_MATCH0);
diff --git a/drivers/rtc/rtc-ls1x.c b/drivers/rtc/rtc-ls1x.c
index 04687c9..a9f6d08 100644
--- a/drivers/rtc/rtc-ls1x.c
+++ b/drivers/rtc/rtc-ls1x.c
@@ -96,7 +96,7 @@ static int ls1x_rtc_read_time(struct device *dev, struct rtc_time *rtm)
 	t  = mktime_unsafe((t & LS1X_YEAR_MASK), ls1x_get_month(v),
 			ls1x_get_day(v), ls1x_get_hour(v),
 			ls1x_get_min(v), ls1x_get_sec(v));
-	rtc_time_to_tm(t, rtm);
+	rtc_time_to_tm_unsafe(t, rtm);
 
 	return rtc_valid_tm(rtm);
 }
diff --git a/drivers/rtc/rtc-mc13xxx.c b/drivers/rtc/rtc-mc13xxx.c
index 78ec451..3c384dd 100644
--- a/drivers/rtc/rtc-mc13xxx.c
+++ b/drivers/rtc/rtc-mc13xxx.c
@@ -83,7 +83,7 @@ static int mc13xxx_rtc_read_time(struct device *dev, struct rtc_time *tm)
 			return ret;
 	} while (days1 != days2);
 
-	rtc_time_to_tm(days1 * SEC_PER_DAY + seconds, tm);
+	rtc_time_to_tm_unsafe(days1 * SEC_PER_DAY + seconds, tm);
 
 	return rtc_valid_tm(tm);
 }
@@ -191,7 +191,7 @@ out:
 
 	s1970 = days * SEC_PER_DAY + seconds;
 
-	rtc_time_to_tm(s1970, &alarm->time);
+	rtc_time_to_tm_unsafe(s1970, &alarm->time);
 	dev_dbg(dev, "%s: %lu\n", __func__, s1970);
 
 	return 0;
diff --git a/drivers/rtc/rtc-mpc5121.c b/drivers/rtc/rtc-mpc5121.c
index 508a1ed..430d379 100644
--- a/drivers/rtc/rtc-mpc5121.c
+++ b/drivers/rtc/rtc-mpc5121.c
@@ -114,7 +114,7 @@ static int mpc5121_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	 */
 	now = in_be32(&regs->actual_time) + in_be32(&regs->target_time);
 
-	rtc_time_to_tm(now, tm);
+	rtc_time_to_tm_unsafe(now, tm);
 
 	/*
 	 * update second minute hour registers
diff --git a/drivers/rtc/rtc-mv.c b/drivers/rtc/rtc-mv.c
index 6aaec2f..c0e519b 100644
--- a/drivers/rtc/rtc-mv.c
+++ b/drivers/rtc/rtc-mv.c
@@ -126,7 +126,7 @@ static int mv_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alm)
 
 	if (rtc_valid_tm(&alm->time) < 0) {
 		dev_err(dev, "retrieved alarm date/time is not valid.\n");
-		rtc_time_to_tm(0, &alm->time);
+		rtc_time_to_tm_unsafe(0, &alm->time);
 	}
 
 	alm->enabled = !!readl(ioaddr + RTC_ALARM_INTERRUPT_MASK_REG_OFFS);
diff --git a/drivers/rtc/rtc-mxc.c b/drivers/rtc/rtc-mxc.c
index 7bc66ab..6c11775 100644
--- a/drivers/rtc/rtc-mxc.c
+++ b/drivers/rtc/rtc-mxc.c
@@ -182,7 +182,7 @@ static int rtc_update_alarm(struct device *dev, struct rtc_time *alrm)
 	void __iomem *ioaddr = pdata->ioaddr;
 
 	now = get_alarm_or_time(dev, MXC_RTC_TIME);
-	rtc_time_to_tm(now, &now_tm);
+	rtc_time_to_tm_unsafe(now, &now_tm);
 	alarm_tm.tm_year = now_tm.tm_year;
 	alarm_tm.tm_mon = now_tm.tm_mon;
 	alarm_tm.tm_mday = now_tm.tm_mday;
@@ -290,7 +290,7 @@ static int mxc_rtc_read_time(struct device *dev, struct rtc_time *tm)
 		val = get_alarm_or_time(dev, MXC_RTC_TIME);
 	} while (val != get_alarm_or_time(dev, MXC_RTC_TIME));
 
-	rtc_time_to_tm(val, tm);
+	rtc_time_to_tm_unsafe(val, tm);
 
 	return 0;
 }
@@ -309,7 +309,7 @@ static int mxc_rtc_set_mmss(struct device *dev, unsigned long time)
 	if (is_imx1_rtc(pdata)) {
 		struct rtc_time tm;
 
-		rtc_time_to_tm(time, &tm);
+		rtc_time_to_tm_unsafe(time, &tm);
 		tm.tm_year = 70;
 		rtc_tm_to_time_unsafe(&tm, &time);
 	}
@@ -333,7 +333,7 @@ static int mxc_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	struct rtc_plat_data *pdata = platform_get_drvdata(pdev);
 	void __iomem *ioaddr = pdata->ioaddr;
 
-	rtc_time_to_tm(get_alarm_or_time(dev, MXC_RTC_ALARM), &alrm->time);
+	rtc_time_to_tm_unsafe(get_alarm_or_time(dev, MXC_RTC_ALARM), &alrm->time);
 	alrm->pending = ((readw(ioaddr + RTC_RTCISR) & RTC_ALM_BIT)) ? 1 : 0;
 
 	return 0;
diff --git a/drivers/rtc/rtc-pcap.c b/drivers/rtc/rtc-pcap.c
index d8bfe37..162bc2d 100644
--- a/drivers/rtc/rtc-pcap.c
+++ b/drivers/rtc/rtc-pcap.c
@@ -56,7 +56,7 @@ static int pcap_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	ezx_pcap_read(pcap_rtc->pcap, PCAP_REG_RTC_DAYA, &days);
 	secs += (days & PCAP_RTC_DAY_MASK) * SEC_PER_DAY;
 
-	rtc_time_to_tm(secs, tm);
+	rtc_time_to_tm_unsafe(secs, tm);
 
 	return 0;
 }
@@ -93,7 +93,7 @@ static int pcap_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	ezx_pcap_read(pcap_rtc->pcap, PCAP_REG_RTC_DAY, &days);
 	secs += (days & PCAP_RTC_DAY_MASK) * SEC_PER_DAY;
 
-	rtc_time_to_tm(secs, tm);
+	rtc_time_to_tm_unsafe(secs, tm);
 
 	return rtc_valid_tm(tm);
 }
diff --git a/drivers/rtc/rtc-pl030.c b/drivers/rtc/rtc-pl030.c
index 5c2c1c8..6a0f901 100644
--- a/drivers/rtc/rtc-pl030.c
+++ b/drivers/rtc/rtc-pl030.c
@@ -39,7 +39,7 @@ static int pl030_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
 	struct pl030_rtc *rtc = dev_get_drvdata(dev);
 
-	rtc_time_to_tm(readl(rtc->base + RTC_MR), &alrm->time);
+	rtc_time_to_tm_unsafe(readl(rtc->base + RTC_MR), &alrm->time);
 	return 0;
 }
 
@@ -64,7 +64,7 @@ static int pl030_read_time(struct device *dev, struct rtc_time *tm)
 {
 	struct pl030_rtc *rtc = dev_get_drvdata(dev);
 
-	rtc_time_to_tm(readl(rtc->base + RTC_DR), tm);
+	rtc_time_to_tm_unsafe(readl(rtc->base + RTC_DR), tm);
 
 	return 0;
 }
diff --git a/drivers/rtc/rtc-pl031.c b/drivers/rtc/rtc-pl031.c
index 5a73252..b7f70aa 100644
--- a/drivers/rtc/rtc-pl031.c
+++ b/drivers/rtc/rtc-pl031.c
@@ -130,7 +130,7 @@ static int pl031_stv2_tm_to_time(struct device *dev,
 		struct rtc_time calc_tm;
 
 		rtc_tm_to_time_unsafe(tm, &time);
-		rtc_time_to_tm(time, &calc_tm);
+		rtc_time_to_tm_unsafe(time, &calc_tm);
 		wday = calc_tm.tm_wday;
 	}
 
@@ -251,7 +251,7 @@ static int pl031_read_time(struct device *dev, struct rtc_time *tm)
 {
 	struct pl031_local *ldata = dev_get_drvdata(dev);
 
-	rtc_time_to_tm(readl(ldata->base + RTC_DR), tm);
+	rtc_time_to_tm_unsafe(readl(ldata->base + RTC_DR), tm);
 
 	return 0;
 }
@@ -274,7 +274,7 @@ static int pl031_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 {
 	struct pl031_local *ldata = dev_get_drvdata(dev);
 
-	rtc_time_to_tm(readl(ldata->base + RTC_MR), &alarm->time);
+	rtc_time_to_tm_unsafe(readl(ldata->base + RTC_MR), &alarm->time);
 
 	alarm->pending = readl(ldata->base + RTC_RIS) & RTC_BIT_AI;
 	alarm->enabled = readl(ldata->base + RTC_IMSC) & RTC_BIT_AI;
diff --git a/drivers/rtc/rtc-pm8xxx.c b/drivers/rtc/rtc-pm8xxx.c
index 76d5b84..0bc746b 100644
--- a/drivers/rtc/rtc-pm8xxx.c
+++ b/drivers/rtc/rtc-pm8xxx.c
@@ -177,7 +177,7 @@ static int pm8xxx_rtc_read_time(struct device *dev, struct rtc_time *tm)
 
 	secs = value[0] | (value[1] << 8) | (value[2] << 16) | (value[3] << 24);
 
-	rtc_time_to_tm(secs, tm);
+	rtc_time_to_tm_unsafe(secs, tm);
 
 	rc = rtc_valid_tm(tm);
 	if (rc < 0) {
@@ -255,7 +255,7 @@ static int pm8xxx_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 
 	secs = value[0] | (value[1] << 8) | (value[2] << 16) | (value[3] << 24);
 
-	rtc_time_to_tm(secs, &alarm->time);
+	rtc_time_to_tm_unsafe(secs, &alarm->time);
 
 	rc = rtc_valid_tm(&alarm->time);
 	if (rc < 0) {
diff --git a/drivers/rtc/rtc-ps3.c b/drivers/rtc/rtc-ps3.c
index e6f3fe6..4de455e 100644
--- a/drivers/rtc/rtc-ps3.c
+++ b/drivers/rtc/rtc-ps3.c
@@ -40,7 +40,7 @@ static u64 read_rtc(void)
 
 static int ps3_get_time(struct device *dev, struct rtc_time *tm)
 {
-	rtc_time_to_tm(read_rtc() + ps3_os_area_get_rtc_diff(), tm);
+	rtc_time_to_tm_unsafe(read_rtc() + ps3_os_area_get_rtc_diff(), tm);
 	return rtc_valid_tm(tm);
 }
 
diff --git a/drivers/rtc/rtc-puv3.c b/drivers/rtc/rtc-puv3.c
index ae8b7e8..242e0cf 100644
--- a/drivers/rtc/rtc-puv3.c
+++ b/drivers/rtc/rtc-puv3.c
@@ -88,7 +88,7 @@ static int puv3_rtc_setpie(struct device *dev, int enabled)
 /* Time read/write */
 static int puv3_rtc_gettime(struct device *dev, struct rtc_time *rtc_tm)
 {
-	rtc_time_to_tm(readl(RTC_RCNR), rtc_tm);
+	rtc_time_to_tm_unsafe(readl(RTC_RCNR), rtc_tm);
 
 	dev_dbg(dev, "read time %02x.%02x.%02x %02x/%02x/%02x\n",
 		 rtc_tm->tm_year, rtc_tm->tm_mon, rtc_tm->tm_mday,
@@ -115,7 +115,7 @@ static int puv3_rtc_getalarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
 	struct rtc_time *alm_tm = &alrm->time;
 
-	rtc_time_to_tm(readl(RTC_RTAR), alm_tm);
+	rtc_time_to_tm_unsafe(readl(RTC_RTAR), alm_tm);
 
 	alrm->enabled = readl(RTC_RTSR) & RTC_RTSR_ALE;
 
diff --git a/drivers/rtc/rtc-rs5c348.c b/drivers/rtc/rtc-rs5c348.c
index 090a101..091c8dd 100644
--- a/drivers/rtc/rtc-rs5c348.c
+++ b/drivers/rtc/rtc-rs5c348.c
@@ -139,7 +139,7 @@ rs5c348_rtc_read_time(struct device *dev, struct rtc_time *tm)
 
 	if (rtc_valid_tm(tm) < 0) {
 		dev_err(&spi->dev, "retrieved date/time is not valid.\n");
-		rtc_time_to_tm(0, tm);
+		rtc_time_to_tm_unsafe(0, tm);
 	}
 
 	return 0;
@@ -186,7 +186,7 @@ static int rs5c348_probe(struct spi_device *spi)
 			dev_warn(&spi->dev, "voltage-low detected.\n");
 		if (ret & RS5C348_BIT_XSTP)
 			dev_warn(&spi->dev, "oscillator-stop detected.\n");
-		rtc_time_to_tm(0, &tm);	/* 1970/1/1 */
+		rtc_time_to_tm_unsafe(0, &tm);	/* 1970/1/1 */
 		ret = rs5c348_rtc_set_time(&spi->dev, &tm);
 		if (ret < 0)
 			goto kfree_exit;
diff --git a/drivers/rtc/rtc-rx8025.c b/drivers/rtc/rtc-rx8025.c
index e6298e0..02ae3d1 100644
--- a/drivers/rtc/rtc-rx8025.c
+++ b/drivers/rtc/rtc-rx8025.c
@@ -567,7 +567,7 @@ static int rx8025_probe(struct i2c_client *client,
 		struct rtc_time tm;
 		dev_info(&client->dev,
 			 "bad conditions detected, resetting date\n");
-		rtc_time_to_tm(0, &tm);	/* 1970/1/1 */
+		rtc_time_to_tm_unsafe(0, &tm);	/* 1970/1/1 */
 		rx8025_set_time(&client->dev, &tm);
 	}
 
diff --git a/drivers/rtc/rtc-sa1100.c b/drivers/rtc/rtc-sa1100.c
index b736f1e..379df46 100644
--- a/drivers/rtc/rtc-sa1100.c
+++ b/drivers/rtc/rtc-sa1100.c
@@ -157,7 +157,7 @@ static int sa1100_rtc_alarm_irq_enable(struct device *dev, unsigned int enabled)
 
 static int sa1100_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
-	rtc_time_to_tm(RCNR, tm);
+	rtc_time_to_tm_unsafe(RCNR, tm);
 	return 0;
 }
 
diff --git a/drivers/rtc/rtc-sh.c b/drivers/rtc/rtc-sh.c
index d0d2b04..edda8d7 100644
--- a/drivers/rtc/rtc-sh.c
+++ b/drivers/rtc/rtc-sh.c
@@ -719,7 +719,7 @@ static int __init sh_rtc_probe(struct platform_device *pdev)
 
 	/* reset rtc to epoch 0 if time is invalid */
 	if (rtc_read_time(rtc->rtc_dev, &r) < 0) {
-		rtc_time_to_tm(0, &r);
+		rtc_time_to_tm_unsafe(0, &r);
 		rtc_set_time(rtc->rtc_dev, &r);
 	}
 
diff --git a/drivers/rtc/rtc-sirfsoc.c b/drivers/rtc/rtc-sirfsoc.c
index 8579970..33dcd68 100644
--- a/drivers/rtc/rtc-sirfsoc.c
+++ b/drivers/rtc/rtc-sirfsoc.c
@@ -74,11 +74,11 @@ static int sirfsoc_rtc_read_alarm(struct device *dev,
 	 */
 	/* if alarm is in next overflow cycle */
 	if (rtc_count > rtc_alarm)
-		rtc_time_to_tm((rtcdrv->overflow_rtc + 1)
+		rtc_time_to_tm_unsafe((rtcdrv->overflow_rtc + 1)
 				<< (BITS_PER_LONG - RTC_SHIFT)
 				| rtc_alarm >> RTC_SHIFT, &(alrm->time));
 	else
-		rtc_time_to_tm(rtcdrv->overflow_rtc
+		rtc_time_to_tm_unsafe(rtcdrv->overflow_rtc
 				<< (BITS_PER_LONG - RTC_SHIFT)
 				| rtc_alarm >> RTC_SHIFT, &(alrm->time));
 	if (sirfsoc_rtc_iobrg_readl(
@@ -168,7 +168,7 @@ static int sirfsoc_rtc_read_time(struct device *dev,
 		cpu_relax();
 	} while (tmp_rtc != sirfsoc_rtc_iobrg_readl(rtcdrv->rtc_base + RTC_CN));
 
-	rtc_time_to_tm(rtcdrv->overflow_rtc << (BITS_PER_LONG - RTC_SHIFT) |
+	rtc_time_to_tm_unsafe(rtcdrv->overflow_rtc << (BITS_PER_LONG - RTC_SHIFT) |
 					tmp_rtc >> RTC_SHIFT, tm);
 	return 0;
 }
diff --git a/drivers/rtc/rtc-snvs.c b/drivers/rtc/rtc-snvs.c
index 198377a..5d9fe5d 100644
--- a/drivers/rtc/rtc-snvs.c
+++ b/drivers/rtc/rtc-snvs.c
@@ -121,7 +121,7 @@ static int snvs_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	struct snvs_rtc_data *data = dev_get_drvdata(dev);
 	unsigned long time = rtc_read_lp_counter(data->ioaddr);
 
-	rtc_time_to_tm(time, tm);
+	rtc_time_to_tm_unsafe(time, tm);
 
 	return 0;
 }
@@ -152,7 +152,7 @@ static int snvs_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	u32 lptar, lpsr;
 
 	lptar = readl(data->ioaddr + SNVS_LPTAR);
-	rtc_time_to_tm(lptar, &alrm->time);
+	rtc_time_to_tm_unsafe(lptar, &alrm->time);
 
 	lpsr = readl(data->ioaddr + SNVS_LPSR);
 	alrm->pending = (lpsr & SNVS_LPSR_LPTA) ? 1 : 0;
diff --git a/drivers/rtc/rtc-starfire.c b/drivers/rtc/rtc-starfire.c
index f7d8a6d..bb8de2b 100644
--- a/drivers/rtc/rtc-starfire.c
+++ b/drivers/rtc/rtc-starfire.c
@@ -29,7 +29,7 @@ static u32 starfire_get_time(void)
 
 static int starfire_read_time(struct device *dev, struct rtc_time *tm)
 {
-	rtc_time_to_tm(starfire_get_time(), tm);
+	rtc_time_to_tm_unsafe(starfire_get_time(), tm);
 	return rtc_valid_tm(tm);
 }
 
diff --git a/drivers/rtc/rtc-stk17ta8.c b/drivers/rtc/rtc-stk17ta8.c
index 35ed49e..f915c89 100644
--- a/drivers/rtc/rtc-stk17ta8.c
+++ b/drivers/rtc/rtc-stk17ta8.c
@@ -133,7 +133,7 @@ static int stk17ta8_rtc_read_time(struct device *dev, struct rtc_time *tm)
 
 	if (rtc_valid_tm(tm) < 0) {
 		dev_err(dev, "retrieved date/time is not valid.\n");
-		rtc_time_to_tm(0, tm);
+		rtc_time_to_tm_unsafe(0, tm);
 	}
 	return 0;
 }
diff --git a/drivers/rtc/rtc-stmp3xxx.c b/drivers/rtc/rtc-stmp3xxx.c
index f9a0c46..2aed30a 100644
--- a/drivers/rtc/rtc-stmp3xxx.c
+++ b/drivers/rtc/rtc-stmp3xxx.c
@@ -153,7 +153,7 @@ static int stmp3xxx_rtc_gettime(struct device *dev, struct rtc_time *rtc_tm)
 	if (ret)
 		return ret;
 
-	rtc_time_to_tm(readl(rtc_data->io + STMP3XXX_RTC_SECONDS), rtc_tm);
+	rtc_time_to_tm_unsafe(readl(rtc_data->io + STMP3XXX_RTC_SECONDS), rtc_tm);
 	return 0;
 }
 
@@ -205,7 +205,7 @@ static int stmp3xxx_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alm)
 {
 	struct stmp3xxx_rtc_data *rtc_data = dev_get_drvdata(dev);
 
-	rtc_time_to_tm(readl(rtc_data->io + STMP3XXX_RTC_ALARM), &alm->time);
+	rtc_time_to_tm_unsafe(readl(rtc_data->io + STMP3XXX_RTC_ALARM), &alm->time);
 	return 0;
 }
 
diff --git a/drivers/rtc/rtc-sun4v.c b/drivers/rtc/rtc-sun4v.c
index ed041ed..5143c74 100644
--- a/drivers/rtc/rtc-sun4v.c
+++ b/drivers/rtc/rtc-sun4v.c
@@ -37,7 +37,7 @@ retry:
 
 static int sun4v_read_time(struct device *dev, struct rtc_time *tm)
 {
-	rtc_time_to_tm(hypervisor_get_time(), tm);
+	rtc_time_to_tm_unsafe(hypervisor_get_time(), tm);
 	return 0;
 }
 
diff --git a/drivers/rtc/rtc-sun6i.c b/drivers/rtc/rtc-sun6i.c
index c49c399..a71a48a 100644
--- a/drivers/rtc/rtc-sun6i.c
+++ b/drivers/rtc/rtc-sun6i.c
@@ -198,7 +198,7 @@ static int sun6i_rtc_getalarm(struct device *dev, struct rtc_wkalrm *wkalrm)
 	alrm_st = readl(chip->base + SUN6I_ALRM_IRQ_STA);
 	wkalrm->enabled = !!(alrm_en & SUN6I_ALRM_EN_CNT_EN);
 	wkalrm->pending = !!(alrm_st & SUN6I_ALRM_EN_CNT_EN);
-	rtc_time_to_tm(chip->alarm, &wkalrm->time);
+	rtc_time_to_tm_unsafe(chip->alarm, &wkalrm->time);
 
 	return 0;
 }
diff --git a/drivers/rtc/rtc-sysfs.c b/drivers/rtc/rtc-sysfs.c
index b9695f3..3a6749c7 100644
--- a/drivers/rtc/rtc-sysfs.c
+++ b/drivers/rtc/rtc-sysfs.c
@@ -216,7 +216,7 @@ rtc_sysfs_set_wakealarm(struct device *dev, struct device_attribute *attr,
 		 */
 		alarm = now + 300;
 	}
-	rtc_time_to_tm(alarm, &alm.time);
+	rtc_time_to_tm_unsafe(alarm, &alm.time);
 
 	retval = rtc_set_alarm(rtc, &alm);
 	return (retval < 0) ? retval : n;
diff --git a/drivers/rtc/rtc-tegra.c b/drivers/rtc/rtc-tegra.c
index 409b4a0..ce4a49a 100644
--- a/drivers/rtc/rtc-tegra.c
+++ b/drivers/rtc/rtc-tegra.c
@@ -119,7 +119,7 @@ static int tegra_rtc_read_time(struct device *dev, struct rtc_time *tm)
 
 	spin_unlock_irqrestore(&info->tegra_rtc_lock, sl_irq_flags);
 
-	rtc_time_to_tm(sec, tm);
+	rtc_time_to_tm_unsafe(sec, tm);
 
 	dev_vdbg(dev, "time read as %lu. %d/%d/%d %d:%02u:%02u\n",
 		sec,
@@ -188,7 +188,7 @@ static int tegra_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 	} else {
 		/* alarm is enabled. */
 		alarm->enabled = 1;
-		rtc_time_to_tm(sec, &alarm->time);
+		rtc_time_to_tm_unsafe(sec, &alarm->time);
 	}
 
 	tmp = readl(info->rtc_base + TEGRA_RTC_REG_INTR_STATUS);
diff --git a/drivers/rtc/rtc-test.c b/drivers/rtc/rtc-test.c
index 6599c20..01b8441 100644
--- a/drivers/rtc/rtc-test.c
+++ b/drivers/rtc/rtc-test.c
@@ -30,7 +30,7 @@ static int test_rtc_set_alarm(struct device *dev,
 static int test_rtc_read_time(struct device *dev,
 	struct rtc_time *tm)
 {
-	rtc_time_to_tm(get_seconds(), tm);
+	rtc_time_to_tm_unsafe(get_seconds(), tm);
 	return 0;
 }
 
diff --git a/drivers/rtc/rtc-tps6586x.c b/drivers/rtc/rtc-tps6586x.c
index 341b000..c90e38e 100644
--- a/drivers/rtc/rtc-tps6586x.c
+++ b/drivers/rtc/rtc-tps6586x.c
@@ -89,7 +89,7 @@ static int tps6586x_rtc_read_time(struct device *dev, struct rtc_time *tm)
 
 	seconds = ticks >> 10;
 	seconds += rtc->epoch_start;
-	rtc_time_to_tm(seconds, tm);
+	rtc_time_to_tm_unsafe(seconds, tm);
 	return rtc_valid_tm(tm);
 }
 
@@ -227,7 +227,7 @@ static int tps6586x_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	seconds = ticks >> 10;
 	seconds += rtc->epoch_start;
 
-	rtc_time_to_tm(seconds, &alrm->time);
+	rtc_time_to_tm_unsafe(seconds, &alrm->time);
 	return 0;
 }
 
diff --git a/drivers/rtc/rtc-tx4939.c b/drivers/rtc/rtc-tx4939.c
index b3cf814..47a380a 100644
--- a/drivers/rtc/rtc-tx4939.c
+++ b/drivers/rtc/rtc-tx4939.c
@@ -87,7 +87,7 @@ static int tx4939_rtc_read_time(struct device *dev, struct rtc_time *tm)
 		buf[i] = __raw_readl(&rtcreg->dat);
 	spin_unlock_irq(&pdata->lock);
 	sec = (buf[5] << 24) | (buf[4] << 16) | (buf[3] << 8) | buf[2];
-	rtc_time_to_tm(sec, tm);
+	rtc_time_to_tm_unsafe(sec, tm);
 	return rtc_valid_tm(tm);
 }
 
@@ -148,7 +148,7 @@ static int tx4939_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 	alrm->pending = (ctl & TX4939_RTCCTL_ALMD) ? 1 : 0;
 	spin_unlock_irq(&pdata->lock);
 	sec = (buf[5] << 24) | (buf[4] << 16) | (buf[3] << 8) | buf[2];
-	rtc_time_to_tm(sec, &alrm->time);
+	rtc_time_to_tm_unsafe(sec, &alrm->time);
 	return rtc_valid_tm(&alrm->time);
 }
 
diff --git a/drivers/rtc/rtc-vr41xx.c b/drivers/rtc/rtc-vr41xx.c
index a3d5772..9abeff7 100644
--- a/drivers/rtc/rtc-vr41xx.c
+++ b/drivers/rtc/rtc-vr41xx.c
@@ -143,7 +143,7 @@ static int vr41xx_rtc_read_time(struct device *dev, struct rtc_time *time)
 	epoch_sec = mktime_unsafe(epoch, 1, 1, 0, 0, 0);
 	elapsed_sec = read_elapsed_second();
 
-	rtc_time_to_tm(epoch_sec + elapsed_sec, time);
+	rtc_time_to_tm_unsafe(epoch_sec + elapsed_sec, time);
 
 	return 0;
 }
@@ -175,7 +175,7 @@ static int vr41xx_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *wkalrm)
 
 	spin_unlock_irq(&rtc_lock);
 
-	rtc_time_to_tm((high << 17) | (mid << 1) | (low >> 15), time);
+	rtc_time_to_tm_unsafe((high << 17) | (mid << 1) | (low >> 15), time);
 
 	return 0;
 }
diff --git a/drivers/rtc/rtc-wm831x.c b/drivers/rtc/rtc-wm831x.c
index 5d6a877..a0d3234 100644
--- a/drivers/rtc/rtc-wm831x.c
+++ b/drivers/rtc/rtc-wm831x.c
@@ -155,7 +155,7 @@ static int wm831x_rtc_readtime(struct device *dev, struct rtc_time *tm)
 		if (memcmp(time1, time2, sizeof(time1)) == 0) {
 			u32 time = (time1[0] << 16) | time1[1];
 
-			rtc_time_to_tm(time, tm);
+			rtc_time_to_tm_unsafe(time, tm);
 			return rtc_valid_tm(tm);
 		}
 
@@ -249,7 +249,7 @@ static int wm831x_rtc_readalarm(struct device *dev, struct rtc_wkalrm *alrm)
 
 	time = (data[0] << 16) | data[1];
 
-	rtc_time_to_tm(time, &alrm->time);
+	rtc_time_to_tm_unsafe(time, &alrm->time);
 
 	ret = wm831x_reg_read(wm831x_rtc->wm831x, WM831X_RTC_CONTROL);
 	if (ret < 0) {
diff --git a/drivers/rtc/rtc-xgene.c b/drivers/rtc/rtc-xgene.c
index 2da0616..95b60b4 100644
--- a/drivers/rtc/rtc-xgene.c
+++ b/drivers/rtc/rtc-xgene.c
@@ -58,7 +58,7 @@ static int xgene_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
 	struct xgene_rtc_dev *pdata = dev_get_drvdata(dev);
 
-	rtc_time_to_tm(readl(pdata->csr_base + RTC_CCVR), tm);
+	rtc_time_to_tm_unsafe(readl(pdata->csr_base + RTC_CCVR), tm);
 	return rtc_valid_tm(tm);
 }
 
@@ -80,7 +80,7 @@ static int xgene_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *alrm)
 {
 	struct xgene_rtc_dev *pdata = dev_get_drvdata(dev);
 
-	rtc_time_to_tm(pdata->alarm_time, &alrm->time);
+	rtc_time_to_tm_unsafe(pdata->alarm_time, &alrm->time);
 	alrm->enabled = readl(pdata->csr_base + RTC_CCR) & RTC_CCR_IE;
 
 	return 0;
diff --git a/drivers/rtc/systohc.c b/drivers/rtc/systohc.c
index bf3e242..f5796d3 100644
--- a/drivers/rtc/systohc.c
+++ b/drivers/rtc/systohc.c
@@ -27,9 +27,9 @@ int rtc_set_ntp_time(struct timespec now)
 	int err = -ENODEV;
 
 	if (now.tv_nsec < (NSEC_PER_SEC >> 1))
-		rtc_time_to_tm(now.tv_sec, &tm);
+		rtc_time_to_tm_unsafe(now.tv_sec, &tm);
 	else
-		rtc_time_to_tm(now.tv_sec + 1, &tm);
+		rtc_time_to_tm_unsafe(now.tv_sec + 1, &tm);
 
 	rtc = rtc_class_open(CONFIG_RTC_HCTOSYS_DEVICE);
 	if (rtc) {
diff --git a/drivers/staging/android/alarm-dev.c b/drivers/staging/android/alarm-dev.c
index ff4b3e8..3f95f80e 100644
--- a/drivers/staging/android/alarm-dev.c
+++ b/drivers/staging/android/alarm-dev.c
@@ -159,7 +159,7 @@ static int alarm_set_rtc(struct timespec *ts)
 	unsigned long flags;
 	int rv = 0;
 
-	rtc_time_to_tm(ts->tv_sec, &new_rtc_tm);
+	rtc_time_to_tm_unsafe(ts->tv_sec, &new_rtc_tm);
 	rtc_dev = alarmtimer_get_rtcdev();
 	rv = do_settimeofday(ts);
 	if (rv < 0)
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index ffd22e9..d1f878c 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -21,7 +21,7 @@ extern int rtc_year_days(unsigned int day, unsigned int month, unsigned int year
 extern int rtc_valid_tm(struct rtc_time *tm);
 extern int rtc_tm_to_time(struct rtc_time *tm, time64_t *time);
 extern int rtc_tm_to_time_unsafe(struct rtc_time *tm, unsigned long *time);
-extern void rtc_time_to_tm(unsigned long time, struct rtc_time *tm);
+extern void rtc_time_to_tm_unsafe(unsigned long time, struct rtc_time *tm);
 ktime_t rtc_tm_to_ktime(struct rtc_time tm);
 struct rtc_time rtc_ktime_to_tm(ktime_t kt);
 
diff --git a/kernel/power/suspend_test.c b/kernel/power/suspend_test.c
index f82b228..b6bc0e8 100644
--- a/kernel/power/suspend_test.c
+++ b/kernel/power/suspend_test.c
@@ -85,7 +85,7 @@ repeat:
 	rtc_tm_to_time_unsafe(&alm.time, &now);
 
 	memset(&alm, 0, sizeof alm);
-	rtc_time_to_tm(now + TEST_SUSPEND_SECONDS, &alm.time);
+	rtc_time_to_tm_unsafe(now + TEST_SUSPEND_SECONDS, &alm.time);
 	alm.enabled = true;
 
 	status = rtc_set_alarm(rtc, &alm);
-- 
1.7.9.5

