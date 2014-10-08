Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbaJHG0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 02:26:38 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:42906 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172AbaJHG0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 02:26:37 -0400
From: Mike Turquette <mturquette@linaro.org>
To: Morten Rasmussen <morten.rasmussen@arm.com>, peterz@infradead.org,
        mingo@redhat.com
Cc: dietmar.eggemann@arm.com, pjt@google.com, bsegall@google.com,
        vincent.guittot@linaro.org, nicolas.pitre@linaro.org,
        rjw@rjwysocki.net, linux-kernel@vger.kernel.org,
        tuukka.tikkanen@linaro.org, Mike Turquette <mturquette@linaro.org>
Subject: [PATCH RFC 0/2] introduce capacity_ops to CFS
Date: Tue,  7 Oct 2014 23:26:10 -0700
Message-Id: <1412749572-29449-1-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20141008060712.4379.42509@quantum>
References: <20141008060712.4379.42509@quantum>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The fair scheduler needs a method to retrieve the capacity of a cpu,
which may be derived from several platform-specific factors including
micro-architectural differences (e.g. big.LITTLE cpus), cpus with
different transistor types or process node properties (e.g. Nvidia
Tegra30 LP cpu) and cpu frequency (for cpus that dynamically scale clock
speed).

This info is inherently machine-specific and the first patch in this
series implements a new callback, .get_capacity as part of struct
capacity_ops. The default simply returns SCHED_CAPACITY_SCALE.

The second patch populates that callback with CPUfreq-based method for
machines using the arm_big_little CPUfreq driver. This can likely be
abstracted out a bit more to be generally useful to more CPUfreq drivers
but I wanted to gather feedback on the approach before going any
further.

Mike Turquette (2):
  sched: cfs: introduce capacity_ops
  cpufreq: arm_big_little: provide cpu capacity

 arch/arm/include/asm/topology.h  |  2 ++
 arch/arm/kernel/topology.c       | 42 ++-------------------------------
 drivers/cpufreq/arm_big_little.c | 51 ++++++++++++++++++++++++++++++++++++++++
 include/linux/sched.h            | 28 ++++++++++++++++++++++
 kernel/sched/fair.c              | 41 +++++++++++++++++++++++++++-----
 5 files changed, 118 insertions(+), 46 deletions(-)

-- 
1.8.3.2

