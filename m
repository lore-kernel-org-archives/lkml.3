Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587Ab3G3NFc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 09:05:32 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:46311 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601Ab3G3NF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 09:05:27 -0400
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>, <tony@atomide.com>, <nsekhar@ti.com>
CC: <coelho@ti.com>, <luca@coelho.fi>, <mturquette@linaro.org>,
        <mark.rutland@arm.com>, <balbi@ti.com>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <nm@ti.com>, <martinez.javier@gmail.com>
Subject: [PATCH v4 0/8] wilink: add device tree support
Date: Tue, 30 Jul 2013 16:04:28 +0300
Message-ID: <1375189476-21557-1-git-send-email-coelho@ti.com>
X-Mailer: git-send-email 1.8.3.2
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

Regarding the XTAL clock issues, for now we don't support XTAL mode
with DT, but I have sent a proposal for a small change in the clock
framework to support this, but it's still under discussions [1].

The DTS file changes will be sent separately, since they need to go
via different trees.

A new version of the bindings documentation has been sent [2] and, if
no more comments are given to it, I'll apply it via my tree.

[1] http://news.gmane.org/find-root.php?message_id=1372971912-10877-1-git-send-email-coelho@ti.com
[2] http://news.gmane.org/find-root.php?message_id=1375109728-5931-1-git-send-email-coelho@ti.com

Changes in v4:

* Rebased on top of 3.11-rc3 (eg. no more changes on the board files
  that were removed);

* Use the new irq_get_trigger_type() instead of
  irqd_get_trigger_type() (thanks Javier);

* Added some missing const's (thanks Felipe);

* Reverted Tony's workaround to get WiLink to work on Panda while DT
  was not supported yet.


Please review.


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

 arch/arm/mach-davinci/board-da850-evm.c        |  11 ++-
 arch/arm/mach-omap2/board-omap3evm.c           |  22 ++++-
 arch/arm/mach-omap2/board-omap3pandora.c       |   4 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c   |   2 +-
 arch/arm/mach-omap2/board-zoom-peripherals.c   |  33 +++++++-
 arch/arm/mach-omap2/devices.c                  |  39 ---------
 drivers/net/wireless/ti/wilink_platform_data.c |  37 ++++++--
 drivers/net/wireless/ti/wl1251/sdio.c          |  12 +--
 drivers/net/wireless/ti/wl1251/spi.c           |   2 +-
 drivers/net/wireless/ti/wl12xx/main.c          |  78 +++++++++++++++--
 drivers/net/wireless/ti/wl12xx/wl12xx.h        |  28 +++++++
 drivers/net/wireless/ti/wlcore/debugfs.c       |   2 +-
 drivers/net/wireless/ti/wlcore/main.c          |  20 ++---
 drivers/net/wireless/ti/wlcore/sdio.c          | 112 +++++++++++++++++++++++--
 drivers/net/wireless/ti/wlcore/wlcore.h        |   5 +-
 drivers/net/wireless/ti/wlcore/wlcore_i.h      |   1 +
 include/linux/wl12xx.h                         |  52 +++++-------
 17 files changed, 340 insertions(+), 120 deletions(-)

-- 
1.8.3.2

