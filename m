Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbaFTOxN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 10:53:13 -0400
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:41713 "EHLO
	mirror2.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903AbaFTOxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 10:53:09 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Chen-Yu Tsai <wens@csie.org>, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@googlegroups.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/4] ARM: sunxi: Introduce Allwinner A23 (sun8i) support
Date: Fri, 20 Jun 2014 22:52:49 +0800
Message-Id: <1403275973-24259-1-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

This is v3 of the Allwinner A23 support series. It has been trimmed
down to only support uarts, timers and reboot via watchdog, as
requested by Maxime. All of these blocks are compatible with those
found in the A31, and use the existing drivers in the kernel. The
series is based on v3.16-rc1.

The A23 is a mix of Allwinner's previous A20 (sun7i) and A31 (sun6i)
SoC's, but also a step forward. Most of the IP blocks are the same as
in the A31, with some features stripped out. However it has a Mali GPU,
instead of a PowerVR.

The patches are a result of comparing the current working sun6i platform
with the A23 user manual, and various kernel and u-boot sources for A23
and A31 from Allwinner.

Patch 1 adds the DT binding for the A23 SoC.
Patch 2 adds the Kconfig option to select R_UART as the early console.
Patch 3 adds the DTSI for the SoC. Only the basic stuff.
Patch 4 adds the DTS for the device I have, which is a cheap A23 tablet.


Relevant changes since v2:

  - Changed memory range to 1GB, same as maximum supported size.
  - Dropped timer_init call.
  - Trimmed down dtsi/dts to only gic, uarts, timers and the watchdog.

Relevant changes since v1:

  - Change depends on for DEBUG_SUNXI_R_UART
  - Added memory node to sun8i DTSI


Thanks, and sorry for the noise from the previous patches.


Cheers
ChenYu


Chen-Yu Tsai (4):
  ARM: sunxi: Introduce Allwinner A23 support
  ARM: sunxi: Add earlyprintk support using R_UART (sun6i/sun8i)
  ARM: sunxi: Add Allwinner A23 dtsi
  ARM: sun8i: dt: Add Ippo-q8h v5 support

 arch/arm/Kconfig.debug                      |  10 ++
 arch/arm/boot/dts/Makefile                  |   2 +
 arch/arm/boot/dts/sun8i-a23-ippo-q8h-v5.dts |  31 ++++++
 arch/arm/boot/dts/sun8i-a23.dtsi            | 160 ++++++++++++++++++++++++++++
 arch/arm/mach-sunxi/Kconfig                 |   5 +
 arch/arm/mach-sunxi/sunxi.c                 |   9 ++
 6 files changed, 217 insertions(+)
 create mode 100644 arch/arm/boot/dts/sun8i-a23-ippo-q8h-v5.dts
 create mode 100644 arch/arm/boot/dts/sun8i-a23.dtsi

-- 
2.0.0

