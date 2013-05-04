Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758861Ab3EDHq7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 03:46:59 -0400
Received: from mail-da0-f53.google.com ([209.85.210.53]:52342 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756859Ab3EDHq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 03:46:28 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 3/4] ARM: platform specific firmware interfaces for 3.10
Date: Sat,  4 May 2013 00:42:47 -0700
Message-Id: <1367653368-25291-4-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.1.192.gc4361b8
In-Reply-To: <1367653368-25291-1-git-send-email-olof@lixom.net>
References: <1367653368-25291-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two platforms, bcm and exynos have their own firmware interfaces using
the "secure monitor call", this adds support for those.

We had originally planned to have a third set of patches in here, which
would extend support for the existing generic "psci" call that is used
on multiple platforms as well as Xen and KVM guests, but that ended up
getting dropped because the patches were not ready in time.


Conflicts:

None

----------------------------------------------------------------

The following changes since commit c47ceb86748d75280ab478ac0bb76150cde90b7a:

  Merge branch 'next/renesas-pinctrl' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/firmware-for-linus

for you to fetch changes up to 721e0205b07589223343737a9c421d8118d87bba:

  ARM: bcm: mark bcm_kona_smc_init as __init

----------------------------------------------------------------

Arnd Bergmann (3):
      Merge branch 'exynos/clk' into next/firmware
      Merge tag 'secure-exynos-for-v3.10' of git://git.kernel.org/.../kgene/linux-samsung into next/firmware
      ARM: bcm: mark bcm_kona_smc_init as __init

Christian Daudt (2):
      ARM: bcm281xx: Add L2 cache enable code
      ARM: bcm281xx: Add DT support for SMC handler

Olof Johansson (1):
      Merge tag 'fw-for-3.10' of git://github.com/broadcom/bcm11351 into next/firmware

Tomasz Figa (5):
      ARM: Add interface for registering and calling firmware-specific operations
      ARM: EXYNOS: Add support for secure monitor calls
      ARM: EXYNOS: Add support for Exynos secure firmware
      ARM: EXYNOS: Add IO mapping for non-secure SYSRAM.
      ARM: EXYNOS: Add secure firmware support to secondary CPU bring-up


 Documentation/arm/firmware.txt                  |  88 ++++++++++++++
 .../devicetree/bindings/arm/samsung-boards.txt  |  10 ++
 Documentation/devicetree/bindings/misc/smc.txt  |  14 +++
 arch/arm/boot/dts/bcm11351.dtsi                 |   5 +
 arch/arm/common/Makefile                        |   2 +
 arch/arm/common/firmware.c                      |  18 +++
 arch/arm/include/asm/firmware.h                 |  66 +++++++++++
 arch/arm/mach-bcm/Makefile                      |   4 +-
 arch/arm/mach-bcm/bcm_kona_smc.c                | 118 +++++++++++++++++++
 arch/arm/mach-bcm/bcm_kona_smc.h                |  80 +++++++++++++
 arch/arm/mach-bcm/bcm_kona_smc_asm.S            |  41 +++++++
 arch/arm/mach-bcm/board_bcm.c                   |  23 ++++
 arch/arm/mach-exynos/Makefile                   |   6 +
 arch/arm/mach-exynos/common.c                   |  35 ++++++
 arch/arm/mach-exynos/common.h                   |   2 +
 arch/arm/mach-exynos/exynos-smc.S               |  22 ++++
 arch/arm/mach-exynos/firmware.c                 |  70 +++++++++++
 arch/arm/mach-exynos/include/mach/map.h         |   3 +
 arch/arm/mach-exynos/mach-exynos4-dt.c          |   1 +
 arch/arm/mach-exynos/platsmp.c                  |  32 ++++-
 arch/arm/mach-exynos/smc.h                      |  31 +++++
 arch/arm/plat-samsung/include/plat/map-s5p.h    |   1 +
 22 files changed, 666 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/arm/firmware.txt
 create mode 100644 Documentation/devicetree/bindings/misc/smc.txt
 create mode 100644 arch/arm/common/firmware.c
 create mode 100644 arch/arm/include/asm/firmware.h
 create mode 100644 arch/arm/mach-bcm/bcm_kona_smc.c
 create mode 100644 arch/arm/mach-bcm/bcm_kona_smc.h
 create mode 100644 arch/arm/mach-bcm/bcm_kona_smc_asm.S
 create mode 100644 arch/arm/mach-exynos/exynos-smc.S
 create mode 100644 arch/arm/mach-exynos/firmware.c
 create mode 100644 arch/arm/mach-exynos/smc.h
