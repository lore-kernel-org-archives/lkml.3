Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab3GIPzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 11:55:38 -0400
Received: from service87.mimecast.com ([91.220.42.44]:45883 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab3GIPzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 11:55:35 -0400
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: mingo@kernel.org, peterz@infradead.org
Cc: arjan@linux.intel.com, vincent.guittot@linaro.org,
        preeti@linux.vnet.ibm.com, alex.shi@intel.com, efault@gmx.de,
        pjt@google.com, len.brown@intel.com, corbet@lwn.net,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, catalin.marinas@arm.com,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        morten.rasmussen@arm.com
Subject: [RFC][PATCH 0/9] sched: Power scheduler design proposal
Date: Tue,  9 Jul 2013 16:55:29 +0100
Message-Id: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com>
X-Mailer: git-send-email 1.7.9.5
X-OriginalArrivalTime: 09 Jul 2013 15:55:29.0841 (UTC) FILETIME=[BC7E4210:01CE7CBC]
X-MC-Unique: 113070916553203701
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r69FucAo011633

Hi,

This patch set is an initial prototype aiming at the overall power-aware
scheduler design proposal that I previously described
<http://permalink.gmane.org/gmane.linux.kernel/1508480>.

The patch set introduces a cpu capacity managing 'power scheduler' which lives
by the side of the existing (process) scheduler. Its role is to monitor the
system load and decide which cpus that should be available to the process
scheduler. Long term the power scheduler is intended to replace the currently
distributed uncoordinated power management policies and will interface a
unified platform specific power driver obtain power topology information and
handle idle and P-states. The power driver interface should be made flexible
enough to support multiple platforms including Intel and ARM.

This prototype supports very simple task packing and adds cpufreq wrapper
governor that allows the power scheduler to drive P-state selection. The
prototype policy is absolutely untuned, but this will be addressed in the
future. Scalability improvements, such as avoid iterating over all cpus, will
also be addressed in the future.

Thanks,
Morten

Morten Rasmussen (9):
  sched: Introduce power scheduler
  sched: Redirect update_cpu_power to sched/power.c
  sched: Make select_idle_sibling() skip cpu with a cpu_power of 1
  sched: Make periodic load-balance disregard cpus with a cpu_power of
    1
  sched: Make idle_balance() skip cpus with a cpu_power of 1
  sched: power: add power_domain data structure
  sched: power: Add power driver interface
  sched: power: Add initial frequency scaling support to power
    scheduler
  sched: power: cpufreq: Initial schedpower cpufreq governor

 arch/arm/Kconfig                     |    2 +
 drivers/cpufreq/Kconfig              |    8 +
 drivers/cpufreq/Makefile             |    1 +
 drivers/cpufreq/cpufreq_schedpower.c |  119 +++++++++++++
 include/linux/sched/power.h          |   29 ++++
 kernel/Kconfig.power                 |    3 +
 kernel/sched/Makefile                |    1 +
 kernel/sched/fair.c                  |   43 +++--
 kernel/sched/power.c                 |  307 ++++++++++++++++++++++++++++++++++
 kernel/sched/sched.h                 |   24 +++
 10 files changed, 525 insertions(+), 12 deletions(-)
 create mode 100644 drivers/cpufreq/cpufreq_schedpower.c
 create mode 100644 include/linux/sched/power.h
 create mode 100644 kernel/Kconfig.power
 create mode 100644 kernel/sched/power.c

-- 
1.7.9.5


