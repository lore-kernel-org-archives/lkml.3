Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab3JDKgj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 06:36:39 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:50793 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab3JDKgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 06:36:37 -0400
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 00/21] of: prom.h clean-up and removal
To: Rob Herring <robherring2@gmail.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>, Anatolij Gustschin <agust@denx.de>,
        Aurelien Jacquiot <a-jacquiot@ti.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chris Zankel <chris@zankel.net>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        James Hogan <james.hogan@imgtec.com>, Jonas Bonn <jonas@southpole.se>,
        Kumar Gala <galak@kernel.crashing.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Mark Salter <msalter@redhat.com>, Max Filippov <jcmvbkbc@gmail.com>,
        Michal Simek <monstr@monstr.eu>, Olof Johansson <olof@lixom.net>,
        Paul Mackerras <paulus@samba.org>, Ralf Baechle <ralf@linux-mips.org>,
        Richard Kuo <rkuo@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vineet Gupta <vgupta@synopsys.com>, Will Deacon <will.deacon@arm.com>,
        Wolfgang Grandegger <wg@grandegger.com>, x86@kernel.org
In-Reply-To: <1380221456-11192-1-git-send-email-robherring2@gmail.com>
References: <1380221456-11192-1-git-send-email-robherring2@gmail.com>
Date: Fri, 04 Oct 2013 11:36:32 +0100
Message-Id: <20131004103632.36165C42354@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Sep 2013 13:50:35 -0500, Rob Herring <robherring2@gmail.com> wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> This is the second series of clean-up for architecture DT code. The first
> series is here [1].
> 
> As the number of DT enabled architectures has grown, there has been a lot
> of copy/paste duplication of prom.h. The include ordering for prom.h is
> complex and has resulted in many implicit includes. This series cleans up
> prom.h and removes the dependency of prom.h includes in the core DT code
> on all architectures except sparc. This removes prom.h on several
> architectures and makes it an architecture specific include on the rest.
> 
> Compiled on arm, arm64, microblaze, mips, openrisc, powerpc, sparc,
> xtensa. Mostly defconfigs and some allyesconfigs. The 0-day builder has
> also caught some issues.
> 
> A branch with both series is available here:
> git://sources.calxeda.com/kernel/linux.git dt-cleanup

Nice!

Acked-by: Grant Likely <grant.likely@linaro.org>

for the whole series.

g.

