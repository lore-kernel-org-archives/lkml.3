Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610Ab3BRG3F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 01:29:05 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:56183 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013Ab3BRG3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 01:29:03 -0500
From: Afzal Mohammed <afzal@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Russell King <linux@arm.linux.org.uk>, Tony Lindgren <tony@atomide.com>,
        Marc Zyngier <marc.zyngier@arm.com>, Nicolas Pitre <nico@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Will Deacon <will.deacon@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, Sekhar Nori <nsekhar@ti.com>,
        Syed Mohammed Khasim <khasim@ti.com>
Subject: [RFC 0/8] ARM: AM43 (OMAP2+) boot support
Date: Mon, 18 Feb 2013 11:58:22 +0530
Message-ID: <cover.1361166003.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.12
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series adds minimal support to boot Linux on platforms having
AM43 based SoC's.

This is being sent as an RFC to seek opinion about modification in
twd to register percpu local timer clock event for scheduler tick in
the case of one core SMP.

AM43 SoC's are based on ARM Cortex-A9. It is an ARM Cortex-A9 SMP
configuration with one core (not uniprocessor configuration). AM43 is
similar to AM335x in it's peripheral capabilities, with many of the
peripheral register mapping's similar like that of uart.

AM43 is in pre-silicon stage and currently there are no public
documents.

This series has been tested on a pre-silicon platform that emulates
AM43 SoC, changes proposed here are minimal - to get it booting.
Kernel was directly run without the help of bootloader - Images were
directly loaded onto a pre-initialized RAM and ARM registers updated
as required for booting.

Changes have been made over linux-next (next-20130213) with three "OF"
related reverts (which otherwise causes problem in other platforms
also) and compiled with omap2plus_defconfig. Multiplatform option was
enabled, while most of CONFIG options were deselected for a faster
boot. Beagle bone boots as earlier with these changes.

An interesting observation is that it may be possible to boot this
platform to console without any platform specific modification to
proper Kernel (by that I mean excluding DT sources) using Arnd's,

"[PATCH,RFC] default machine descriptor for multiplatform",

along with a "CLOCKSOURCE_OF_DECLARE" for smp twd.

But later on to make SoC do any really useful work or to get done
things that the SoC is meant to do, platform changes like omap-hwmod,
handling power management, clock tree, detecting SoC capabilities etc
would have to be made, necessitating DT_MACHINE_START at least in
the foreseeable future.

Patch - 8 that makes AM43 boot on pre-silicon platform would be
replaced later by a one for original board.

Last but not least, thanks to Ankur Kishore <a-kishore@ti.com>
(who first made Linux to boot on AM43) for all the help that made
Linux bringup easier.

Regards
Afzal

Afzal Mohammed (8):
  ARM: localtimer: return percpu clkevt on register
  ARM: twd: register clock event for 1 core SMP
  ARM: twd: clock rate from DT (if no DT clk tree)
  ARM: am33xx: ll debug config help
  ARM: OMAP2+: am43: Kconfig
  ARM: OMAP2+: am43: basic dt support
  ARM: dts: am4372: initial support
  ARM: dts: am43-pre-silicon support

 Documentation/devicetree/bindings/arm/twd.txt |  7 +++-
 arch/arm/Kconfig.debug                        |  3 ++
 arch/arm/boot/dts/Makefile                    |  3 +-
 arch/arm/boot/dts/am43-pre-silicon.dts        | 31 +++++++++++++++
 arch/arm/boot/dts/am4372.dtsi                 | 55 +++++++++++++++++++++++++++
 arch/arm/include/asm/localtimer.h             |  7 ++--
 arch/arm/kernel/smp.c                         |  8 ++--
 arch/arm/kernel/smp_twd.c                     | 16 +++++++-
 arch/arm/mach-omap2/Kconfig                   | 11 ++++++
 arch/arm/mach-omap2/board-generic.c           | 18 +++++++++
 10 files changed, 148 insertions(+), 11 deletions(-)
 create mode 100644 arch/arm/boot/dts/am43-pre-silicon.dts
 create mode 100644 arch/arm/boot/dts/am4372.dtsi

-- 
1.7.12

