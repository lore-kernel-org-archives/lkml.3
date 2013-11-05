Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab3KER1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 12:27:43 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:60028 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372Ab3KER1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 12:27:40 -0500
X-AuditID: cbfee61a-b7f836d0000025d7-8d-52792a8bf545
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, durgadoss.r@intel.com,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: [PATCH v10 5/7] Documentation:cpufreq:boost: Update BOOST documentation
Date: Tue, 05 Nov 2013 18:26:49 +0100
Message-id: <1383672411-26324-6-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1383672411-26324-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1383672411-26324-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsVy+t9jQd1urcogg2PX2S0aroZYbJyxntXi
	adMPdou+n1eYLdbs/8lk0Xn2CbPFm0fcFm8ebma0uLxrDpvF594jjBa3G1ewWZw5fYnV4snD
	PjaLjV89HPg8Fu95yeRx59oeNo91094ye2y52s7i0bdlFaPH8RvbmTw+b5ILYI/isklJzcks
	Sy3St0vgyrhxeApLwQ7Jii/zpBsYX4p0MXJySAiYSJzpW8QMYYtJXLi3ng3EFhKYzigxsVm+
	i5ELyO5ikvh0cBkTSIJNQE/i892nTCAJEYEljBKvmxawgjjMAnuZJSb9WQvkcHAICwRIXPnq
	DNLAIqAq8WXRe0YQm1fATeLyh63sENvkJZ7e7wPbxingLrFj1l42iG1NjBJvbk9gmsDIu4CR
	YRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcKg+k9rBuLLB4hCjAAejEg9vgnxlkBBrYllx
	Ze4hRgkOZiUR3mP/K4KEeFMSK6tSi/Lji0pzUosPMUpzsCiJ8x5otQ4UEkhPLEnNTk0tSC2C
	yTJxcEo1MEbWz3jME6LYEpQzOcvylTzzGYZJ0ypYTNMn/F9+4eDMr/9v6nknSDstYJrRtPbP
	G++TjM1r3/Mbtwoc8HyypuMsV+3ET853ds5TeSnl+u1npFyMXeibW3dqw3/dtmFmS+dI/eyg
	3WN84IpF19/ZS64n30jiZVZ1/RWZdXe6rs6ujmyDuZVFIUosxRmJhlrMRcWJAHzFeM5RAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the support for software and hardware controlled boosting has been
added, the corresponding Documentation entry had been updated.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

---
Changes for v10:
- None

Changes for v9:
- None

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

