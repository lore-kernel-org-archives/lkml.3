Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758281Ab3GZJEU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 05:04:20 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:43426 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756162Ab3GZJER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 05:04:17 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <balbi@ti.com>, <tony@atomide.com>
CC: <kishon@ti.com>, <linux@arm.linux.org.uk>, <eballetbo@gmail.com>,
        <javier@dowhile0.org>, <gregkh@linuxfoundation.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: [PATCH 0/2] usb: fix controller-PHY binding for OMAP3 platform
Date: Fri, 26 Jul 2013 14:33:36 +0530
Message-ID: <1374829418-27503-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After the platform devices are created using PLATFORM_DEVID_AUTO, the
device names given in usb_bind_phy (in board file) does not match with
the actual device name causing the USB PHY library not to return the
PHY reference when the MUSB controller request for the PHY in the non-dt boot
case.
So removed creating platform devices using PLATFORM_DEVID_AUTO in omap2430.c.
This is also needed for the Generic PHY Framework [1] after it's redesigned
to address Greg's concerns [2]

*usb: musb: fix USB enumeration issue in OMAP3 platform* can be dropped since
this patch series should fix the same issue.

I've tested in beagle, but if any of you have any other OMAP3 boards, would be
great if you can test it too.

[1] -> https://git.kernel.org/cgit/linux/kernel/git/kishon/linux-phy.git/
[2] -> http://thread.gmane.org/gmane.linux.ports.arm.kernel/252813/focus=101661

Kishon Vijay Abraham I (2):
  usb: musb: omap: remove using PLATFORM_DEVID_AUTO in omap2430.c
  arm: omap: remove *.auto* from device names given in usb_bind_phy

 arch/arm/mach-omap2/board-2430sdp.c          |    2 +-
 arch/arm/mach-omap2/board-3430sdp.c          |    2 +-
 arch/arm/mach-omap2/board-cm-t35.c           |    2 +-
 arch/arm/mach-omap2/board-devkit8000.c       |    2 +-
 arch/arm/mach-omap2/board-igep0020.c         |    2 +-
 arch/arm/mach-omap2/board-ldp.c              |    2 +-
 arch/arm/mach-omap2/board-omap3beagle.c      |    2 +-
 arch/arm/mach-omap2/board-omap3evm.c         |    2 +-
 arch/arm/mach-omap2/board-omap3logic.c       |    2 +-
 arch/arm/mach-omap2/board-omap3pandora.c     |    2 +-
 arch/arm/mach-omap2/board-omap3stalker.c     |    2 +-
 arch/arm/mach-omap2/board-omap3touchbook.c   |    2 +-
 arch/arm/mach-omap2/board-overo.c            |    2 +-
 arch/arm/mach-omap2/board-rm680.c            |    2 +-
 arch/arm/mach-omap2/board-rx51.c             |    2 +-
 arch/arm/mach-omap2/board-zoom-peripherals.c |    2 +-
 drivers/usb/musb/musb_core.c                 |   31 +++++++++++++++++++++++++-
 drivers/usb/musb/musb_core.h                 |    2 ++
 drivers/usb/musb/omap2430.c                  |   16 +++++++++++--
 19 files changed, 62 insertions(+), 19 deletions(-)

-- 
1.7.10.4

