Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422835Ab3LTOZm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 09:25:42 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:32738 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422815Ab3LTOZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 09:25:38 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-f1-52b453614e53
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>, durgadoss.r@intel.com,
        Zhang Rui <rui.zhang@intel.com>, linux-samsung-soc@vger.kernel.org
Subject: [PATCH v12 5/7] Documentation:cpufreq:boost: Update BOOST documentation
Date: Fri, 20 Dec 2013 15:24:53 +0100
Message-id: <1387549495-809-6-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1387549495-809-1-git-send-email-l.majewski@samsung.com>
References: <1370502472-7249-1-git-send-email-l.majewski@samsung.com>
 <1387549495-809-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsVy+t9jQd3E4C1BBo9faVlsnLGe1eJp0w92
	i76fV5gt1uz/yWTRefYJs8WbR9wWbx5uZrS4vGsOm8Xn3iOMFjPO72OyuN24gs3izOlLrBZP
	HvaxWWz86uHA57F4z0smjzvX9rB5rJv2ltljy9V2Fo++LasYPY7f2M7k8XmTXAB7FJdNSmpO
	Zllqkb5dAldG54Tl7AUfJCvu33jG0sDYL9rFyMEhIWAi8e+zdxcjJ5ApJnHh3nq2LkYuDiGB
	6YwSqzo3MEI4XUwSP6YtYQKpYhPQk/h89ymYLSLQzChx67kfSBGzwCVmiY6lV5lBEsICARKP
	f29jAtnAIqAqcW5xPEiYV8BFYtKGHnaIbYoS3c8msIHYnAKuEqvX3mEEsYUEGhglmjaqTmDk
	XcDIsIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOFSfSe9gXNVgcYhRgINRiYe3QH9zkBBr
	YllxZe4hRgkOZiUR3s8+W4KEeFMSK6tSi/Lji0pzUosPMUpzsCiJ8x5stQ4UEkhPLEnNTk0t
	SC2CyTJxcEo1MK4UleYMXR3JELXz1nqGrC+TG/gq76x5oW60sbctYur8To2QtR8mzKprClsk
	fbrVZ4FK9WdzhQjOv5zNTlMXrZwexiOSG7uvxJ3pR++2lTrKs/dtfsG68o7ATI/F4k2ieku+
	rz9x4FS9ycmtLnwRlgsqQ7aWqfSu9N9bI2Sd13XMwieM4c3KCCWW4oxEQy3mouJEAOwQ99VR	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the support for software and hardware controlled boosting has been
added, the corresponding Documentation entry had been updated.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: Myungjoo Ham <myungjoo.ham@samsung.com>
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

---
Changes for v12:
- None

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

