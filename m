Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab3LETau (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 14:30:50 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:62777 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab3LETaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 14:30:46 -0500
X-Greylist: delayed 567 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Dec 2013 14:30:46 EST
X-IronPort-AV: E=Sophos;i="4.93,835,1378882800"; 
   d="scan'208";a="366952"
From: Tim Kryger <tim.kryger@linaro.org>
To: Christian Daudt <bcm@fixthebug.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Chris Ball <cjb@laptop.org>,
        Axel Lin <axel.lin@ingics.com>
CC: Tim Kryger <tim.kryger@linaro.org>,
        Device Tree List <devicetree@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linaro Patches List <patches@linaro.org>
Subject: [PATCH v4 0/8] Update Kona drivers to use clocks
Date: Thu, 5 Dec 2013 11:20:36 -0800
Message-ID: <1386271244-3927-1-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.8.0.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series declares the clocks present on bcm11351 (aka bcm281xx) SoCs
to be fixed at the rates configured by development bootloaders and then
updates the Kona drivers to make use of clock calls where appropriate.

Changes in v4:
  - Rebased on v3.13-rc2
  - DT binding documents now say "phandle + clock specifier pair"
  - Recent change by Axel to use sdhci_pltfm_unregister must be undone
    to allow clk_disable_unprepare to be called at the right point in
    sdhci_bcm_kona_remove

Changes in v3:
  - Updated the commit message for the UART DTS change
  - Added a patch to change the kona timer binding doc
  - Updated the commit message for the kona timer driver change
  - Updated the panic message in the kona timer driver
  - Added a patch to change the kona sdhci binding doc
  - Moved the SDHCI driver change earlier in the series
  - Removed unrelated change from SDHCI driver patch

Changes in v2:
  - Renamed bsc4_clk to pmu_bsc_clk

Tim Kryger (8):
  ARM: dts: Declare clocks as fixed on bcm11351
  ARM: dts: Specify clocks for UARTs on bcm11351
  Documentation: dt: kona-sdhci: Add clocks property
  ARM: dts: Specify clocks for SDHCIs on bcm11351
  mmc: sdhci-bcm-kona: Add basic use of clocks
  Documentation: dt: kona-timer: Add clocks property
  clocksource: kona: Add basic use of external clock
  ARM: dts: Specify clocks for timer on bcm11351

 .../devicetree/bindings/arm/bcm/kona-timer.txt     |   7 +-
 .../devicetree/bindings/mmc/kona-sdhci.txt         |   4 +
 arch/arm/boot/dts/bcm11351.dtsi                    | 111 ++++++++++++++++++++-
 drivers/clocksource/bcm_kona_timer.c               |  14 ++-
 drivers/mmc/host/sdhci-bcm-kona.c                  |  37 ++++++-
 5 files changed, 162 insertions(+), 11 deletions(-)

-- 
1.8.0.1

