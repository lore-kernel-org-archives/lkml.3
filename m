Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933311Ab3CGWF5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 17:05:57 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:36865 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758733Ab3CGWFx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 17:05:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: [GIT PULL] ACPI and power management fixes for v3.9-rc2
Date: Thu, 07 Mar 2013 23:12:51 +0100
Message-ID: <1885118.tBgWHmWy46@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc1+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm+acpi-3.9-rc2

to receive ACPI and power management fixes for v3.9-rc2 with top-most commit
6bd51658fae374557b063155bd4465411acd12fc

  Merge branch 'pm-fixes' into fixes

on top of commit 6dbe51c251a327e012439c4772097a13df43c5b8

  Linux 3.9-rc1

Included are:

- Two fixes for the new intel_pstate driver from Dirk Brandewie.

- Fix for incorrect usage of the .find_bridge() callback from struct
  acpi_bus_type in the USB core and subsequent removal of that
  callback.  This couldn't be pushed earlier, because it depended
  on material in the PCI and PM/ACPI trees, so it needed to wait for
  them both to be merged.

- ACPI processor driver cleanups from Chen Gang and Syam Sidhardhan.

- ACPI initialization and error messages fix from Joe Perches.

- Operating Performance Points documentation improvement from
  Nishanth Menon.

- Fixes for memory leaks and potential concurrency issues and sysfs
  attributes leaks during device removal in the core device PM QoS
  code.

- Calxeda Highbank cpufreq driver simplification from Emilio López.

- cpufreq comment cleanup from Namhyung Kim.

- Fix for a section mismatch in Calxeda Highbank interprocessor
  communication code from Mark Langsdorf (this is not a PM fix
  strictly speaking, but the code in question went in through the
  PM tree).

Thanks!


---------------

Chen Gang (1):
      ACPI / porocessor: Beautify code, pr->id is u32 which is never < 0

Dirk Brandewie (2):
      cpufreq / intel_pstate: Fix intel_pstate_init() error path
      cpufreq / intel_pstate: Do not load on VM that does not report max P state.

Emilio López (1):
      cpufreq: highbank: do not initialize array with a loop

Joe Perches (1):
      ACPI / Sleep: Avoid interleaved message on errors

Mark Langsdorf (1):
      mailbox, pl320-ipc: remove __init from probe function

Namhyung Kim (1):
      cpufreq: Fix a typo in comment

Nishanth Menon (1):
      PM / OPP: improve introductory documentation

Rafael J. Wysocki (4):
      PM / QoS: Fix concurrency issues and memory leaks in device PM QoS
      PM / QoS: Remove device PM QoS sysfs attributes at the right place
      ACPI / glue: Add .match() callback to struct acpi_bus_type
      ACPI / glue: Drop .find_bridge() callback from struct acpi_bus_type

Syam Sidhardhan (1):
      ACPI / processor: Remove redundant NULL check before kfree

---------------

 Documentation/power/opp.txt        |   25 ++++-
 drivers/acpi/glue.c                |   55 ++---------
 drivers/acpi/processor_core.c      |    3 +-
 drivers/acpi/processor_driver.c    |    2 +-
 drivers/acpi/sleep.c               |   16 +++-
 drivers/ata/libata-acpi.c          |    7 +-
 drivers/base/power/main.c          |    2 -
 drivers/base/power/power.h         |    8 +-
 drivers/base/power/qos.c           |  217 +++++++++++++++++++++++++-------------------
 drivers/base/power/sysfs.c         |    1 +
 drivers/cpufreq/cpufreq_governor.h |    2 +-
 drivers/cpufreq/highbank-cpufreq.c |    8 +-
 drivers/cpufreq/intel_pstate.c     |   42 +++------
 drivers/mailbox/pl320-ipc.c        |    3 +-
 drivers/pci/pci-acpi.c             |    8 +-
 drivers/pnp/pnpacpi/core.c         |    8 +-
 drivers/scsi/scsi_lib.c            |    7 +-
 drivers/usb/core/usb-acpi.c        |    9 +-
 include/acpi/acpi_bus.h            |    6 +-
 19 files changed, 215 insertions(+), 214 deletions(-)

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
