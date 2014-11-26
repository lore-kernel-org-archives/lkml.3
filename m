Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbaKZRk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 12:40:28 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:55155 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbaKZRkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 12:40:22 -0500
From: Leif Lindholm <leif.lindholm@linaro.org>
To: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: mark.rutland@arm.com, grant.likely@linaro.org, robh+dt@kernel.org,
        plagnioj@jcrosoft.com, ijc@debian.org, andrew@lunn.ch,
        s.hauer@pengutronix.de
Subject: [PATCH v2 0/2] of: support passing console options with stdout-path
Date: Wed, 26 Nov 2014 17:40:38 +0000
Message-Id: <1417023640-23464-1-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This used to be a simple little patch, enabling support for passing
console parameters via stdout-path. It is now a two-part monstrosity
series, changing a core dt function interface and touching 107 files.

Due to its invasiveness, checkpatch throws both errors and warnings
on 1/2, as it maintains existing whitespace errors.

Changes since v1:
- Change interface of of_get_node_by_path() to take an additional
  argument, and update all of its callers to keep working.
- Rework original patch to use this interface.

Leif Lindholm (2):
  of: add optional options parameter to of_find_node_by_path()
  of: support passing console options with stdout-path

 arch/arm/kernel/devtree.c                       |    2 +-
 arch/arm/mach-bcm/kona_smp.c                    |    2 +-
 arch/arm/mach-imx/clk.c                         |    2 +-
 arch/arm/mach-imx/cpu.c                         |    2 +-
 arch/arm/mach-integrator/integrator_ap.c        |    4 +-
 arch/arm/mach-mxs/mach-mxs.c                    |    2 +-
 arch/arm/mach-nomadik/cpu-8815.c                |    2 +-
 arch/arm/mach-shmobile/timer.c                  |    2 +-
 arch/arm/mach-u300/core.c                       |    2 +-
 arch/arm64/kernel/topology.c                    |    2 +-
 arch/microblaze/kernel/reset.c                  |    2 +-
 arch/powerpc/include/asm/kvm_para.h             |    2 +-
 arch/powerpc/kernel/btext.c                     |    2 +-
 arch/powerpc/kernel/ibmebus.c                   |    4 +-
 arch/powerpc/kernel/legacy_serial.c             |    4 +-
 arch/powerpc/kernel/machine_kexec.c             |    2 +-
 arch/powerpc/kernel/machine_kexec_64.c          |    2 +-
 arch/powerpc/kernel/pci_32.c                    |    4 +-
 arch/powerpc/kernel/proc_powerpc.c              |    2 +-
 arch/powerpc/kernel/rtas.c                      |    2 +-
 arch/powerpc/kernel/rtas_pci.c                  |    2 +-
 arch/powerpc/kernel/setup-common.c              |    6 +-
 arch/powerpc/kernel/setup_64.c                  |    2 +-
 arch/powerpc/mm/numa.c                          |   15 +++--
 arch/powerpc/platforms/52xx/efika.c             |    4 +-
 arch/powerpc/platforms/85xx/xes_mpc85xx.c       |    2 +-
 arch/powerpc/platforms/8xx/mpc885ads_setup.c    |    4 +-
 arch/powerpc/platforms/cell/celleb_setup.c      |    2 +-
 arch/powerpc/platforms/cell/qpace_setup.c       |    2 +-
 arch/powerpc/platforms/cell/ras.c               |    2 +-
 arch/powerpc/platforms/cell/setup.c             |    4 +-
 arch/powerpc/platforms/cell/spufs/inode.c       |    2 +-
 arch/powerpc/platforms/chrp/pci.c               |    4 +-
 arch/powerpc/platforms/chrp/setup.c             |   12 ++--
 arch/powerpc/platforms/embedded6xx/ls_uart.c    |    2 +-
 arch/powerpc/platforms/maple/pci.c              |    2 +-
 arch/powerpc/platforms/maple/setup.c            |    2 +-
 arch/powerpc/platforms/pasemi/pci.c             |    2 +-
 arch/powerpc/platforms/pasemi/setup.c           |    2 +-
 arch/powerpc/platforms/powermac/feature.c       |    6 +-
 arch/powerpc/platforms/powermac/pci.c           |    2 +-
 arch/powerpc/platforms/powermac/setup.c         |    7 ++-
 arch/powerpc/platforms/powermac/smp.c           |    4 +-
 arch/powerpc/platforms/powermac/udbg_scc.c      |    2 +-
 arch/powerpc/platforms/powernv/opal-async.c     |    2 +-
 arch/powerpc/platforms/powernv/opal-sysparam.c  |    2 +-
 arch/powerpc/platforms/powernv/opal.c           |    4 +-
 arch/powerpc/platforms/powernv/setup.c          |    2 +-
 arch/powerpc/platforms/ps3/os-area.c            |    4 +-
 arch/powerpc/platforms/pseries/dlpar.c          |    8 +--
 arch/powerpc/platforms/pseries/hotplug-memory.c |    6 +-
 arch/powerpc/platforms/pseries/io_event_irq.c   |    2 +-
 arch/powerpc/platforms/pseries/lparcfg.c        |    6 +-
 arch/powerpc/platforms/pseries/pseries_energy.c |    4 +-
 arch/powerpc/platforms/pseries/ras.c            |    4 +-
 arch/powerpc/platforms/pseries/reconfig.c       |    6 +-
 arch/powerpc/platforms/pseries/setup.c          |    4 +-
 arch/powerpc/sysdev/mpic_msgr.c                 |    2 +-
 arch/powerpc/sysdev/mv64x60_dev.c               |    2 +-
 arch/powerpc/sysdev/mv64x60_udbg.c              |    2 +-
 arch/sparc/kernel/chmc.c                        |    2 +-
 arch/sparc/kernel/irq_64.c                      |    2 +-
 arch/sparc/kernel/leon_kernel.c                 |    2 +-
 arch/sparc/kernel/leon_smp.c                    |    2 +-
 arch/sparc/kernel/of_device_32.c                |    2 +-
 arch/sparc/kernel/of_device_64.c                |    2 +-
 arch/sparc/kernel/prom_32.c                     |    2 +-
 arch/sparc/kernel/time_64.c                     |    2 +-
 arch/x86/platform/olpc/olpc.c                   |    2 +-
 drivers/ata/pata_macio.c                        |    2 +-
 drivers/cpufreq/pmac64-cpufreq.c                |    5 +-
 drivers/cpufreq/powernv-cpufreq.c               |    2 +-
 drivers/cpuidle/cpuidle-big_little.c            |    2 +-
 drivers/cpuidle/cpuidle-powernv.c               |    2 +-
 drivers/edac/cpc925_edac.c                      |    2 +-
 drivers/hwmon/ibmpowernv.c                      |    4 +-
 drivers/ide/pmac.c                              |    2 +-
 drivers/input/misc/sparcspkr.c                  |    2 +-
 drivers/input/serio/i8042-sparcio.h             |    4 +-
 drivers/irqchip/irq-atmel-aic-common.c          |    2 +-
 drivers/macintosh/therm_pm72.c                  |    4 +-
 drivers/macintosh/via-pmu-led.c                 |    2 +-
 drivers/macintosh/windfarm_mpu.h                |    2 +-
 drivers/macintosh/windfarm_pm72.c               |    2 +-
 drivers/mtd/nand/mpc5121_nfc.c                  |    2 +-
 drivers/net/ethernet/amd/sunlance.c             |    2 +-
 drivers/of/base.c                               |   34 +++++++----
 drivers/of/platform.c                           |    4 +-
 drivers/of/resolver.c                           |    4 +-
 drivers/of/selftest.c                           |   73 ++++++++++++++---------
 drivers/sbus/char/display7seg.c                 |    2 +-
 drivers/sbus/char/envctrl.c                     |    2 +-
 drivers/sbus/char/openprom.c                    |   10 ++--
 drivers/scsi/ibmvscsi/ibmvfc.c                  |    2 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c                |    2 +-
 drivers/soc/tegra/common.c                      |    2 +-
 drivers/tty/hvc/hvc_opal.c                      |    4 +-
 drivers/tty/serial/nwpserial.c                  |    2 +-
 drivers/tty/serial/suncore.c                    |    2 +-
 drivers/tty/serial/sunsu.c                      |    6 +-
 drivers/tty/sysrq.c                             |    2 +-
 drivers/video/fbdev/aty/radeon_monitor.c        |    2 +-
 drivers/virt/fsl_hypervisor.c                   |    2 +-
 drivers/watchdog/cpwd.c                         |    2 +-
 fs/openpromfs/inode.c                           |    2 +-
 include/linux/of.h                              |    5 +-
 sound/soc/fsl/fsl_ssi.c                         |    2 +-
 107 files changed, 234 insertions(+), 195 deletions(-)

-- 
1.7.10.4

