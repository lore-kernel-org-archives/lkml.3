Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754016AbbATQWk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:22:40 -0500
Received: from mail-qg0-f42.google.com ([209.85.192.42]:49343 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568AbbATQWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:22:23 -0500
From: Xunlei Pang <pang.xunlei@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Richard Henderson <rth@twiddle.net>,
        Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Xunlei Pang <pang.xunlei@linaro.org>
Subject: [RFC PATCH v3 8/8] alpha: rtc: change to use rtc_class_ops's set_mmss64()
Date: Tue, 20 Jan 2015 16:21:39 +0000
Message-Id: <1421770899-4136-9-git-send-email-pang.xunlei@linaro.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <1421770899-4136-1-git-send-email-pang.xunlei@linaro.org>
References: <1421770899-4136-1-git-send-email-pang.xunlei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change alpha_rtc_set_mmss() and remote_set_mmss() to use
rtc_class_ops's set_mmss64().

Signed-off-by: Xunlei Pang <pang.xunlei@linaro.org>
---
 arch/alpha/kernel/rtc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/alpha/kernel/rtc.c b/arch/alpha/kernel/rtc.c
index c8d284d..f535a3f 100644
--- a/arch/alpha/kernel/rtc.c
+++ b/arch/alpha/kernel/rtc.c
@@ -116,7 +116,7 @@ alpha_rtc_set_time(struct device *dev, struct rtc_time *tm)
 }
 
 static int
-alpha_rtc_set_mmss(struct device *dev, unsigned long nowtime)
+alpha_rtc_set_mmss(struct device *dev, time64_t nowtime)
 {
 	int retval = 0;
 	int real_seconds, real_minutes, cmos_minutes;
@@ -211,7 +211,7 @@ alpha_rtc_ioctl(struct device *dev, unsigned int cmd, unsigned long arg)
 static const struct rtc_class_ops alpha_rtc_ops = {
 	.read_time = alpha_rtc_read_time,
 	.set_time = alpha_rtc_set_time,
-	.set_mmss = alpha_rtc_set_mmss,
+	.set_mmss64 = alpha_rtc_set_mmss,
 	.ioctl = alpha_rtc_ioctl,
 };
 
@@ -276,7 +276,7 @@ do_remote_mmss(void *data)
 }
 
 static int
-remote_set_mmss(struct device *dev, unsigned long now)
+remote_set_mmss(struct device *dev, time64_t now)
 {
 	union remote_data x;
 	if (smp_processor_id() != boot_cpuid) {
@@ -290,7 +290,7 @@ remote_set_mmss(struct device *dev, unsigned long now)
 static const struct rtc_class_ops remote_rtc_ops = {
 	.read_time = remote_read_time,
 	.set_time = remote_set_time,
-	.set_mmss = remote_set_mmss,
+	.set_mmss64 = remote_set_mmss,
 	.ioctl = alpha_rtc_ioctl,
 };
 #endif
-- 
1.9.1

