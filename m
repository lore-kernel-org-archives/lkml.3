Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab3LSPDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 10:03:19 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:58766 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab3LSPDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 10:03:17 -0500
From: Levente Kurusa <levex@linux.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Levente Kurusa <levex@linux.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 0/38] treewide: add all missing put_device calls
Date: Thu, 19 Dec 2013 15:23:27 +0100
Message-Id: <1387463045-2749-1-git-send-email-levex@linux.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is the second part of the patchset-set that aims to add missing put_device
calls when a device_register() call fails. While these issues are only
potential issues, i.e. they haven't been experienced, they are issues and
need to be fixed.

Root cause for the need for the put_device is that under a struct device lies
a kobject and under that a kref. If device_register() fails, then the kref
has already been initialized to reference count of one. This means that it
still exists and hence can cause problems if it has been kfree'd.

The patchset consists of the following patches:

Levente Kurusa (38):
      sh: dma-sysfs: add missing put_device call
      powerpc: qe_lib: add missing put_device call
      powerpc: cell: add missing put_device call
      powerpc: kernel: add missing put_device call
      sparc: kernel: add missing put_device call
      arm: mach-s3c64: add missing put_device call
      arm: locomo: add missing put_device call
      arm: mach-rpc: add missing put_device call
      arm: mach-imx: add missing put_device calls
      arm: exynos: add missing put_device call
      arm: mach-integrator: add missing put_device call
      arm: s5pv210: add missing put_device call
      arm: s390: add missing put_device call
      mips: txx9: add missing put_device call
      mips: txx9: add missing put_device call
      mips: sgi-ip22: add missing put_device call
      parisc: kernel: add missing put_device call
      ia64: kernel: add missing put_device call
      net: atm: add missing put_device call
      net: iucv: add missing put_device call
      workqueue: add missing put_device call
      sound: ac97: add missing put_device call
      sound: soc: add missing put_device call
      pcmcia: add missing put_device call
      pnp: card: add missing put_device call
      xen: xenbus: add missing put_device call
      superhyway: add missing put_device call
      superhyway: intc: add missing put_device call
      superhyway: maple: add missing put_device call
      vlynq: add missing put_device call
      firewire: add missing put_device call
      pcie: add missing put_device call
      scsi: transport: add missing put_device call
      infiniband: core: add missing put_device call
      media: bt8xx: add missing put_device call
      dio: add missing put_device call
      uwb: umc-dev: add missing put_device call
      bcma: add missing put_device call
      
diffstat as follows:
	 arch/arm/common/locomo.c               |    9 +++------
	 arch/arm/mach-exynos/common.c          |    8 +++++++-
	 arch/arm/mach-imx/devices/devices.c    |    7 +++++--
	 arch/arm/mach-integrator/lm.c          |    4 +++-
	 arch/arm/mach-rpc/ecard.c              |    4 +++-
	 arch/arm/mach-s3c64xx/dma.c            |    1 +
	 arch/arm/mach-s5pv210/common.c         |    8 +++++++-
	 arch/ia64/sn/kernel/tiocx.c            |    2 +-
	 arch/mips/sgi-ip22/ip22-gio.c          |    9 ++++++++-
	 arch/mips/txx9/generic/7segled.c       |   13 ++++++++++---
	 arch/mips/txx9/generic/setup.c         |   27 +++++++++++++++++----------
	 arch/parisc/kernel/drivers.c           |    2 +-
	 arch/powerpc/kernel/vio.c              |    1 +
	 arch/powerpc/platforms/cell/spu_base.c |    1 +
	 arch/powerpc/sysdev/qe_lib/qe_ic.c     |    1 +
	 arch/s390/kernel/time.c                |    4 +++-
	 arch/sh/drivers/dma/dma-sysfs.c        |    4 +++-
	 arch/sparc/kernel/vio.c                |    2 +-
	 drivers/bcma/main.c                    |    1 +
	 drivers/dio/dio.c                      |    1 +
	 drivers/firewire/core-device.c         |    9 ++++-----
	 drivers/infiniband/core/sysfs.c        |    4 +++-
	 drivers/media/pci/bt8xx/bttv-gpio.c    |    2 +-
	 drivers/pci/pcie/portdrv_core.c        |    2 +-
	 drivers/pcmcia/cs.c                    |    1 +
	 drivers/pnp/card.c                     |    1 +
	 drivers/scsi/scsi_transport_iscsi.c    |   10 ++++------
	 drivers/sh/intc/core.c                 |    4 +++-
	 drivers/sh/maple/maple.c               |   23 +++++++++--------------
	 drivers/sh/superhyway/superhyway.c     |    6 +++++-
	 drivers/uwb/umc-dev.c                  |    1 +
	 drivers/vlynq/vlynq.c                  |    5 ++++-
	 drivers/xen/xenbus/xenbus_probe.c      |    4 +++-
	 kernel/workqueue.c                     |    2 +-
	 net/atm/atm_sysfs.c                    |    4 +++-
	 net/iucv/af_iucv.c                     |    4 +++-
	 sound/pci/ac97/ac97_codec.c            |    1 +
	 sound/soc/soc-core.c                   |    1 +
	 38 files changed, 127 insertions(+), 66 deletions(-)

Cc: Levente Kurusa <levex@linux.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

--
Regards,
Levente Kurusa
