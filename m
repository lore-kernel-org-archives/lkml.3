Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217Ab3HZPwJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 11:52:09 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:24113 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757160Ab3HZPwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 11:52:01 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-93-521b79a0ea76
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, durgadoss.r@intel.com
Subject: [PATCH v8 6/7] Documentation:cpufreq:boost: Update BOOST documentation
Date: Mon, 26 Aug 2013 17:50:42 +0200
Message-id: <1377532243-17076-7-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1377532243-17076-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1377532243-17076-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrELMWRmVeSWpSXmKPExsVy+t9jQd0FldJBBpe36lpsnLGe1eJp0w92
	i3mfZS36fl5htliz/yeTRefZJ8wWvQuuslm8ecRt8ebhZkaLy7vmsFl87j3CaHG7cQWbRf/C
	XiaLJw/72Cw2fvVw4PdYvOclk8eda3vYPNZNe8vs0bdlFaPHo8UtjB7Hb2xn8vi8SS6APYrL
	JiU1J7MstUjfLoErY/X1uYwFjZIVS2a2MTcwHhHpYuTgkBAwkVh0iruLkRPIFJO4cG89Wxcj
	F4eQwHRGiau7bzKCJIQEupgk/j8OALHZBPQkPt99ygRiiwjMYZS4c9QdpIFZ4AGzxOLvX8Aa
	hAX8JSY/2QpWxCKgKrHuygKwOK+Am8TF7b2MENvkJZ7e72MDsTkF3CVO9b1lhljWxCjRv15m
	AiPvAkaGVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBIftMegfjqgaLQ4wCHIxKPLwBbNJB
	QqyJZcWVuYcYJTiYlUR4OVKBQrwpiZVVqUX58UWlOanFhxilOViUxHkPtloHCgmkJ5akZqem
	FqQWwWSZODilGhh5Lwq77NnXFXv2qHJUqd6+mey7Vl7Xddq+9OZhFa30Rb8k5H7XPzSc+Ed5
	Xxb754Osv4TPfbBIs8nuNcs2FYp6fPy3X6xXRltNs/6k2XWOh5S2FT75zqoi2nlFdOLBnXu7
	ypa9VbWPOhnA53XeiLk6yfYuY54z7xSTFRUnLm1M+3Jj3YwAhcNKLMUZiYZazEXFiQB2I+Ak
	VQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the support for software and hardware controlled boosting has been
added, the corresponding Documentation entry had been updated.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

---
Changes for v8:
- None

Changes for v7:
- None

Changes for v6:
- None

Changes for v5:
- New patch

 Documentation/cpu-freq/boost.txt |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/Documentation/cpu-freq/boost.txt b/Documentation/cpu-freq/boost.txt
index 9b4edfc..dd62e13 100644
--- a/Documentation/cpu-freq/boost.txt
+++ b/Documentation/cpu-freq/boost.txt
@@ -17,8 +17,8 @@ Introduction
 Some CPUs support a functionality to raise the operating frequency of
 some cores in a multi-core package if certain conditions apply, mostly
 if the whole chip is not fully utilized and below it's intended thermal
-budget. This is done without operating system control by a combination
-of hardware and firmware.
+budget. The decision about boost disable/enable is made either at hardware
+(e.g. x86) or software (e.g ARM).
 On Intel CPUs this is called "Turbo Boost", AMD calls it "Turbo-Core",
 in technical documentation "Core performance boost". In Linux we use
 the term "boost" for convenience.
@@ -48,24 +48,24 @@ be desirable:
 User controlled switch
 ----------------------
 
-To allow the user to toggle the boosting functionality, the acpi-cpufreq
-driver exports a sysfs knob to disable it. There is a file:
+To allow the user to toggle the boosting functionality, the cpufreq core
+driver exports a sysfs knob to enable or disable it. There is a file:
 /sys/devices/system/cpu/cpufreq/boost
 which can either read "0" (boosting disabled) or "1" (boosting enabled).
-Reading the file is always supported, even if the processor does not
-support boosting. In this case the file will be read-only and always
-reads as "0". Explicitly changing the permissions and writing to that
-file anyway will return EINVAL.
+The file is exported only when cpufreq driver supports boosting.
+Explicitly changing the permissions and writing to that file anyway will
+return EINVAL.
 
 On supported CPUs one can write either a "0" or a "1" into this file.
 This will either disable the boost functionality on all cores in the
-whole system (0) or will allow the hardware to boost at will (1).
+whole system (0) or will allow the software or hardware to boost at will
+(1).
 
 Writing a "1" does not explicitly boost the system, but just allows the
-CPU (and the firmware) to boost at their discretion. Some implementations
-take external factors like the chip's temperature into account, so
-boosting once does not necessarily mean that it will occur every time
-even using the exact same software setup.
+CPU to boost at their discretion. Some implementations take external
+factors like the chip's temperature into account, so boosting once does
+not necessarily mean that it will occur every time even using the exact
+same software setup.
 
 
 AMD legacy cpb switch
-- 
1.7.10.4

