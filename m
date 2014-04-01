Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464AbaDAKPj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 06:15:39 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:44114 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbaDAKPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 06:15:22 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 1 Apr 2014 11:15:01 +0100
X-Google-Sender-Auth: v7p7wq4Nr5Lk5AG0mFmipsUisFU
Message-ID: <CACxGe6vCrkHPL6UNy1p8AO4+z5VFRY6w4_2grQEZQwp_3jJ7Yw@mail.gmail.com>
Subject: [git pull] Devicetree changes for v3.15
To: Linus Torvalds <torvalds@linux-foundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here are the dt changes I've got queued up for v3.15. The full
description is below in the tag. Please pull.

Thanks,
g.

The following changes since commit fa389e220254c69ffae0d403eac4146171062d08:

  Linux 3.14-rc6 (2014-03-09 19:41:57 -0700)

are available in the git repository at:

  git://git.secretlab.ca/git/linux tags/dt-for-linus

for you to fetch changes up to d88cf7d7b4240b8df170ba105e414e476fb51cce:

  Merge remote-tracking branch 'robh/for-next' into devicetree/next
(2014-03-31 08:10:55 +0100)

----------------------------------------------------------------

Devicetree changes for v3.15

Updates to devicetree core code. This branch contains the following
notable changes:
* Add reserved memory binding
* Make struct device_node a kobject and remove legacy /proc/device-tree
* ePAPR conformance fixes
* Update in-kernel DTC copy to version v1.4.0
* Preparation changes for dynamic device tree overlays
* minor bug fixes and documentation changes

The most significant change in this branch is the conversion of struct
device_node to be a kobject that is exposed via sysfs and removal of the
old /proc/device-tree code. This simplifies the device tree handling
code and tightens up the lifecycle on device tree nodes.

----------------------------------------------------------------
Andreas Herrmann (1):
      of: Increase MAX_PHANDLE_ARGS

Florian Fainelli (1):
      of: make of_get_phy_mode parse 'phy-connection-type'

Florian Vaussard (2):
      of: add vendor prefix for SMSC
      of: add missing major vendors

Grant Likely (13):
      scripts/dtc: Update shipped files to build with bison 2.7.12
      scripts/dtc: Update to upstream version v1.4.0
      scripts/dtc: Add a script to update to mainline dtc source
      Merge branch 'devicetree/dtc' into devicetree/next
      Revert "of: fix of_update_property()"
      Merge tag 'v3.14-rc5' into HEAD
      of: document bindings for reserved-memory nodes
      of: Make device nodes kobjects so they show up in sysfs
      of/selftest: Add self tests for manipulation of properties
      of: remove /proc/device-tree
      Merge branch 'devicetree/next-reserved-mem' into devicetree/next
      of: Add support for ePAPR "stdout-path" property
      Merge remote-tracking branch 'robh/for-next' into devicetree/next

Gregory CLEMENT (2):
      of: Allows to use the PCI translator without the PCI core
      ARM: mvebu: Allows to get the SoC ID even without PCI enabled

Jason Cooper (1):
      kbuild: dtbs_install: new make target

Josh Cartwright (1):
      of: only scan for reserved mem when fdt present

Marek Szyprowski (6):
      drivers: of: add initialization code for static reserved memory
      drivers: of: add initialization code for dynamic reserved memory
      drivers: of: add support for custom reserved memory drivers
      arm: add support for reserved memory defined by device tree
      arm64: add support for reserved memory defined by device tree
      powerpc: add support for reserved memory defined by device tree

Pantelis Antoniou (3):
      of: Introduce device tree node flag helpers.
      of: Clear detach flag on attach
      of: device_node kobject lifecycle fixes

Xiubo Li (2):
      of: add __of_add_property() without lock operations
      of: fix of_update_property()

 Documentation/ABI/testing/sysfs-firmware-ofw       |  28 ++
 .../bindings/reserved-memory/reserved-memory.txt   | 133 ++++++
 .../devicetree/bindings/vendor-prefixes.txt        |  17 +
 Makefile                                           |   7 +
 arch/arm/Kconfig                                   |   1 +
 arch/arm/Makefile                                  |   7 +-
 arch/arm/boot/dts/Makefile                         |   4 +-
 arch/arm/mach-mvebu/Kconfig                        |   1 +
 arch/arm/mm/init.c                                 |   2 +
 arch/arm64/Kconfig                                 |   1 +
 arch/arm64/mm/init.c                               |   1 +
 arch/powerpc/Kconfig                               |   1 +
 arch/powerpc/kernel/prom.c                         |   3 +
 arch/powerpc/platforms/pseries/dlpar.c             |   2 -
 arch/powerpc/platforms/pseries/reconfig.c          |   2 -
 arch/powerpc/sysdev/msi_bitmap.c                   |   2 +-
 drivers/of/Kconfig                                 |  18 +-
 drivers/of/Makefile                                |   1 +
 drivers/of/address.c                               |   8 +-
 drivers/of/base.c                                  | 274 +++++++++---
 drivers/of/fdt.c                                   | 145 ++++++-
 drivers/of/of_net.c                                |  11 +-
 drivers/of/of_reserved_mem.c                       | 217 ++++++++++
 drivers/of/pdt.c                                   |   3 +-
 drivers/of/selftest.c                              |  62 +++
 drivers/of/testcase-data/tests-phandle.dtsi        |   3 +
 fs/proc/Makefile                                   |   1 -
 fs/proc/internal.h                                 |   7 -
 fs/proc/proc_devtree.c                             | 241 -----------
 fs/proc/root.c                                     |   3 -
 include/asm-generic/vmlinux.lds.h                  |  11 +
 include/linux/of.h                                 |  61 ++-
 include/linux/of_fdt.h                             |   4 +
 include/linux/of_reserved_mem.h                    |  53 +++
 scripts/Makefile.lib                               |  12 +
 scripts/dtc/dtc-parser.tab.c_shipped               | 469 +++++++++------------
 scripts/dtc/dtc-parser.tab.h_shipped               |  36 +-
 scripts/dtc/dtc.c                                  | 119 +++---
 scripts/dtc/dtc.h                                  |   1 -
 scripts/dtc/srcpos.c                               |   6 +-
 scripts/dtc/update-dtc-source.sh                   |  54 +++
 scripts/dtc/util.c                                 | 141 ++++++-
 scripts/dtc/util.h                                 | 107 ++++-
 scripts/dtc/version_gen.h                          |   2 +-
 44 files changed, 1555 insertions(+), 727 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-firmware-ofw
 create mode 100644
Documentation/devicetree/bindings/reserved-memory/reserved-memory.txt
 create mode 100644 drivers/of/of_reserved_mem.c
 delete mode 100644 fs/proc/proc_devtree.c
 create mode 100644 include/linux/of_reserved_mem.h
 create mode 100755 scripts/dtc/update-dtc-source.sh
