Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab3LPPy0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 10:54:26 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:36096 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978Ab3LPPyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 10:54:24 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <tony@atomide.com>, <balbi@ti.com>, <linux-kernel@vger.kernel.org>,
        <kishon@ti.com>, <marek.belisko@gmail.com>
CC: <linux@arm.linux.org.uk>, <gregkh@linuxfoundation.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <hns@goldelico.com>
Subject: [PATCH v3 0/2] usb: fix controller-PHY binding for OMAP3 platform
Date: Mon, 16 Dec 2013 21:23:43 +0530
Message-ID: <1387209225-11520-1-git-send-email-kishon@ti.com>
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

Did enumeration testing in omap3 beagle.

Changes from v2:
* Fixed the commit log

Changes from v1:
* refreshed to the latested mainline kernel
* added musb_put_id from omap2430 remove.

Kishon Vijay Abraham I (2):
  usb: musb: omap: remove using PLATFORM_DEVID_AUTO in omap2430.c
  arm: omap: remove *.auto* from device names given in usb_bind_phy

 arch/arm/mach-omap2/board-2430sdp.c        |    2 +-
 arch/arm/mach-omap2/board-3430sdp.c        |    2 +-
 arch/arm/mach-omap2/board-cm-t35.c         |    2 +-
 arch/arm/mach-omap2/board-devkit8000.c     |    2 +-
 arch/arm/mach-omap2/board-ldp.c            |    2 +-
 arch/arm/mach-omap2/board-omap3beagle.c    |    2 +-
 arch/arm/mach-omap2/board-omap3logic.c     |    2 +-
 arch/arm/mach-omap2/board-omap3pandora.c   |    2 +-
 arch/arm/mach-omap2/board-omap3stalker.c   |    2 +-
 arch/arm/mach-omap2/board-omap3touchbook.c |    2 +-
 arch/arm/mach-omap2/board-overo.c          |    2 +-
 arch/arm/mach-omap2/board-rx51.c           |    2 +-
 drivers/usb/musb/musb_core.c               |   31 +++++++++++++++++++++++++++-
 drivers/usb/musb/musb_core.h               |    2 ++
 drivers/usb/musb/omap2430.c                |   19 +++++++++++++++--
 15 files changed, 61 insertions(+), 15 deletions(-)

-- 
1.7.10.4

