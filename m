Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab3LFCAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 21:00:52 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:55191 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752702Ab3LFCAv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 21:00:51 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: [GIT PULL] Power management fixes for v3.13-rc3
Date: Fri, 06 Dec 2013 03:13:46 +0100
Message-ID: <2062235.VIUAclBWFD@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm-3.13-rc3

to receive power management fixes for v3.13-rc3 with
top-most commit 8e7030097e9f3ea8031e8cc4230e357cb556f8f9

  Merge branches 'pm-epoll', 'pnp' and 'powercap'

on top of commit dc1ccc48159d63eca5089e507c82c7d22ef60839

  Linux 3.13-rc2

These fix two regressions introduced in 3.12 (in cpufreq and PNP core),
fix up the new power capping framework and recent changes in intel_idle
and cpufreq, and fix a couple of older bugs.

Specifics:

 - cpufreq regression fix from Bjørn Mork restoring the pre-3.12
   behavior of the framework during system suspend/hibernation to
   avoid garbage sysfs files from being left behind in case of a
   suspend error.

 - PNP regression fix to restore the correct states of devices after
   resume from hibernation broken in 3.12.  From Dmitry Torokhov.

 - cpuidle fix to prevent cpuidle device unregistration from crashing 
   due to a NULL pointer dereference if cpuidle has been disabled
   from the kernel command line.  From Konrad Rzeszutek Wilk.

 - intel_idle fix for the C6 state definition on Intel Avoton/Rangeley
   processors from Arne Bockholdt.

 - Power capping framework fix to make the energy_uj sysfs attribute
   work in accordance with the documentation.  From Srinivas Pandruvada.

 - epoll fix to make it ignore the EPOLLWAKEUP flag if the kernel has
   been compiled with CONFIG_PM_SLEEP unset (in which case that flag
   should not have any effect).  From Amit Pundir.

 - cpufreq fix to prevent governor sysfs files from being lost over
   system suspend/resume in some (arguably unusual) situations.  From
   Viresh Kumar.

Thanks!


---------------

Amit Pundir (1):
      epoll: drop EPOLLWAKEUP if PM_SLEEP is disabled

Bjørn Mork (1):
      cpufreq: fix garbage kobjects on errors during suspend/resume

Bockholdt Arne (1):
      intel_idle: Fixed C6 state on Avoton/Rangeley processors

Dmitry Torokhov (1):
      PNP: fix restoring devices after hibernation

Konrad Rzeszutek Wilk (1):
      cpuidle: Check for dev before deregistering it.

Srinivas Pandruvada (1):
      PowerCap: Fix mode for energy counter

Viresh Kumar (1):
      cpufreq: suspend governors on system suspend/hibernate

---------------

 drivers/base/power/main.c       |    3 +++
 drivers/cpufreq/cpufreq.c       |   46 ++++++++++++++++++++++++++++++++++++---
 drivers/cpuidle/cpuidle.c       |    2 +-
 drivers/idle/intel_idle.c       |    4 ++--
 drivers/pnp/driver.c            |   12 +++++++++-
 drivers/powercap/powercap_sys.c |    7 +++++-
 fs/eventpoll.c                  |    3 +--
 include/linux/cpufreq.h         |    8 +++++++
 include/uapi/linux/eventpoll.h  |   13 ++++++++++-
 9 files changed, 87 insertions(+), 11 deletions(-)

