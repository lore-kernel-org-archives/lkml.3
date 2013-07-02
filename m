Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab3GBO41 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 10:56:27 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43910 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522Ab3GBO4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 10:56:25 -0400
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>, <tony@atomide.com>, <nsekhar@ti.com>
CC: <mturquette@linaro.org>, <mark.rutland@arm.com>, <balbi@ti.com>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <coelho@ti.com>
Subject: [PATCH v2 0/9] wilink: add device tree support
Date: Tue, 2 Jul 2013 17:55:39 +0300
Message-ID: <1372776948-24840-1-git-send-email-coelho@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a follow-up on a previous patch set that had a smaller
audience.  This time, I added the lists and people who were involved
in the review of the bindings documentation, since most of my changes
in v2 are coming from discussions there.

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

Tony has acked some of the patches that touch OMAP areas.  I still
need one more ack to a new patch I added (wl12xx: use frequency
instead of enumerations for pdata clocks).

Sekhar, can you please check the patches that touch the davinci board
file and ack them?

Changes in v2:

* New clean-up patch (4/9);

* Patch 6/9 (previously patch 5/5) now doesn't add the clock parsing,
  since it became more complicated and I added separate patches for
  that;

* 3 new patches (from 7/9 till 9/9) to handle the clock reading in the
  device tree;

Please review.

--
Cheers,
Luca.

Luciano Coelho (9):
  wl1251: split wl251 platform data to a separate structure
  wlcore: use irq_flags in pdata instead of hiding it behind a quirk
  wlcore: remove pwr_in_suspend from platform data
  wl12xx: use frequency instead of enumerations for pdata clocks
  wlcore: always use one-shot IRQ
  wlcore: add initial device tree support to the sdio module
  wlcore: sdio: add wilink clock providers
  wlcore: sdio: get clocks from device tree
  wlcore/wl12xx: check if we got correct clock data from DT

 arch/arm/mach-davinci/board-da850-evm.c        |    5 +-
 arch/arm/mach-omap2/board-4430sdp.c            |    6 +-
 arch/arm/mach-omap2/board-omap3evm.c           |    4 +-
 arch/arm/mach-omap2/board-omap3pandora.c       |    4 +-
 arch/arm/mach-omap2/board-omap4panda.c         |    4 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c   |    2 +-
 arch/arm/mach-omap2/board-zoom-peripherals.c   |    4 +-
 drivers/net/wireless/ti/wilink_platform_data.c |   37 ++++++--
 drivers/net/wireless/ti/wl1251/sdio.c          |   12 +--
 drivers/net/wireless/ti/wl1251/spi.c           |    2 +-
 drivers/net/wireless/ti/wl12xx/main.c          |   78 +++++++++++++++--
 drivers/net/wireless/ti/wl12xx/wl12xx.h        |   28 ++++++
 drivers/net/wireless/ti/wlcore/debugfs.c       |    2 +-
 drivers/net/wireless/ti/wlcore/main.c          |   16 ++--
 drivers/net/wireless/ti/wlcore/sdio.c          |  112 ++++++++++++++++++++++--
 drivers/net/wireless/ti/wlcore/wlcore.h        |    5 +-
 drivers/net/wireless/ti/wlcore/wlcore_i.h      |    1 +
 include/linux/wl12xx.h                         |   54 ++++++------
 18 files changed, 295 insertions(+), 81 deletions(-)

-- 
1.7.10.4

