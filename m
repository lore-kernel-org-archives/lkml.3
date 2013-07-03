Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932869Ab3GCOEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 10:04:20 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49910 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932075Ab3GCOEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 10:04:15 -0400
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>, <tony@atomide.com>, <nsekhar@ti.com>
CC: <mturquette@linaro.org>, <mark.rutland@arm.com>, <balbi@ti.com>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <coelho@ti.com>, <nm@ti.com>
Subject: [PATCH v3 0/8] wilink: add device tree support
Date: Wed, 3 Jul 2013 17:03:21 +0300
Message-ID: <1372860209-3504-1-git-send-email-coelho@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series adds device tree support to the wlcore_sdio driver,
which is used by WiLink6, WiLink7 and WiLink8.

The first patches do some clean-up to make the data needed in the
wilink device tree node smaller.  The remaining patches implement the
actual device tree node parsing in wlcore_sdio.

I still need to figure out how to add the information about whether
the clocks are XTAL or not.  I'll send it in a separate patche set.

The DTS file changes will be sent separately, since they need to go
via different trees.

The bindings documentation patch will also be updated and sent
separately, once the XTAL issue is solved.


Changes in v3:

* Remove irq_flags from pdata and handle them in the board files.
  This caused the "wlcore: use irq_flags in pdata instead of hiding it
  behind a quirk" (now 2/8) to be changed considerably, so I removed
  the Acked-by from Tony.  I also added calls to gpio_request_one()
  for the WiLink IRQ GPIO that were missing in the board files (thanks
  Felipe);

* Added "const" to the frequency tables in patch 4/8 (thanks Felipe);

* Squashed patch 5/9 into the new 2/8;

* Added comment about the sdio_set_drvdata() call move in 7/8 (thanks
  Felipe);

* I'm still modifying the panda and 4430sdp board files that are going
  to be removed in 3.11.  Please ignore the changes I made there, I
  just wanted to make sure they still work with my current tree.  Once
  the 3.11 merge window close, I'll do the relevant merges before I
  send pull requests (thanks Tony and Nishant).

Please review.

--
Cheers,
Luca.

Luciano Coelho (8):
  wl1251: split wl251 platform data to a separate structure
  wlcore: set irq_flags in the board files instead of hiding behind a
    quirk
  wlcore: remove pwr_in_suspend from platform data
  wl12xx: use frequency instead of enumerations for pdata clocks
  wlcore: add initial device tree support to the sdio module
  wlcore: sdio: add wilink clock providers
  wlcore: sdio: get clocks from device tree
  wlcore/wl12xx: check if we got correct clock data from DT

 arch/arm/mach-davinci/board-da850-evm.c        |   11 ++-
 arch/arm/mach-omap2/board-4430sdp.c            |   23 ++++-
 arch/arm/mach-omap2/board-omap3evm.c           |   22 ++++-
 arch/arm/mach-omap2/board-omap3pandora.c       |    4 +-
 arch/arm/mach-omap2/board-omap4panda.c         |   39 +++++++--
 arch/arm/mach-omap2/board-rx51-peripherals.c   |    2 +-
 arch/arm/mach-omap2/board-zoom-peripherals.c   |   33 ++++++-
 drivers/net/wireless/ti/wilink_platform_data.c |   37 ++++++--
 drivers/net/wireless/ti/wl1251/sdio.c          |   12 +--
 drivers/net/wireless/ti/wl1251/spi.c           |    2 +-
 drivers/net/wireless/ti/wl12xx/main.c          |   77 ++++++++++++++--
 drivers/net/wireless/ti/wl12xx/wl12xx.h        |   28 ++++++
 drivers/net/wireless/ti/wlcore/debugfs.c       |    2 +-
 drivers/net/wireless/ti/wlcore/main.c          |   26 +++---
 drivers/net/wireless/ti/wlcore/sdio.c          |  112 ++++++++++++++++++++++--
 drivers/net/wireless/ti/wlcore/wlcore.h        |    5 +-
 drivers/net/wireless/ti/wlcore/wlcore_i.h      |    1 +
 include/linux/wl12xx.h                         |   52 +++++------
 18 files changed, 398 insertions(+), 90 deletions(-)

-- 
1.7.10.4

