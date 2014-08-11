Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbaHKOew (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 10:34:52 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:59953 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492AbaHKOeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 10:34:50 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@linaro.org>
Date: Mon, 11 Aug 2014 15:34:29 +0100
X-Google-Sender-Auth: 6JBA31WVtuCaY4VYDJP9x7g4iFg
Message-ID: <CACxGe6tWuUhjgqzyiE5yA8CLzFakGkd94PVsUzSW2gFdE2k87A@mail.gmail.com>
Subject: [GIT PULL] Devicetree changes for v3.17
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rob Herring <robh+dt@kernel.org>,
        "gaurav.minocha@alumni.ubc.ca" <gaurav.minocha@alumni.ubc.ca>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here is the DT pull request for v3.17 as described below in the tag.
Please pull.

Thanks,
g.

The following changes since commit cd3de83f147601356395b57a8673e9c5ff1e59d1:

  Linux 3.16-rc4 (2014-07-06 12:37:51 -0700)

are available in the git repository at:

  git://git.secretlab.ca/git/linux tags/devicetree-for-linus

for you to fetch changes up to 663d3f7c2e5e1b018a4c53277ccfde40329d98ca:

  Merge branch 'devicetree/next-overlay' into devicetree/next
(2014-08-11 14:06:23 +0100)

----------------------------------------------------------------

The branch contains the following device tree changes the v3.17 merge
window:

Group changes to the device tree. In preparation for adding device tree
overlay support, OF_DYNAMIC is reworked so that a set of device tree
changes can be prepared and applied to the tree all at once. OF_RECONFIG
notifiers see the most significant change here so that users always get
a consistent view of the tree. Notifiers generation is moved from before
a change to after it, and notifiers for a group of changes are emitted
after the entire block of changes have been applied

Automatic console selection from DT. Console drivers can now use
of_console_check() to see if the device node is specified as a console
device. If so then it gets added as a preferred console. UART devices
get this support automatically when uart_add_one_port() is called.

DT unit tests no longer depend on pre-loaded data in the device tree.
Data is loaded dynamically at the start of unit tests, and then unloaded
again when the tests have completed.

Also contains a few bugfixes for reserved regions and early memory setup.

----------------------------------------------------------------
Gaurav Minocha (2):
      Adding selftest testdata dynamically into live tree
      of: Fixing OF Selftest build error

Grant Likely (15):
      of: Create of_console_check() for selecting a console specified in /chosen
      of: Enable console on serial ports specified by /chosen/stdout-path
      arm/versatile: Add the uart as the stdout device.
      tty: Update hypervisor tty drivers to use core stdout parsing code.
      of: Migrate of_find_node_by_name() users to for_each_node_by_name()
      of/platform: Fix of_platform_device_destroy iteration of devices
      of: Move CONFIG_OF_DYNAMIC code into a separate file
      of: Make devicetree sysfs update functions consistent.
      of: Make sure attached nodes don't carry along extra children
      of: Move dynamic node fixups out of powerpc and into common code
      of: Reorder device tree changes and notifiers
      of: Add todo tasklist for Devicetree
      of: typo fix in __of_prop_dup()
      Merge branch 'devicetree/next-console' into devicetree/next
      Merge branch 'devicetree/next-overlay' into devicetree/next

Laura Abbott (1):
      of: Use proper types for checking memory overflow

Marek Szyprowski (1):
      drivers: of: add automated assignment of reserved regions to
client devices

Pantelis Antoniou (4):
      of: rename of_aliases_mutex to just of_mutex
      OF: Utility helper functions for dynamic nodes
      of: Create unlocked versions of node and property add/remove functions
      of: Transactional DT support.

 Documentation/devicetree/changesets.txt         |  40 ++
 Documentation/devicetree/todo.txt               |  11 +
 arch/arm/boot/dts/versatile-ab.dts              |   4 +
 arch/arm/boot/dts/versatile-pb.dts              |   2 -
 arch/powerpc/kernel/prom.c                      |  70 ---
 arch/powerpc/platforms/powermac/feature.c       |  20 +-
 arch/powerpc/platforms/powermac/pci.c           |   2 +-
 arch/powerpc/platforms/powermac/smp.c           |   2 +-
 arch/powerpc/platforms/powermac/udbg_adb.c      |   2 +-
 arch/powerpc/platforms/pseries/hotplug-memory.c |   2 +-
 arch/powerpc/platforms/pseries/setup.c          |   3 +-
 drivers/cpufreq/pmac64-cpufreq.c                |   3 +-
 drivers/crypto/nx/nx-842.c                      |  30 +-
 drivers/edac/cell_edac.c                        |   3 +-
 drivers/of/Kconfig                              |   3 +-
 drivers/of/Makefile                             |   4 +-
 drivers/of/base.c                               | 451 +++++-----------
 drivers/of/device.c                             |   4 +-
 drivers/of/dynamic.c                            | 660 ++++++++++++++++++++++++
 drivers/of/fdt.c                                |  22 +-
 drivers/of/of_private.h                         |  59 ++-
 drivers/of/of_reserved_mem.c                    |  70 +++
 drivers/of/platform.c                           |  32 +-
 drivers/of/selftest.c                           | 235 +++++++++
 drivers/of/testcase-data/testcases.dts          |  15 +
 drivers/of/testcase-data/testcases.dtsi         |   4 -
 drivers/pci/hotplug/rpaphp_core.c               |   4 +-
 drivers/tty/ehv_bytechan.c                      |  43 +-
 drivers/tty/hvc/hvc_opal.c                      |  15 +-
 drivers/tty/hvc/hvc_vio.c                       |  29 +-
 drivers/tty/serial/pmac_zilog.c                 |   9 +-
 drivers/tty/serial/serial_core.c                |   3 +
 include/linux/of.h                              |  87 +++-
 include/linux/of_platform.h                     |   7 +-
 include/linux/of_reserved_mem.h                 |   7 +
 sound/ppc/pmac.c                                |   6 +-
 36 files changed, 1382 insertions(+), 581 deletions(-)
 create mode 100644 Documentation/devicetree/changesets.txt
 create mode 100644 Documentation/devicetree/todo.txt
 create mode 100644 drivers/of/dynamic.c
 create mode 100644 drivers/of/testcase-data/testcases.dts
 delete mode 100644 drivers/of/testcase-data/testcases.dtsi
