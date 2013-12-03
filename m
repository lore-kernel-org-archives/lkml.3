Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab3LCO0q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:26:46 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:42223 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753443Ab3LCO0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:26:40 -0500
From: Roger Quadros <rogerq@ti.com>
To: <bcousson@baylibre.com>, <paul@pwsan.com>, <tony@atomide.com>
CC: <tomi.valkeinen@ti.com>, <balbi@ti.com>, <sr@denx.de>,
        <David.Laight@ACULAB.COM>, <michael@amarulasolutions.com>,
        <bigeasy@linutronix.de>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>
Subject: [PATCH v2 0/3] ARM: OMAP2+: USB Host bug fixes for 3.13 rc
Date: Tue, 3 Dec 2013 16:25:45 +0200
Message-ID: <1386080748-17005-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a follow up solution to the original series in [1]

The first patch fixes the OMAP4 Panda USB detection problems on 3.13-rc1
with u-boot v2013.10.

The remaining 2 patches are required if SOFTRESET needs to be done for the
USB Host module on OMAP3 platforms.

Patch 2 fixes the hwmod RESET logic to prevent multiple SOFTRESETs
being issued to the modules. This multiple SOFTRESET was causing problems
with OMAP3 USB Host module. On Beagleboard C4 this is seen as failure to
mount NFS root over external USB to Ethernet device.

This might be the reason why HWMOD_INIT_NO_RESET was used for the OMAP
USB host module in OMAP3 hwmod data and just carried forward in OMAP4
and OMAP5 hwmod data as well.

cheers,
-roger

[1] - http://thread.gmane.org/gmane.linux.kernel/1603931

Roger Quadros (3):
  ARM: OMAP4+: hwmod data: Don't prevent RESET of USB Host module
  ARM: OMAP2+: hwmod: Fix RESET logic
  ARM: OMAP3: hwmod data: Don't prevent RESET of USB Host module

 arch/arm/mach-omap2/omap_hwmod.c           | 43 +++++++++++++++++++++++++++++-
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c | 13 +++------
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c | 12 ++-------
 arch/arm/mach-omap2/omap_hwmod_54xx_data.c | 13 +++------
 4 files changed, 50 insertions(+), 31 deletions(-)

-- 
1.8.3.2

