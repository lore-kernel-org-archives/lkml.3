Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab3AXMwC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 07:52:02 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:53313 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753054Ab3AXMvx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 07:51:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: [GIT PULL] ACPI and power management fixes for v3.8-rc5
Date: Thu, 24 Jan 2013 13:57:55 +0100
Message-ID: <4322980.ey5AOPpS2x@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm+acpi-for-3.8-rc5

to receive ACPI and power management fixes for v3.8-rc5 with top-most commit
efa17194581bdfca0986dabc178908bd7c21ba00

  cpufreq: Add module aliases for acpi-cpufreq

on top of commit 7d1f9aeff1ee4a20b1aeb377dd0f579fe9647619

  Linux 3.8-rc4

Included are:

* Two cpuidle initialization fixes (both -stable material) from
  Konrad Rzeszutek Wilk.

* cpufreq regression fixes for AMD processors, mostly related to the change
  of the default driver for newer CPUs from powernow-k8 to acpi-cpufreq.
  From Borislav Petkov, Stefan Bader, Matthew Garrett.

* ACPI cpufreq fix related to system reconfigurations such as the switch
  from battery to AC power from Thomas Schlichter (-stable material).

* cpufreq and devfreq fixes related to incorrect usage of operating
  performance points (OPP) framework and RCU from Nishanth Menon
  (-stable material).

* APEI workaround for incorrect BIOS information from Lans Zhang.

Thanks!
 

 drivers/acpi/apei/apei-base.c    |    3 ++
 drivers/acpi/processor_idle.c    |    4 ++
 drivers/acpi/processor_perflib.c |    7 ++++
 drivers/cpufreq/Kconfig.x86      |    2 +-
 drivers/cpufreq/acpi-cpufreq.c   |    7 ++++
 drivers/cpufreq/cpufreq-cpu0.c   |    5 +++
 drivers/cpufreq/omap-cpufreq.c   |    3 ++
 drivers/devfreq/devfreq.c        |    5 +++
 drivers/devfreq/exynos4_bus.c    |   94 +++++++++++++++++++++++++++++++++-------------
 drivers/idle/intel_idle.c        |    3 +-
 10 files changed, 103 insertions(+), 30 deletions(-)

---------------

Borislav Petkov (1):
      powernow-k8: Add a kconfig dependency on acpi-cpufreq

Konrad Rzeszutek Wilk (2):
      intel_idle: Don't register CPU notifier if we are not running.
      ACPI / cpuidle: Fix NULL pointer issues when cpuidle is disabled

Lans Zhang (1):
      ACPI, APEI: Fixup incorrect 64-bit access width firmware bug

Matthew Garrett (1):
      cpufreq: Add module aliases for acpi-cpufreq

Nishanth Menon (4):
      cpufreq: OMAP: use RCU locks around usage of OPP
      cpufreq: cpufreq-cpu0: use RCU locks around usage of OPP
      PM / devfreq: add locking documentation for recommended_opp
      PM / devfreq: exynos4_bus: honor RCU lock usage

Stefan Bader (1):
      ACPI: Check MSR valid bit before using P-state frequencies

Thomas Schlichter (1):
      ACPI / processor: Get power info before updating the C-states


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
