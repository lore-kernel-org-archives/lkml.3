Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856AbaACLbj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 06:31:39 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:48874 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbaACLbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 06:31:38 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] Documentation/cpu-freq: add intel-pstate.txt
Date: Fri,  3 Jan 2014 17:01:13 +0530
Message-Id: <1388748673-11032-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.2.227.g53f3478
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Intel P-state driver is currently undocumented. Add some
documentation based on the cover-letter sent with the original series.

Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 I was looking for documentation on my cpufreq driver, intel_pstate,
 and found nothing: so, here's a small start. Although the original
 message said SandyBridge only, I noticed that
 /sys/devices/system/cpu/cpu0/cpufreq/scaling_driver says intel_pstate
 on my IvyBridge; so I figured subsequent patches introduced support
 for SandyBridge+.

 I noticed two "policies" in the code: CPUFREQ_POLICY_PERFORMANCE and
 CPUFREQ_POLICY_POWERSAVE, but I have no idea how to switch from one
 to the other. The userspace tool cpupower seems to be too tightly
 tied to the acpi-cpufreq driver, and I'm not able to find any others.

 Also, how well is the driver performing? I seem to be getting
 terrible battery life on my 2013 MBP.

 Thanks.

 Documentation/cpu-freq/intel-pstate.txt | 40 +++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)
 create mode 100644 Documentation/cpu-freq/intel-pstate.txt

diff --git a/Documentation/cpu-freq/intel-pstate.txt b/Documentation/cpu-freq/intel-pstate.txt
new file mode 100644
index 0000000..fda74ab
--- /dev/null
+++ b/Documentation/cpu-freq/intel-pstate.txt
@@ -0,0 +1,40 @@
+Intel P-state driver
+--------------------
+
+This driver implements a scaling driver with an internal governor for
+Intel Core processors.  The driver follows the same model as the
+Transmeta scaling driver (longrun.c) and implements the setpolicy()
+instead of target().  Scaling drivers that implement setpolicy() are
+assmuned to implement internal governors by the cpufreq core. All the
+logic for selecting the current P state is contained within the driver
+no external governor is used by the cpufreq core.
+
+Only Intel SandyBridge+ processors are supported.
+
+New sysfs files for controlling P state selection have been added to
+/sys/devices/system/cpu/intel_pstate/
+
+      max_perf_pct: limits the maximum P state that will be requested by
+      the driver stated as a percentage of the avail performance.
+
+      min_perf_pct: limits the minimum P state that will be  requested by
+      the driver stated as a percentage of the avail performance.
+
+      no_turbo: limits the driver to selecting P states below the turbo
+      frequency range.
+
+The units for these for these files are purposely abstract and stated
+in terms of available performance and not frequency.  In idea that
+frequency can be set to a single frequency is a fiction for Intel Core
+processors. Even if the scaling driver selects a single P state the
+actual frequency the processor will run at is selected by the
+processor itself.
+
+New debugfs files have also been added to /sys/kernel/debug/pstate_snb/
+
+      deadband
+      d_gain_pct
+      i_gain_pct
+      p_gain_pct
+      sample_rate_ms
+      setpoint
-- 
1.8.5.2.227.g53f3478

