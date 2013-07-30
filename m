Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082Ab3G3IR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 04:17:57 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:38486 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754524Ab3G3IRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 04:17:54 -0400
X-AuditID: cbfec7f5-b7f376d000001ec6-af-51f776b0dc42
From: Konstantin Krivyakin <k.krivyakin@samsung.com>
To: linux-kernel@vger.kernel.org, rjw@sisk.pl, viresh.kumar@linaro.org,
        mingo@redhat.com, peterz@infradead.org, kgene.kim@samsung.com,
        linux-pm@vger.kernel.org
Cc: k.krivyakin@samsung.com, i.zhbanov@samsung.com, e.voevodin@samsung.com,
        kyungmin.park@samsung.com, akpm@linux-foundation.org
Subject: [PATCH RFC 0/3] Per-process power consumption measurement facility
Date: Tue, 30 Jul 2013 12:17:36 +0400
Message-id: <1375172259-9641-1-git-send-email-k.krivyakin@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLJMWRmVeSWpSXmKPExsVy+t/xq7obyr4HGlyapG4xZ/0aNou159qZ
	LFZcPcJoMXXhYXaL3gVX2SzONr1ht7i8aw6bxedeoMSlAwuYLI73HmCy6F/Yy2Sx8auHA4/H
	5hVaHneu7WHzODHjN4vH+31X2Tz6tqxi9Hi0uIXR4/MmuQD2KC6blNSczLLUIn27BK6MJ12O
	BWt4K7pbGtkaGH9zdjFyckgImEj8+LOFCcIWk7hwbz1bFyMXh5DAUkaJhxP2MkE43UwSp/df
	YAGpYgPq2L33IjNIQkRgMaPEspuTwNqZBZoYJf6dKOpi5OAQFvCW6JucBxJmEVCV+P5sAzuI
	zSvgJnHreh8rSImEgILEnEk2Exi5FzAyrGIUTS1NLihOSs810itOzC0uzUvXS87P3cQICbKv
	OxiXHrM6xCjAwajEw8tR/C1QiDWxrLgy9xCjBAezkggvyw2gEG9KYmVValF+fFFpTmrxIUYm
	Dk6pBsYFT0sb21//sl6+/c+rQ/+SbNYenuWvc97gXBfXYSc+rk27a67wW794IxS2qYvn46Un
	9tdTP+rHlgsdv2CacCIxSnN2Tflm91irYL8LrNbhl3+djDx/65/yyvos9T5DHWvhta9NKqs+
	Xjou4Pjhxh3lnVILPumZV66N6XBKXmAyZeOM4I65ynlKLMUZiYZazEXFiQDOF0OJEAIAAA==
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

