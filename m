Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884AbaJUJXA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 05:23:00 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:42179 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048AbaJUJWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 05:22:53 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 00/12] SDHCI PXA cleanup and clocks
Date: Tue, 21 Oct 2014 11:22:32 +0200
Message-Id: <1413883364-681-1-git-send-email-sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set does a little cleanup on PXA v2/v3 drivers and
adds an additional, optional core clock to v3 driver that is
required on Marvell Berlin BG2 and BG2CD SoCs.

This is a resend of the patches are rebased on v3.18-rc1. As usual
a branch with the patches applied on top of v3.18-rc1 can be found at

git://git.infradead.org/users/hesselba/linux-berlin.git devel/bg2-bg2cd-sdhci-v1

Patches 1-9 should go through Chris' mmc tree, I'll pick up the DT
patches 10-12.

Patch 1 removes the unused private driver data from pxav2 driver.

Patch 2 is a fix for pxav3 driver to honor MMC_DDR52 timing on
uhs signaling. AFAICS, up to now there was no user affected by it
but Sony NSZ-GS7 will be.

Patch 3 moves struct sdhci_pxa from global include to the only
driver using it now. Patch 4 removes the unused clk_enable from
it.

Patch 5 removes some wrong and unnecessary checks on struct clk
from v3 driver. Patch 6 moves the struct clk for I/O clock to
the private driver data, while Patch 7 prepares the driver for
named clocks.

Patch 8 adds support for an additional, optional core clock that
is now also documented in the binding with Patch 9.

Patches 10-12 finally add corresponding sdhci nodes to berlin2
and berlin2cd, Chromecast and NSZ-GS7 DT files.

Sebastian Hesselbarth (12):
  mmc: sdhci-pxav2: Drop unused struct sdhci_pxa
  mmc: sdhci-pxav3: Respect MMC_DDR52 timing on uhs signaling
  mmc: sdhci-pxav3: Move private driver data to driver source
  mmc: sdhci-pxav3: Remove unused clk_enable from sdhci_pxa
  mmc: sdhci-pxav3: Remove checks for mandatory host clock
  mmc: sdhci-pxav3: Move I/O clock to private data
  mmc: sdhci-pxav3: Try to get named I/O clock first
  mmc: sdhci-pxav3: Get optional core clock
  mmc: sdhci-pxav3: Document clocks and additional clock-names property
  ARM: dts: berlin: Add SDHCI controller nodes to BG2/BG2CD
  ARM: dts: berlin: Enable WiFi on Google Chromecast
  ARM: dts: berlin: Enable eMMC on Sony NSZ-GS7

 .../devicetree/bindings/mmc/sdhci-pxa.txt          |  7 +++
 arch/arm/boot/dts/berlin2-sony-nsz-gs7.dts         |  7 +++
 arch/arm/boot/dts/berlin2.dtsi                     | 34 ++++++++++++
 arch/arm/boot/dts/berlin2cd-google-chromecast.dts  |  9 ++++
 arch/arm/boot/dts/berlin2cd.dtsi                   |  9 ++++
 drivers/mmc/host/sdhci-pxav2.c                     | 15 ++----
 drivers/mmc/host/sdhci-pxav3.c                     | 60 ++++++++++++++--------
 include/linux/platform_data/pxa_sdhci.h            |  5 --
 8 files changed, 108 insertions(+), 38 deletions(-)

---
Cc: Chris Ball <chris@printf.net>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Cc: "Antoine Ténart" <antoine.tenart@free-electrons.com>
Cc: linux-mmc@vger.kernel.org
Cc: devicetree@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
-- 
2.1.1

