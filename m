Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668AbaK1Nmy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 08:42:54 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:50988 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbaK1Nmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 08:42:52 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: ARM: SoC fixes for 3.18-rc7
Date: Fri, 28 Nov 2014 14:42:34 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: olof@lixom.net, arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201411281442.35201.arnd@arndb.de>
X-Provags-ID: V02:K0:fzsoWwXbnK4OW3elMUbcw7iofhayZ8bjddnk3R8AQBb
 JMWmFBoEtiSQCUGwK62PRBlQnPLlFfPoCQD4o5YYODB9QL/0E0
 UTNNDHNMVeANxNAPTNJqT36rLQtjy5v7AC3ltxr9C4oMOlDYxx
 P5wTc0KUsQ5ABgELG65urcGhgFFUjJcqCWpAJ/V+R0vWUgMxma
 wXc6WZbhfhwG5cUndJ/3+qcXhvly2FMU4Kmm2epGJBuEk2DfB7
 T1hmUXJhB7Xeq2YYPy+zZChTsyn9wfMqsGDUtiXkqofZg4bFKY
 RgHp/1HmA9nMqzqtLpbTQDIBE4MCCcsGpjhebRWlyxPicXjl2p
 9UKdOnhzDXWK6mPray6wjDJbeE23oN7Zvw2wJm1gk
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Not much interesting going on fixes-wise for us this week, as it should be
for an -rc7. I'm not expecting Olof to work much over Thanksgiving weekend,
so I decided to take over again and push these out to you.

	Arnd

The following changes since commit 5d01410fe4d92081f349b013a2e7a95429e4f2c9:

  Linux 3.18-rc6 (2014-11-23 15:25:20 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc tags/armsoc-for-rc7

for you to fetch changes up to 96ba18ffd09cc063b8d1ddc8c6cafea6177c8259:

  Merge tag 'mvebu-fixes-3.18-2' of git://git.infradead.org/linux-mvebu into fixes (2014-11-27 14:29:23 +0100)

----------------------------------------------------------------
ARM: SoC fixes for 3.18-rc7

Just four simple fixes this week:

- one missing of_node_put() on armv7 based mvebu
- forcing the USB host into the right mode on Chromebook (exynos5-snow)
- enabling two important drivers for exynos_defconfig
- fixing a noncritical bug for tegra that would cause a
  regression with common code patches queued for 3.19

----------------------------------------------------------------
Arnd Bergmann (3):
      Merge tag 'samsung-fixes-v3.18' of git://git.kernel.org/.../kgene/linux-samsung into fixes
      Merge tag 'samsung-defconfig-v3.18' of git://git.kernel.org/.../kgene/linux-samsung into fixes
      Merge tag 'mvebu-fixes-3.18-2' of git://git.infradead.org/linux-mvebu into fixes

Javier Martinez Canillas (1):
      ARM: exynos_defconfig: Enable max77802 rtc and clock drivers

Marc Zyngier (1):
      ARM: tegra: irq: fix buggy usage of irq_data irq field

Sjoerd Simons (1):
      ARM: dts: Explicitly set dr_mode on exynos5250-snow

Thomas Petazzoni (1):
      ARM: mvebu: add missing of_node_put() call in coherency.c

 arch/arm/boot/dts/exynos5250-snow.dts |  4 ++++
 arch/arm/boot/dts/exynos5250.dtsi     |  2 +-
 arch/arm/configs/exynos_defconfig     |  2 ++
 arch/arm/mach-mvebu/coherency.c       |  2 ++
 arch/arm/mach-tegra/irq.c             | 22 +++++++++++-----------
 5 files changed, 20 insertions(+), 12 deletions(-)
