Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab3GDPR6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 11:17:58 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:8410 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab3GDPR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 11:17:56 -0400
X-AuditID: cbfec7f5-b7f376d000001ec6-f4-51d5922214d8
From: Konstantin Krivyakin <k.krivyakin@samsung.com>
To: k.krivyakin@samsung.com, i.zhbanov@samsung.com, e.voevodin@samsung.com,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org
Subject: [PATCH RFC 0/3] Per-process power consumption measurement facility
Date: Thu, 04 Jul 2013 19:17:16 +0400
Message-id: <1372951039-10375-1-git-send-email-k.krivyakin@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOJMWRmVeSWpSXmKPExsVy+t/xa7pKk64GGnxcr2ux9lw7k8WKq0cY
	LaYuPMxucbbpDbvF5V1z2BxYPfq2rGL0+LxJLoApissmJTUnsyy1SN8ugSvjSZdjwRreiu6W
	RrYGxt+cXYycHBICJhKzvqxigbDFJC7cW8/WxcjFISSwlFFi6oNvrBBON5PE5j1XmECq2IA6
	du+9yAySEBFoZZRofdUF1MLBISzgLdE3OQ+khkVAVWLijBuMIDavgLvErG8N7CAlEgIKEnMm
	2Uxg5FrAyLCKUTS1NLmgOCk910ivODG3uDQvXS85P3cTI8SzX3cwLj1mdYhRgINRiYf3Yf3V
	QCHWxLLiytxDjBIczEoivKeagUK8KYmVValF+fFFpTmpxYcYmTg4pRoYGWes3nVV2CR5Tsah
	7YWb1s89VrK6RueE49F3z77kKkTvrfmq1vXPyadxnc2aHc3eX9yy2M97HTzmxrj5VWHn23kB
	6p//uennzzy7+rRK+nTVmRfP9XCabGGb9Htzi4OoLUPEFOUYG02X2+dMT//84Bx2bkLDf9UI
	9vNZxv+Y7wdftpCf0fDXV4mlOCPRUIu5qDgRABZHfRbKAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds per-process power consumption measurement facility.
Power consumption is very important on mobile platforms. This code
allows to measure consumed power in Watts*Hours. The consumed power
for process is updated on scheduler switch and depends on current
CPU voltage and frequency.

The formula for computation is: P = C * V^2 * f, where C is a constant
that reflects capacity of the system, V is the current voltage and
f is the current frequency.
(Taken from: http://en.wikipedia.org/wiki/CPU_power_dissipation).

In this patchset was added implementation for Exynos platform
to demonstrate how it works.

To minimize scheduler impact for each CPU P-state the value of (V^2 *f)
was precomputed at the time of platform initialization.

And to reduce performance impact furthermore, the C constant is multiplied
in userspace.

Konstantin Krivyakin (3):
  Add interface to receive current cpu power
  Add power consumption counter in task_struct.
  Update current cpu power when cpu freq change for exynos.

 drivers/cpufreq/cpufreq.c            |   17 +++++++++++++++++
 drivers/cpufreq/exynos-cpufreq.c     |    2 ++
 drivers/cpufreq/exynos-cpufreq.h     |    1 +
 drivers/cpufreq/exynos4x12-cpufreq.c |   19 ++++++++++++++++++-
 include/linux/cpufreq.h              |    6 ++++++
 include/linux/sched.h                |    2 ++
 include/uapi/linux/taskstats.h       |    2 ++
 kernel/fork.c                        |    1 +
 kernel/sched/core.c                  |    8 ++++++++
 kernel/sched/cputime.c               |   11 +++++++++++
 kernel/tsacct.c                      |    3 +++
 11 files changed, 71 insertions(+), 1 deletion(-)

-- 
1.7.9.5

