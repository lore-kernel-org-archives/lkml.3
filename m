Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936275Ab3DKPSc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 11:18:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51610 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab3DKPSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 11:18:30 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] arm-soc fixes for 3.9-rc6
Date: Thu, 11 Apr 2013 17:18:12 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, arm@kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304111718.13017.arnd@arndb.de>
X-Provags-ID: V02:K0:ySGFOZFokoaX7jtM5XurUvzCKZhr9PWpx6HbEY934lX
 a1hTQLkg4N6/sacqO1hAsBMPgnQCWliNXmk/raqzKgNqRKWT3f
 8GXUD8fzaokJ/bNQJ2OHukMqSLLmcoDAG3N8W0A/2UpvKJG6an
 D4uZqEiQFaudncdVVftBv0tkDD2+Xr5DYYGTPV5sWWX4mBfFuR
 VMGx9RlGTFlHDTWufY8ap7ii3jM48V3l/cpQXIz77OSYMetW11
 ph1CLLKYVmBUCWH77YgSUbuQvhHY1P1Lyro31l1zJyJol3ZwSr
 q71SR9T7JkSbmJQFd33L94sGtUsPiwxEtutV2b5uq5esbmKR5U
 vI74rRzIDIVV1c0dI6Rs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A little later during the week than the last few pull requests, since there
was very little that came in before 3.9-rc6. At least things have calmed
down again here.

	Arnd

The following changes since commit 31880c37c11e28cb81c70757e38392b42e695dc6:

  Linux 3.9-rc6 (2013-04-07 20:49:54 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/arm-soc-fixes

for you to fetch changes up to 71bd98aff05a644a2cfc3ac6ca848a586fa210b9:

  Merge tag 'mvebu_fixes_for_v3.9_round3' of git://git.infradead.org/users/jcooper/linux into fixes (2013-04-11 16:55:29 +0200)

----------------------------------------------------------------

arm-soc: bug fixes for 3.9-rc6

Some important bug fixes that came in over the last 10 days,
mostly mvebu and imx:

- Multiple regressions on i.mx following the conversion of
  the clock code, hopefully the last we are seeing of those.
- a regression in the mvebu irq handling code
- An incorrect register offset in the rewritten s3c24xx irq code.
- Two bugs in setting up the iomega_ix2_200 machine
- Turning on an extra bus clock on imx
- A MAINTAINERS file entry for Roland Stigge

----------------------------------------------------------------
Arnd Bergmann (4):
      Merge tag 'mxs-fixes-3.9-4' of git://git.linaro.org/people/shawnguo/linux-2.6 into fixes
      Merge tag 'imx-fixes-3.9-5' of git://git.linaro.org/people/shawnguo/linux-2.6 into fixes
      Merge tag 'samsung-fixes-for-v3.9' of git://git.kernel.org/.../kgene/linux-samsung into fixes
      Merge tag 'mvebu_fixes_for_v3.9_round3' of git://git.infradead.org/users/jcooper/linux into fixes

Dirk Behme (1):
      ARM i.MX6: Fix ldb_di clock selection

Gregory CLEMENT (1):
      arm: mvebu: Fix the irq map function in SMP mode

Marek Vasut (1):
      ARM: mxs: Slow down the I2C clock speed

Markus Pargmann (2):
      ARM: clk-imx35: Bugfix iomux clock
      ARM: imx35 Bugfix admux clock

Nigel Roberts (2):
      ARM: Kirkwood: Fix typo in the definition of ix2-200 rebuild LED
      Fix GE0/GE1 init on ix2-200 as GE0 has no PHY

Roland Stigge (1):
      MAINTAINERS: Add maintainer for LPC32xx

Shawn Guo (1):
      ARM: imx: provide twd clock lookup from device tree

Sylwester Nawrocki (2):
      ARM: S3C24XX: Correct NR_IRQS definition for s3c2440
      ARM: S3C24XX: Fix interrupt pending register offset of the EINT controller

 MAINTAINERS                                   |  6 ++++++
 arch/arm/boot/dts/imx28-m28evk.dts            |  1 -
 arch/arm/boot/dts/imx28-sps1.dts              |  1 -
 arch/arm/boot/dts/imx6qdl.dtsi                |  1 +
 arch/arm/boot/dts/kirkwood-iomega_ix2_200.dts | 14 +++++++-------
 arch/arm/mach-imx/clk-imx35.c                 |  2 ++
 arch/arm/mach-imx/clk-imx6q.c                 |  3 +--
 arch/arm/mach-kirkwood/board-iomega_ix2_200.c |  7 ++++++-
 arch/arm/mach-mvebu/irq-armada-370-xp.c       | 16 +++++-----------
 arch/arm/mach-s3c24xx/include/mach/irqs.h     |  4 +---
 arch/arm/mach-s3c24xx/irq.c                   |  2 +-
 11 files changed, 30 insertions(+), 27 deletions(-)
