Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933651Ab3GDWVz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 18:21:55 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:58414 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932842Ab3GDWVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 18:21:53 -0400
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 4 Jul 2013 23:21:31 +0100
X-Google-Sender-Auth: qzHJodeB3FZwGzI6Ns81MbxewGg
Message-ID: <CACxGe6tgbDq2rW22M-9qvGTafLhkcoGA60Qi7a+=rs0usXS1bw@mail.gmail.com>
Subject: [GIT PULL] devicetree for v3.11
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following branch. Description in the signed tag.

g.

The following changes since commit 317ddd256b9c24b0d78fa8018f80f1e495481a10:

  Linux 3.10-rc5 (2013-06-08 17:41:04 -0700)

are available in the git repository at:

  git://git.secretlab.ca/git/linux tags/devicetree-for-linus

for you to fetch changes up to 6dd18e4684f3d188277bbbc27545248487472108:

  of: Fix address decoding on Bimini and js2x machines (2013-07-04
16:30:11 +0100)

----------------------------------------------------------------
Device tree updates for v3.11

This branch contains the following changes:
- Removal of CONFIG_OF_DEVICE, it is always enabled by CONFIG_OF
- Remove #ifdef from linux/of_platform.h to increase compiler syntax
  coverage
- Bug fix for address decoding on Bimini and js2x powerpc platforms.
- miscellaneous binding changes

One note on the above. The binding changes going in from all kinds of
different trees has gotten rather out of hand. I picked up some during
this cycle, but even going though my tree isn't a great fit. Ian
Campbell has prototyped splitting the bindings and .dtb files into a
separate repository. The plan is to migrate to using that sometime in
the next few kernel releases which should get rid of a lot of the churn
on binding docs and .dts files.

----------------------------------------------------------------
Arnd Bergmann (1):
      of: remove #ifdef from linux/of_platform.h

Benjamin Herrenschmidt (1):
      of: Fix address decoding on Bimini and js2x machines

Florian Vaussard (1):
      ARM: dts: omap3-devkit8000: fix NAND memory binding

J Keerthy (1):
      mfd: DT bindings for the palmas family MFD

Lad, Prabhakar (1):
      of/base: fix typos

Rob Herring (5):
      driver core: move to_platform_driver to platform_device.h
      ibmebus: convert of_platform_driver to platform_driver
      of: remove of_platform_driver
      usb: chipidea: depend on CONFIG_OF instead of CONFIG_OF_DEVICE
      of: remove CONFIG_OF_DEVICE

 Documentation/devicetree/bindings/mfd/palmas.txt   | 49 +++++++++++++++
 .../devicetree/bindings/regulator/palmas-pmic.txt  | 72 ++++++++++++++++++++++
 arch/arm/boot/dts/omap3-devkit8000.dts             | 29 ++++-----
 arch/powerpc/include/asm/ibmebus.h                 |  4 +-
 arch/powerpc/kernel/ibmebus.c                      | 22 +++----
 drivers/base/platform.c                            |  3 -
 drivers/infiniband/hw/ehca/ehca_main.c             |  5 +-
 drivers/net/ethernet/ibm/ehea/ehea_main.c          |  8 +--
 drivers/of/Kconfig                                 |  3 -
 drivers/of/Makefile                                |  3 +-
 drivers/of/address.c                               |  8 ++-
 drivers/of/base.c                                  | 12 ++--
 drivers/usb/chipidea/Makefile                      |  2 +-
 include/linux/of_device.h                          |  6 +-
 include/linux/of_platform.h                        | 35 +----------
 include/linux/platform_device.h                    |  3 +
 16 files changed, 176 insertions(+), 88 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/palmas.txt
 create mode 100644 Documentation/devicetree/bindings/regulator/palmas-pmic.txt
