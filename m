Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751049AbaIFFUs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 01:20:48 -0400
Received: from mail.kernel.org ([198.145.19.201]:47775 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbaIFFUq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 01:20:46 -0400
From: Kevin Hilman <khilman@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org
Subject: [GIT PULL] ARM: SoC: fixes for v3.17-rc4          
Date: Fri, 05 Sep 2014 22:20:43 -0700
Message-ID: <7hsik5wcic.fsf@paris.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

The following changes since commit 69e273c0b0a3c337a521d083374c918dc52c666f:

  Linux 3.17-rc3 (2014-08-31 18:23:04 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes-for-linus

for you to fetch changes up to 389710837f684b397ecea7e66a3a87f16e1542de:

  Merge tag 'at91-fixes' of git://github.com/at91linux/linux-at91 into fixes (2014-09-05 13:29:17 -0700)

----------------------------------------------------------------
ARM: SoC fixes for v3.17-rc4

Another round of fixes from arm-soc land, which are mostly DT fixes
for:

- OMAP: handful of DT fixes devices on newly supported hardware
- davinci: fix 2nd EDMA channel
- ux500: extend previous pinctrl fix to another board
- at91: clock registration fixes, compatibility string precision

And one more fix for event cleanup in drivers/bus/arm-ccn.

----------------------------------------------------------------
Alexandre Belloni (2):
      ARM: at91: rm9200: fix clock registration
      ARM: at91/dt: rm9200: fix usb clock definition

Arnd Bergmann (1):
      Merge tag 'davinci-fixes-for-v3.17-rc4' of git://git.kernel.org/.../nsekhar/linux-davinci into fixes

Felipe Balbi (1):
      ARM: dts: am4372: fix USB regs size

Gaël PORTAY (1):
      ARM: at91/dt: sam9g20: set at91sam9g20 pllb driver

Kevin Hilman (2):
      Merge tag 'omap-fixes-against-v3.17-rc3' of git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge tag 'at91-fixes' of git://github.com/at91linux/linux-at91 into fixes

Linus Walleij (1):
      ARM: ux500: disable msp2 node on Snowball

Lokesh Vutla (1):
      ARM: dts: dra7-evm: Add vtt regulator support

Nishanth Menon (2):
      ARM: dts: am437x-gp: switch i2c0 to 100KHz
      ARM: dts: dra7-evm: Fix spi1 mux documentation

Pawel Moll (1):
      bus: arm-ccn: Move event cleanup routine

Peter Ujfalusi (1):
      ARM: edma: Fix configuration parsing for SoCs with multiple eDMA3 CC

Roger Quadros (8):
      ARM: dts: dra7-evm: Fix i2c3 pinmux and frequency
      ARM: dts: dra7-evm: Fix 8th NAND partition's name
      ARM: dts: am43x-epos-evm: Use BCH16 ECC scheme instead of BCH8
      ARM: dts: am437x-gp-evm: Use BCH16 ECC scheme instead of BCH8
      ARM: dts: am437x-gp-evm: Don't use read/write wait monitoring
      ARM: dts: am43xx-epos-evm: Don't use read/write wait monitoring
      ARM: OMAP2+: gpmc: Don't complain if wait pin is used without r/w monitoring
      ARM: dts: am43x-epos-evm: Disable QSPI to prevent conflict with GPMC-NAND

Stefan Herbrechtsmeier (1):
      ARM: dts: set 'ti,set-rate-parent' for dpll4_m5x2 clock

Tony Lindgren (1):
      Merge branch 'for-v3.17-rc/ti-clk-dt' of github.com:t-kristo/linux-pm into fixes-rc3

 arch/arm/boot/dts/am4372.dtsi          |  4 ++--
 arch/arm/boot/dts/am437x-gp-evm.dts    |  6 ++----
 arch/arm/boot/dts/am43x-epos-evm.dts   |  9 ++++-----
 arch/arm/boot/dts/at91rm9200.dtsi      |  2 +-
 arch/arm/boot/dts/at91sam9g20.dtsi     |  1 +
 arch/arm/boot/dts/dra7-evm.dts         | 47 ++++++++++++++++++++++++++++++++++++-----------
 arch/arm/boot/dts/omap3xxx-clocks.dtsi |  1 +
 arch/arm/boot/dts/ste-snowball.dts     |  1 -
 arch/arm/common/edma.c                 |  9 +++++----
 arch/arm/mach-at91/board-dt-rm9200.c   | 11 ++++++++++-
 arch/arm/mach-omap2/gpmc.c             |  7 +++----
 drivers/bus/arm-ccn.c                  | 51 +++++++++++++++++++++++++--------------------------
 12 files changed, 90 insertions(+), 59 deletions(-)
