Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964993Ab3GDIvz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 04:51:55 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:16827 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933714Ab3GDIv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 04:51:29 -0400
X-AuditID: cbfee61b-b7f8e6d00000524c-fd-51d5378f0abb
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>, l.majewski@majess.pl,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andre Przywara <andre.przywara@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v5 7/7] Documentation:cpufreq:boost: Update BOOST documentation
Date: Thu, 04 Jul 2013 10:50:30 +0200
Message-id: <1372927830-2949-8-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1372927830-2949-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1372927830-2949-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsVy+t9jAd0J5lcDDX6cZ7L483Y5q8XTph/s
	FvM+y1qs2f+TyaLz7BNmi94FV9ks3jzitnjzcDOjxeVdc9gsPvceYbS43biCzaJ/YS+TxZOH
	fWwWG796OPB5LN7zksnjzrU9bB7rpr1l9ujbsorR49HiFkaP4ze2M3l83iQXwB7FZZOSmpNZ
	llqkb5fAldH/eh5bwT/xim//F7M2MD4U7mLk5JAQMJH4frGfDcIWk7hwbz2QzcUhJLCIUeLn
	l9MsEE4Xk8T1g2tZQKrYBPQkPt99ygRiiwjMYZS4c9QdxGYWWMkscaLREcQWFvCXeNV6khXE
	ZhFQlZjxeyVjFyMHB6+Aq8SyO4IQy+Qlnt7vA1vMKeAmcflCDxPErkZGiQ0dH1gmMPIuYGRY
	xSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREcqs+kdzCuarA4xCjAwajEwythdSVQiDWxrLgy
	9xCjBAezkgivE8fVQCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8B1utA4UE0hNLUrNTUwtSi2Cy
	TBycUg2MVi2xYYXPF1/f92D5fcUIr9JK26A1C6ZUTrYXty7eo5Bb1ts2b6vf47io2sR/t49K
	rdZ8LpJQcDfo/voFYszpWWt6Di/wOZlrbf+tvPRL8qz+roN3G78J3UuVYpyvtV80fXW+Z1LF
	9QaueLk1X/nfr5pRp7W1V36Gu9SCqgdcc2Wn8qmuOzJFiaU4I9FQi7moOBEAhqS2VVECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the support for software and hardware controlled boosting has been
added, the corresponding Documentation entry had been updated.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>

---
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

