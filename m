Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab3KMBBP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 20:01:15 -0500
Received: from mga09.intel.com ([134.134.136.24]:60247 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753435Ab3KMBBA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 20:01:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="407797740"
Message-ID: <1384304455.3859.5.camel@rzhang1-mobl4>
Subject: [GIT PULL] thermal management updates for v3.13-rc1
From: Zhang Rui <rui.zhang@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Date: Wed, 13 Nov 2013 09:00:55 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git next

to receive thermal management updates for v3.13-rc1 with
top-most commit 86e0a0bdf81c2dfa2a5a258dbb52f49c40ebc197:

  Merge branches 'intel_powerclamp', 'tmon' and 'misc' of .git into next
(2013-11-07 08:45:54 +0800)

on top of commit 959f58544b7f20c92d5eb43d1232c96c15c01bfb:

  Linux 3.12-rc7 (2013-10-27 16:12:03 -0700)

This time we only have a few changes as there are no soc thermal changes
from Eduardo. The only big change is the introduction of TMON, a tool to
help visualize, tune, and test the thermal subsystem. The rest is mostly
cleanups and fixes all over.

Specifics:

- introduce TMON, a tool base on thermal sysfs I/F. It can be used to
visualize, tune and test the thermal subsystem.

- fix a zone/cooling device binding problem, when both thermal zone bind
parameters and .bind() callback are available.

thanks,
rui


----------------------------------------------------------------

Jacob Pan (2):
      thermal/intel_powerclamp: Add newer CPU models
      tools/thermal: Introduce tmon, a tool for thermal subsystem

Luka Perkov (1):
      thermal: Kconfig: cosmetic fixes

Ni Wade (1):
      thermal: Fix binding problem when there is thermal zone params

Regid Ichira (1):
      typo in drivers/thermal/Kconfig: lpatform instead of platform

Srinivas Pandruvada (1):
      ACPI/thermal : Remove zone disabled warning

Wei Yongjun (1):
      thermal: cpu_cooling: fix return value check in
cpufreq_cooling_register()

Zhang Rui (1):
      Merge branches 'intel_powerclamp', 'tmon' and 'misc' of .git into
next

durgadoss.r@intel.com (2):
      Thermal: Tidy up error handling in powerclamp_init
      Thermal: Check for validity before doing kfree

 drivers/acpi/thermal.c             |   10 +-
 drivers/thermal/Kconfig            |    7 +-
 drivers/thermal/cpu_cooling.c      |    4 +-
 drivers/thermal/intel_powerclamp.c |   29 +-
 drivers/thermal/thermal_core.c     |   10 +-
 tools/Makefile                     |   15 +-
 tools/thermal/tmon/Makefile        |   47 +++
 tools/thermal/tmon/README          |   50 +++
 tools/thermal/tmon/pid.c           |  131 ++++++++
 tools/thermal/tmon/sysfs.c         |  596
+++++++++++++++++++++++++++++++++
 tools/thermal/tmon/tmon.8          |  142 ++++++++
 tools/thermal/tmon/tmon.c          |  352 ++++++++++++++++++++
 tools/thermal/tmon/tmon.h          |  204 ++++++++++++
 tools/thermal/tmon/tui.c           |  638
++++++++++++++++++++++++++++++++++++
 14 files changed, 2216 insertions(+), 19 deletions(-)
 create mode 100644 tools/thermal/tmon/Makefile
 create mode 100644 tools/thermal/tmon/README
 create mode 100644 tools/thermal/tmon/pid.c
 create mode 100644 tools/thermal/tmon/sysfs.c
 create mode 100644 tools/thermal/tmon/tmon.8
 create mode 100644 tools/thermal/tmon/tmon.c
 create mode 100644 tools/thermal/tmon/tmon.h
 create mode 100644 tools/thermal/tmon/tui.c


