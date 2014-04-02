Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758875AbaDBNzl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 09:55:41 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:40750 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758600AbaDBNzi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 09:55:38 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: Tero Kristo <t-kristo@ti.com>, Mike Turquette <mturquette@linaro.org>
CC: Benoit Cousson <bcousson@baylibre.com>, Tony Lindgren <tony@atomide.com>,
        <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 0/3] clk: Add clock driver for DRA7 ATL (Audio Tracking Logic)
Date: Wed, 2 Apr 2014 16:55:04 +0300
Message-ID: <1396446907-20383-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Audio Tracking Logic is designed to be used by HD Radio
applications to synchronize the audio output clocks to the
baseband clock. ATL can be also used to track errors between
two reference clocks (BWS, AWS) and generate a modulated
clock output which averages to some desired frequency.

To be able to integrate the ATL provided clocks to the clock tree we need
two types of DT binding:
- DT clock nodes to represent the ATL clocks towards the CCF
- binding for the ATL IP itself which is going to handle the hw
  configuration

The reason for this type of setup is that ATL itself is a separate device
in the SoC, it has it's own address space and clock domain. Other IPs can
use the ATL generated clock as their functional clock (McASPs for example)
and external components like audio codecs can also use the very same clock
as their MCLK.

With setup pm_runtime can handle the ATL clock on demand of it's use and
all the IP which needs ATL clock can be sure that it is enabled for them.

The first patch fixes the name of atl clkin3 node in dtsi file.

Regards,
Peter
---
Peter Ujfalusi (3):
  ARM: dts: dra7xx-clocks: Correct name for atl clkin3 clock
  clk: Driver for DRA7 ATL (Audio Tracking Logic)
  ARM: DTS: dra7/dra7xx-clocks: ATL related changes

 .../devicetree/bindings/clock/ti/dra7-atl.txt      |  97 +++++++
 arch/arm/boot/dts/dra7.dtsi                        |  11 +
 arch/arm/boot/dts/dra7xx-clocks.dtsi               |  38 +--
 drivers/clk/ti/Makefile                            |   3 +-
 drivers/clk/ti/clk-7xx.c                           |   2 +-
 drivers/clk/ti/clk-dra7-atl.c                      | 313 +++++++++++++++++++++
 include/dt-bindings/clk/ti-dra7-atl.h              |  40 +++
 7 files changed, 483 insertions(+), 21 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/ti/dra7-atl.txt
 create mode 100644 drivers/clk/ti/clk-dra7-atl.c
 create mode 100644 include/dt-bindings/clk/ti-dra7-atl.h

-- 
1.9.1

