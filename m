Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbaGSFtF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 01:49:05 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:54781 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348AbaGSFtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 01:49:03 -0400
Date: Fri, 18 Jul 2014 22:49:27 -0700
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: olof@lixom.net, arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] ARM: SoC fixes for 3.16-rc
Message-ID: <20140719054927.GA31580@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

The following changes since commit cacadb4ff969a82628d47db87b5a531be466b134:

  Merge tag 'samsung-fixes-3' of git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung into fixes (2014-07-12 21:19:21 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to 9637f30e6b7bc394c08fa9d27d63622f141142e9:

  ARM: EXYNOS: Fix core ID used by platsmp and hotplug code (2014-07-18 17:12:57 -0700)

----------------------------------------------------------------
ARM: SoC fixes for 3.16-rc

A smaller set of fixes this week, and all regression fixes:
 - a handful of issues fixed on at91 with common clock conversion
 - a set of fixes for Marvell mvebu (SMP, coherency, PM)
 - a clock fix for i.MX6Q.
 - ... and a SMP/hotplug fix for Exynos

----------------------------------------------------------------
Bo Shen (1):
      ARM: at91: at91sam9x5: correct typo error for ohci clock

Boris BREZILLON (2):
      ARM: at91/dt: fix usb0 clocks definition in sam9n12 dtsi
      ARM: at91/dt: add missing clocks property to pwm node in sam9x5.dtsi

Ezequiel Garcia (1):
      ARM: mvebu: Fix coherency bus notifiers by using separate notifiers

Gregory CLEMENT (1):
      ARM: mvebu: Fix the operand list in the inline asm of armada_370_xp_pmsu_idle_enter

Lucas Stach (1):
      ARM: clk-imx6q: parent lvds_sel input from upstream clock gates

Olof Johansson (3):
      Merge tag 'mvebu-fixes-3.16-3' of git://git.infradead.org/linux-mvebu into fixes
      Merge tag 'at91-fixes' of git://github.com/at91linux/linux-at91 into fixes
      Merge tag 'imx-fixes-3.16-2' of git://git.kernel.org/.../shawnguo/linux into fixes

Thomas Petazzoni (1):
      ARM: mvebu: fix SMP boot for Armada 38x and Armada 375 Z1 in big endian

Tomasz Figa (1):
      ARM: EXYNOS: Fix core ID used by platsmp and hotplug code

 arch/arm/boot/dts/at91sam9n12.dtsi |  2 +-
 arch/arm/boot/dts/at91sam9x5.dtsi  |  4 ++--
 arch/arm/mach-exynos/hotplug.c     | 10 ++++++----
 arch/arm/mach-exynos/platsmp.c     | 34 +++++++++++++++++++---------------
 arch/arm/mach-imx/clk-imx6q.c      |  4 ++--
 arch/arm/mach-mvebu/coherency.c    |  6 +++++-
 arch/arm/mach-mvebu/headsmp-a9.S   |  9 ++++++++-
 arch/arm/mach-mvebu/pmsu.c         | 10 +++++-----
 8 files changed, 48 insertions(+), 31 deletions(-)
