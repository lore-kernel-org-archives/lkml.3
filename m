Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab3AWKif (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 05:38:35 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:41907 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554Ab3AWKic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 05:38:32 -0500
From: Roger Quadros <rogerq@ti.com>
To: <sameo@linux.intel.com>
CC: <balbi@ti.com>, <tony@atomide.com>, <kishon@ti.com>,
        <sshtylyov@mvista.com>, <bjorn@mork.no>, <linux@arm.linux.org.uk>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <rogerq@ti.com>
Subject: [PATCH v9 00/20] OMAP USB Host cleanup
Date: Wed, 23 Jan 2013 12:37:52 +0200
Message-ID: <1358937492-8129-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

I think this series is in a pretty good shape to pull now :). I've added
Reviewed-by and Acked-by tags. You can please pull from below.

NOTE: the first patch is a stable fix so Greg KH might want to pick it up for 3.8-rc.

The following changes since commit 7d1f9aeff1ee4a20b1aeb377dd0f579fe9647619:

  Linux 3.8-rc4 (2013-01-17 19:25:45 -0800)

are available in the git repository at:
  git://github.com/rogerq/linux.git linux-usbhost14-part

This patchset addresses the following

- Consolidate USB Host platform data.
- Avoid addressing clocks one by one by name and use a for loop + bunch
  of cleanups.
- Get number of channels/ports dynamically either from revision register
  or from platform data. Avoids getting clocks that are not present.
- Add OMAP5 and HSIC mode (Not tested).

v9:
- Addressed clock framework related comments from Russell King.
- Removed 2 clock data patches from the series as they will be taken care
  of by Paul Walmsey.

v8:
- Re-arranged patch "USB-ehci-omap-Don-t-free-gpios-that-we-didn-t-reques.patch"
  to be the first since it is a candidate for stable.
- Fixed issues raised by Felipe, i.e. indentation and use of switch ()

v7:
- Updated patch 4 to not hold a spinlock when using clk_get().
- Updated patches 3 and 11 to return -EADDRNOTAVAIL on failure of
  demv_request_and_ioremap().

v6:
- Added USB Host platform data consolidation patch as the first patch.
  based on request from Tony.
- Rebased on v3.8-rc3.

v5:
- Rebased on top of todays arm-soc/for-next.
- Removed the clock merging patch from the list.
- Updated patches 14, 19 and 20 to accomodate the above change.
- Added patch 22 to fix a build warning.

v4:
- Added appropriate maintainers in to/cc.
- minor print message fix in patch 23 to maintain consistency.

v3:
- Rebased on arm-soc/for-next commit f979306c4d38d213c6977aaf3b1115e8ded71e3a.
- Rearranged patch that get rids of cpu_is_omap..() macros.
- Coding style fixes.

v2:
- Clocks are allocated dynamically based on number of ports available
  on the platform.
- Reduced console spam if non critical clocks are not found on the platform.
- Get rid of cpu_is_.. macros from USB host driver.

cheers,
-roger

---
Roger Quadros (20):
      USB: ehci-omap: Don't free gpios that we didn't request
      mfd: omap-usb-host: Consolidate OMAP USB-HS platform data
      mfd: omap-usb-tll: Fix channel count detection
      mfd: omap-usb-tll: Use devm_kzalloc/ioremap and clean up error path
      mfd: omap-usb-tll: Clean up clock handling
      mfd: omap-usb-tll: introduce and use mode_needs_tll()
      mfd: omap-usb-tll: Check for missing platform data in probe
      mfd: omap-usb-tll: Fix error message
      mfd: omap-usb-tll: serialize access to TLL device
      mfd: omap-usb-tll: Add OMAP5 revision and HSIC support
      mfd: omap_usb_host: Avoid missing platform data checks in suspend/resume
      mfd: omap-usb-host: Use devm_kzalloc() and devm_request_and_ioremap()
      mfd: omap-usb-host: know about number of ports from revision register
      mfd: omap-usb-host: override number of ports from platform data
      mfd: omap-usb-host: cleanup clock management code
      mfd: omap-usb-host: Manage HSIC clocks for HSIC mode
      mfd: omap-usb-host: Get rid of unnecessary spinlock
      mfd: omap-usb-host: clean up omap_usbhs_init()
      mfd: omap-usb-host: Don't spam console on clk_set_parent failure
      mdf: omap-usb-host: get rid of build warning

 arch/arm/mach-omap2/board-3430sdp.c        |    2 +-
 arch/arm/mach-omap2/board-3630sdp.c        |    2 +-
 arch/arm/mach-omap2/board-am3517crane.c    |    2 +-
 arch/arm/mach-omap2/board-am3517evm.c      |    2 +-
 arch/arm/mach-omap2/board-cm-t35.c         |    2 +-
 arch/arm/mach-omap2/board-cm-t3517.c       |    2 +-
 arch/arm/mach-omap2/board-devkit8000.c     |    2 +-
 arch/arm/mach-omap2/board-igep0020.c       |    4 +-
 arch/arm/mach-omap2/board-omap3beagle.c    |    2 +-
 arch/arm/mach-omap2/board-omap3evm.c       |    2 +-
 arch/arm/mach-omap2/board-omap3pandora.c   |    2 +-
 arch/arm/mach-omap2/board-omap3stalker.c   |    2 +-
 arch/arm/mach-omap2/board-omap3touchbook.c |    2 +-
 arch/arm/mach-omap2/board-omap4panda.c     |    2 +-
 arch/arm/mach-omap2/board-overo.c          |    2 +-
 arch/arm/mach-omap2/board-zoom.c           |    2 +-
 arch/arm/mach-omap2/usb-host.c             |   29 +--
 arch/arm/mach-omap2/usb.h                  |   20 +-
 drivers/mfd/omap-usb-host.c                |  558 +++++++++++++++++-----------
 drivers/mfd/omap-usb-tll.c                 |  243 +++++++------
 drivers/usb/host/ehci-omap.c               |   14 +-
 include/linux/platform_data/usb-omap.h     |   24 +-
 22 files changed, 497 insertions(+), 425 deletions(-)

-- 
1.7.4.1

