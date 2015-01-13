Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752903AbbAMPql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:46:41 -0500
Received: from m15-111.126.com ([220.181.15.111]:37348 "EHLO m15-111.126.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830AbbAMPqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:46:37 -0500
From: Xunlei Pang <xlpang@126.com>
To: linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: rtc-linux@googlegroups.com, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Xunlei Pang <pang.xunlei@linaro.org>
Subject: [RFC PATCH v2 9/9] alpha: change to use rtc_class_ops's set_mmss64()
Date: Tue, 13 Jan 2015 23:44:57 +0800
Message-Id: <1421163897-8020-10-git-send-email-xlpang@126.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1421163897-8020-1-git-send-email-xlpang@126.com>
References: <1421163897-8020-1-git-send-email-xlpang@126.com>
X-CM-TRANSID: C8mowEAZEUVxPbVUBIRpDg--.692S12
X-Coremail-Antispam: 1Uf129KBjvJXoW7AF47Kw1rJrW3GF4DGw4UJwb_yoW8WFy5pF
	47u34DGr4UGFZrKa48XF4kCw1F9ryfKayxKw13C3WfCa15JF13ZF18GrW7AFy3GFyvkas3
	W3s8Wry5X3W8GaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jdNVgUUUUU=
X-Originating-IP: [182.149.91.53]
X-CM-SenderInfo: p0ost0bj6rjloofrz/1tbigQKAv1E0a1uClwABs9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xunlei Pang <pang.xunlei@linaro.org>

Change alpha_rtc_set_mmss() and remote_set_mmss() to use
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


