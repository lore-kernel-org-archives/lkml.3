Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab3LMQkt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 11:40:49 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:39206 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101Ab3LMQjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 11:39:16 -0500
X-AuditID: cbfee61a-b7f7e6d000005936-f9-52ab38334843
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
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH v11 5/7] Documentation:cpufreq:boost: Update BOOST documentation
Date: Fri, 13 Dec 2013 17:38:35 +0100
Message-id: <1386952717-30947-6-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1386952717-30947-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1386952717-30947-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrILMWRmVeSWpSXmKPExsVy+t9jQV1ji9VBBrtfcFtsnLGe1eJp0w92
	i76fV5gt1uz/yWTRefYJs8WbR9wWbx5uZrS4vGsOm8Xn3iOMFjPO72OyuN24gs3izOlLrBZP
	HvaxWWz86uHA57F4z0smjzvX9rB5rJv2ltljy9V2Fo++LasYPY7f2M7k8XmTXAB7FJdNSmpO
	Zllqkb5dAlfGhCsTWQquSFZc2dbD0sD4R6SLkZNDQsBEYtL25awQtpjEhXvr2UBsIYHpjBJr
	+5y6GLmA7C4mibX9DUwgCTYBPYnPd58ygSREBJYwSrxuWsAK4jALbGSW2DnzLVi7sECAxPGl
	h9hBbBYBVYmnb++AreAVcJPo37aRBWKdokT3swlg9ZwC7hLTNq1ihFjXxCjx/Mp9xgmMvAsY
	GVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn525iBAfsM6kdjCsbLA4xCnAwKvHwevSuChJiTSwr
	rsw9xCjBwawkwhuiujpIiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+BVutAIYH0xJLU7NTUgtQi
	mCwTB6dUA+OORt9mJbasKc8k1KOvd398XG4Ztu5+ue9RnjOyx2snBPXxTUiaW8F9hrPZ6f7M
	ujOzcjK3fy7MzTvWceRqh+pEm+UPhXi/Xr6tY5HU5raH99Ds9sC1VzfnLjjL7G+RO/tH56Gq
	b/V6jz0/GK74EbCURSH6LqOnx95anbADSnfS2d9Yd27Zt0SJpTgj0VCLuag4EQD6cLH9VAIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the support for software and hardware controlled boosting has been
added, the corresponding Documentation entry had been updated.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

---
Changes for v11:
- None

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

