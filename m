Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbaLKOLD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 09:11:03 -0500
Received: from mail-ig0-f172.google.com ([209.85.213.172]:52266 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbaLKOLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 09:11:00 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 11 Dec 2014 14:10:39 +0000
X-Google-Sender-Auth: yIupFRsa3aLK3OpX-jzqMri6iv8
Message-ID: <CACxGe6vVGcbYeZS85Z6iQiV09ecydm2Qq_kWepFJAvFMH4bK=Q@mail.gmail.com>
Subject: [GIT PULL] Devicetree changes for v3.19
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following branch to get the DT changes queued for
v3.19. Lots of changes this time around as described below...

Thanks,
g.

The following changes since commit 5d01410fe4d92081f349b013a2e7a95429e4f2c9:

  Linux 3.18-rc6 (2014-11-23 15:25:20 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/glikely/linux
tags/devicetree-for-linus

for you to fetch changes up to c46ca3c8310b61d253a39ff1375ea97912794cd1:

  of: Delete unnecessary check before calling "of_node_put()"
(2014-12-03 23:12:41 +0000)

----------------------------------------------------------------
Devicetree changes for v3.19

Lots of activity in the devicetree code for v3.18. Most of it is related
to getting all of the overlay support code in place, but there are other
important things in there.

There are a few trivial merge conflicts. They shouldn't give you any
trouble.

Highlights:
- OF_RECONFIG notifiers for SPI, I2C and Platform devices. Those
  subsystems can now respond to live changes to the device tree.
- CONFIG_OF_OVERLAY method for applying live changes to the device tree
- Removal of the of_allnodes list. This used to be used to iterate over
  all the nodes in the device tree, but it is unnecessary because the
  same thing can be done by iterating over the list of child pointers.
  Getting rid of of_allnodes saves some memory and avoids the
  possibility of of_allnodes being sorted differently from the child
  lists.
- Support for retrieving original DTB blob via sysfs. Needed by kexec.
- More unittests
- Documentation and minor bug fixes

----------------------------------------------------------------
Ard Biesheuvel (2):
      of: check for size < 0 after rounding in early_init_dt_add_memory_arch
      of/fdt: export fdt blob as /sys/firmware/fdt

Benjamin Herrenschmidt (1):
      of/address: Don't throw errors on absent ranges properties

Bjorn Helgaas (1):
      of/fdt: Don't clear initial_boot_params if fdt_check_header() fails

Fabio Estevam (1):
      spi: Check for spi_of_notifier when CONFIG_OF_DYNAMIC=y

Geert Uytterhoeven (4):
      of: Correct of_phandle_args node reference in comments
      of: Improve grammar for of_alias_scan() documentation
      of: Grammar s/an/a/
      of: Remove spaces before tabs

Grant Likely (14):
      of: Eliminate of_allnodes list
      of/unittest: Remove test devices after adding them
      of/unittest: Rename selftest.c to unittest.c
      of/platform: Move platform devices under /sys/devices/platform
      of: Properly set the OF_POPULATED_BUS flag on root node
      Merge tag 'v3.18-rc6' into devicetree/next
      of: Use vargs in __of_node_alloc
      of: Refactor __of_node_alloc() into __of_node_dup()
      of/reconfig: Add empty stubs for the of_reconfig methods
      of/reconfig: Add debug output for OF_RECONFIG notifiers
      of/reconfig: Always use the same structure for notifiers
      of: remove select of non-existant OF_DEVICE config symbol
      of: Remove unneeded and incorrect MODULE_DEVICE_TABLE
      of: Drop ->next pointer from struct device_node

Jiri Slaby (1):
      of: base, fix of_property_read_string_helper kernel-doc

Kevin Cernekee (2):
      of: Fix of_device_is_compatible() comment
      of: Change of_device_is_available() to return bool

Leif Lindholm (3):
      of: Add bindings for chosen node, stdout-path
      of: add optional options parameter to of_find_node_by_path()
      of: support passing console options with stdout-path

Linus Walleij (1):
      ARM: dt: fix up PL011 device tree bindings

Markus Elfring (1):
      of: Delete unnecessary check before calling "of_node_put()"

Matthias Brugger (1):
      of: Request and map make argument name constant

Pantelis Antoniou (9):
      of/resolver: Switch to new local fixups format.
      of/reconfig: Add of_reconfig_get_state_change() of notifier helper.
      of/reconfig: Add OF_DYNAMIC notifier for platform_bus_type
      of/overlay: Introduce DT overlay support
      of/overlay: Add overlay unittests
      i2c/of: Factor out Devicetree registration code
      i2c/of: Add OF_RECONFIG notifier handler
      spi/of: Create new device registration method and accessors
      spi/of: Add OF notifier handler

Sebastian Reichel (1):
      of: introduce of_property_read_s32

Thierry Reding (1):
      of: Fix padding in _OF_DECLARE macro definition

 Documentation/devicetree/bindings/chosen.txt       |  46 ++
 Documentation/devicetree/bindings/serial/pl011.txt |  28 +-
 Documentation/devicetree/bindings/unittest.txt     |  14 +
 Documentation/devicetree/of_selftest.txt           |  20 +-
 Documentation/devicetree/overlay-notes.txt         | 133 +++++
 Documentation/devicetree/todo.txt                  |   1 -
 arch/powerpc/mm/numa.c                             |   3 +-
 arch/powerpc/platforms/pseries/hotplug-cpu.c       |   7 +-
 arch/powerpc/platforms/pseries/hotplug-memory.c    |  15 +-
 arch/powerpc/platforms/pseries/iommu.c             |   5 +-
 arch/powerpc/platforms/pseries/setup.c             |   5 +-
 drivers/base/platform.c                            |   1 +
 drivers/crypto/nx/nx-842.c                         |   4 +-
 drivers/i2c/i2c-core.c                             | 149 +++--
 drivers/mfd/vexpress-sysreg.c                      |   2 +-
 drivers/of/Kconfig                                 |  11 +-
 drivers/of/Makefile                                |   5 +-
 drivers/of/address.c                               |   4 +-
 drivers/of/base.c                                  | 135 +++--
 drivers/of/dynamic.c                               | 218 +++++--
 drivers/of/fdt.c                                   | 111 ++--
 drivers/of/of_private.h                            |   2 +-
 drivers/of/overlay.c                               | 562 ++++++++++++++++++
 drivers/of/pdt.c                                   |  27 +-
 drivers/of/platform.c                              |  65 ++-
 drivers/of/resolver.c                              | 128 ++++-
 drivers/of/testcase-data/testcases.dts             |  50 --
 drivers/of/unittest-data/testcases.dts             |  79 +++
 .../tests-interrupts.dtsi                          |   0
 .../tests-match.dtsi                               |   0
 drivers/of/unittest-data/tests-overlay.dtsi        | 180 ++++++
 .../tests-phandle.dtsi                             |   0
 .../tests-platform.dtsi                            |   0
 drivers/of/{selftest.c => unittest.c}              | 633 +++++++++++++++++++--
 drivers/spi/spi.c                                  | 306 ++++++----
 include/linux/of.h                                 | 121 +++-
 include/linux/of_address.h                         |   4 +-
 include/linux/of_pdt.h                             |   3 +-
 include/linux/of_platform.h                        |   6 +
 39 files changed, 2560 insertions(+), 523 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/chosen.txt
 create mode 100644 Documentation/devicetree/bindings/unittest.txt
 create mode 100644 Documentation/devicetree/overlay-notes.txt
 create mode 100644 drivers/of/overlay.c
 delete mode 100644 drivers/of/testcase-data/testcases.dts
 create mode 100644 drivers/of/unittest-data/testcases.dts
 rename drivers/of/{testcase-data => unittest-data}/tests-interrupts.dtsi (100%)
 rename drivers/of/{testcase-data => unittest-data}/tests-match.dtsi (100%)
 create mode 100644 drivers/of/unittest-data/tests-overlay.dtsi
 rename drivers/of/{testcase-data => unittest-data}/tests-phandle.dtsi (100%)
 rename drivers/of/{testcase-data => unittest-data}/tests-platform.dtsi (100%)
 rename drivers/of/{selftest.c => unittest.c} (66%)
