Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab3FGMmy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 08:42:54 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:59505 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118Ab3FGMmx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 08:42:53 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: [GIT PULL] Power management and ACPI fixes for v3.10-rc5
Date: Fri, 07 Jun 2013 14:51:58 +0200
Message-ID: <3863425.93Oeg2bhJF@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc4+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm+acpi-3.10-rc5

to receive power management and ACPI fixes for v3.10-rc5 with top-most
commit c6617b39c39d8735c912bb4efd2f735fedff5052

  Merge branch 'pm-fixes'

on top of commit d683b96b072dc4680fc74964eca77e6a23d1fa6e

  Linux 3.10-rc4

These fixes emerged after my previous pull request.  They fix one recent
regression, a few regressions introduced in 3.9 and 3.8, and a couple of
long-standing issues.  A couple of blacklist entries for systems known
to misbehave are added too.

Included are:

- Fix for an ACPI PM regression introduced in 3.9 causing Toshiba
  P870-303 to crash during boot. From yours truly.

- ACPI fix for an issue causing some drivers to attempt to bind to
  devices they shouldn't touch introduced in 3.9 (a broken BIOS is
  requisite to trigger this). From Aaron Lu.

- Fix for a recent cpufreq regression related to a possible race with
  CPU offline. From Michael Wang.

- Fix for an ACPI cpufreq regression introduced in 3.8 causing turbo
  frequencies to be underutilized in some cases. From Ross Lagerwall.

- cpufreq-cpu0 driver fix related to incorrect clock ACPI usage from
  Guennadi Liakhovetski.

- HP WMI driver fix for an issue causing GPS initialization and
  poweroff failures on HP Elitebook 6930p.  From Lan Tianyu.

- APEI (ACPI Platform Error Interface) fix for an issue in the error
  code path in ghes_probe(). From Wei Yongjun.

- New ACPI video driver blacklist entries for HP m4 and HP Pavilion
  g6 from Alex Hung and Ash Willis.

Thanks!


---------------

Aaron Lu (1):
      ACPI / scan: do not match drivers against objects having scan handlers

Alex Hung (1):
      ACPI / video: ignore BIOS initial backlight value for HP m4

Ash Willis (1):
      ACPI / video: ignore BIOS initial backlight value for HP Pavilion g6

Guennadi Liakhovetski (1):
      cpufreq: cpufreq-cpu0: use the exact frequency for clk_set_rate()

Michael Wang (1):
      cpufreq: protect 'policy->cpus' from offlining during __gov_queue_work()

Rafael J. Wysocki (1):
      ACPI / PM: Do not execute _PS0 for devices without _PSC during initialization

Ross Lagerwall (1):
      acpi-cpufreq: set current frequency based on target P-State

Wei Yongjun (1):
      ACPI / APEI: fix error return code in ghes_probe()

Lan Tianyu (1):
      x86 / platform / hp_wmi: Fix bluetooth_rfkill misuse in hp_wmi_rfkill_setup()

---------------

 drivers/acpi/apei/ghes.c           |    7 ++++---
 drivers/acpi/device_pm.c           |   10 ++++++----
 drivers/acpi/scan.c                |    4 ++++
 drivers/acpi/video.c               |   16 ++++++++++++++++
 drivers/cpufreq/acpi-cpufreq.c     |    4 ++--
 drivers/cpufreq/cpufreq-cpu0.c     |    5 +++--
 drivers/cpufreq/cpufreq_governor.c |    3 +++
 drivers/platform/x86/hp-wmi.c      |    2 +-
 8 files changed, 39 insertions(+), 12 deletions(-)

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