> 
> Rob
> 
> [1] http://www.spinics.net/lists/devicetree/msg04865.html
> 
> Rob Herring (21):
>   drivers: remove unnecessary prom.h includes
>   of: remove unnecessary prom.h includes
>   ARM: keystone: remove unnecessary prom.h include
>   arm64: remove unnecessary prom.h include
>   openrisc: remove unnecessary prom.h include
>   arc: remove unnecessary prom.h includes
>   hexagon: remove unnecessary prom.h includes
>   metag: move setup_machine_fdt declaration from prom.h
>   microblaze: clean-up prom.h implicit includes
>   drivers: clean-up prom.h implicit includes
>   mips: add explicit includes of prom.h
>   x86: add necessary includes for prom.h
>   of: implement pci_address_to_pio as weak function
>   of: implement of_node_to_nid as a weak function
>   of: remove HAVE_ARCH_DEVTREE_FIXUPS
>   of: move of_address_to_resource and of_iomap declarations from sparc
>   of: move of_translate_dma_address to of_address.h
>   powerpc: clean-up include ordering in prom.h
>   powerpc: add explicit OF includes
>   of: only include prom.h on sparc
>   of: remove empty arch prom.h headers
> 
>  arch/arc/include/asm/prom.h                      | 14 ---------
>  arch/arc/kernel/devtree.c                        |  1 -
>  arch/arc/kernel/setup.c                          |  1 -
>  arch/arm/include/asm/prom.h                      |  2 --
>  arch/arm/mach-keystone/platsmp.c                 |  1 -
>  arch/arm64/include/asm/prom.h                    |  1 -
>  arch/arm64/mm/init.c                             |  1 -
>  arch/c6x/include/asm/prom.h                      |  1 -
>  arch/hexagon/kernel/setup.c                      |  3 --
>  arch/metag/include/asm/prom.h                    | 23 --------------
>  arch/metag/include/asm/setup.h                   |  1 +
>  arch/metag/kernel/setup.c                        |  1 -
>  arch/microblaze/include/asm/prom.h               | 39 +-----------------------
>  arch/microblaze/kernel/prom.c                    |  1 +
>  arch/microblaze/kernel/setup.c                   |  1 +
>  arch/microblaze/kernel/timer.c                   |  1 +
>  arch/microblaze/pci/pci-common.c                 |  1 +
>  arch/mips/include/asm/prom.h                     | 11 -------
>  arch/mips/lantiq/prom.c                          |  1 +
>  arch/mips/mti-sead3/sead3-setup.c                |  2 ++
>  arch/mips/ralink/of.c                            |  1 +
>  arch/openrisc/include/asm/prom.h                 | 22 -------------
>  arch/openrisc/kernel/prom.c                      |  1 -
>  arch/powerpc/include/asm/prom.h                  | 33 ++++----------------
>  arch/powerpc/kernel/epapr_paravirt.c             |  1 +
>  arch/powerpc/platforms/512x/clock.c              |  1 +
>  arch/powerpc/platforms/512x/pdm360ng.c           |  2 ++
>  arch/powerpc/platforms/82xx/mpc8272_ads.c        |  2 ++
>  arch/powerpc/platforms/82xx/pq2fads.c            |  2 ++
>  arch/powerpc/platforms/83xx/suspend.c            |  2 ++
>  arch/powerpc/platforms/86xx/pic.c                |  1 +
>  arch/powerpc/platforms/embedded6xx/flipper-pic.c |  1 +
>  arch/powerpc/platforms/embedded6xx/hlwd-pic.c    |  2 ++
>  arch/powerpc/platforms/pasemi/gpio_mdio.c        |  1 +
>  arch/powerpc/platforms/powermac/pfunc_base.c     |  1 +
>  arch/powerpc/platforms/powernv/opal-lpc.c        |  1 +
>  arch/powerpc/platforms/powernv/opal.c            |  1 +
>  arch/powerpc/platforms/powernv/setup.c           |  1 +
>  arch/powerpc/platforms/pseries/hotplug-memory.c  |  2 ++
>  arch/powerpc/sysdev/cpm_common.c                 |  1 +
>  arch/powerpc/sysdev/fsl_gtm.c                    |  2 ++
>  arch/powerpc/sysdev/fsl_pmc.c                    |  1 +
>  arch/powerpc/sysdev/mpic.c                       |  8 ++---
>  arch/powerpc/sysdev/mpic_timer.c                 |  2 ++
>  arch/sparc/include/asm/prom.h                    | 12 --------
>  arch/x86/include/asm/prom.h                      |  5 ---
>  arch/x86/kernel/devicetree.c                     | 11 +------
>  arch/xtensa/include/asm/prom.h                   |  6 ----
>  drivers/ata/sata_fsl.c                           |  2 ++
>  drivers/char/bsr.c                               |  1 +
>  drivers/char/hw_random/pasemi-rng.c              |  1 +
>  drivers/cpufreq/pasemi-cpufreq.c                 |  1 +
>  drivers/crypto/caam/ctrl.c                       |  3 ++
>  drivers/crypto/caam/jr.c                         |  2 ++
>  drivers/dma/fsldma.c                             |  2 ++
>  drivers/edac/cell_edac.c                         |  1 +
>  drivers/i2c/busses/i2c-mpc.c                     |  2 ++
>  drivers/i2c/busses/i2c-powermac.c                |  1 +
>  drivers/input/serio/xilinx_ps2.c                 |  1 +
>  drivers/macintosh/macio_asic.c                   |  2 ++
>  drivers/macintosh/rack-meter.c                   |  2 ++
>  drivers/macintosh/smu.c                          |  1 +
>  drivers/macintosh/via-pmu.c                      |  2 ++
>  drivers/mtd/nand/fsl_elbc_nand.c                 |  1 +
>  drivers/mtd/nand/pasemi_nand.c                   |  2 ++
>  drivers/net/can/grcan.c                          |  3 --
>  drivers/net/can/sja1000/sja1000_of_platform.c    |  1 -
>  drivers/net/ethernet/ibm/emac/core.c             |  2 ++
>  drivers/net/ethernet/ibm/emac/mal.c              |  1 +
>  drivers/net/ethernet/ibm/emac/rgmii.c            |  1 +
>  drivers/net/ethernet/ibm/emac/tah.c              |  1 +
>  drivers/net/ethernet/ibm/emac/zmii.c             |  1 +
>  drivers/net/ethernet/xilinx/ll_temac_main.c      |  1 +
>  drivers/of/address.c                             |  8 +++++
>  drivers/of/base.c                                |  7 +++++
>  drivers/of/of_pci.c                              |  1 -
>  drivers/of/of_pci_irq.c                          |  1 -
>  drivers/of/pdt.c                                 |  1 -
>  drivers/pcmcia/electra_cf.c                      |  2 ++
>  drivers/tty/ehv_bytechan.c                       |  1 +
>  drivers/tty/serial/pmac_zilog.c                  |  2 ++
>  drivers/usb/host/ehci-ppc-of.c                   |  2 ++
>  drivers/usb/host/ohci-ppc-of.c                   |  2 ++
>  fs/proc/proc_devtree.c                           |  3 --
>  include/linux/of.h                               | 13 ++++----
>  include/linux/of_address.h                       | 39 +++++++++++++-----------
>  sound/aoa/core/gpio-feature.c                    |  3 +-
>  sound/aoa/soundbus/i2sbus/core.c                 |  2 ++
>  sound/ppc/pmac.c                                 |  2 ++
>  sound/ppc/tumbler.c                              |  1 +
>  90 files changed, 141 insertions(+), 220 deletions(-)
>  delete mode 100644 arch/arc/include/asm/prom.h
>  delete mode 100644 arch/arm64/include/asm/prom.h
>  delete mode 100644 arch/c6x/include/asm/prom.h
>  delete mode 100644 arch/metag/include/asm/prom.h
>  delete mode 100644 arch/openrisc/include/asm/prom.h
>  delete mode 100644 arch/xtensa/include/asm/prom.h
> 
> -- 
> 1.8.1.2
> 

