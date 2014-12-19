Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392AbaLSMF2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 07:05:28 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:32943 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbaLSMF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 07:05:26 -0500
From: Roger Quadros <rogerq@ti.com>
To: <kishon@ti.com>, <tony@atomide.com>
CC: <nm@ti.com>, <balbi@ti.com>, <george.cherian@ti.com>, <nsekhar@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH 0/2] phy: ti-pipe3: fixes for 3.19-rc
Date: Fri, 19 Dec 2014 14:05:18 +0200
Message-ID: <1418990720-3638-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

During system suspend L3INIT_960M_GFCLK and L3INIT_480M_GFCLK clocks remain
active on the DRA7 platform. This is because the pipe3 driver doesn't shut
them off as part of .suspend(). Patch 1 addresses this issue.

SATA on both OMAP5 and DRA7 breaks when SATA drive is plugged in after a
system suspend/resume or if  AHCI_PLATFORM driver is used as module.
Patch 2 fixes it.

Hope to get these 2 patches in through the 3.19-rc cycle.

Tony, patch 2 touches dra7.dtsi and omap5.dts and will need your Ack.
Hopefully it can go in through Kishon's PHY tree.

cheers,
-roger

Roger Quadros (2):
  phy: ti-pipe3: Disable clocks on system suspend
  phy: ti-pipe3: Fix SATA across suspend/resume

 arch/arm/boot/dts/dra7.dtsi  |   4 +-
 arch/arm/boot/dts/omap5.dtsi |   4 +-
 drivers/phy/phy-ti-pipe3.c   | 138 +++++++++++++++++++++++++++++++++----------
 3 files changed, 111 insertions(+), 35 deletions(-)

-- 
2.1.0

