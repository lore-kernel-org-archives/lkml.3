Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab3KNTL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 14:11:28 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:4815 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755868Ab3KNTLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 14:11:13 -0500
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
From: "Tim Kryger" <tim.kryger@linaro.org>
To: "Christian Daudt" <bcm@fixthebug.org>,
        "Rob Herring" <rob.herring@calxeda.com>,
        "Pawel Moll" <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        "Stephen Warren" <swarren@wwwdotorg.org>,
        "Ian Campbell" <ijc+devicetree@hellion.org.uk>,
        "Daniel Lezcano" <daniel.lezcano@linaro.org>,
        "Thomas Gleixner" <tglx@linutronix.de>, "Chris Ball" <cjb@laptop.org>
cc: "Tim Kryger" <tim.kryger@linaro.org>,
        "Device Tree List" <devicetree@vger.kernel.org>,
        "Linux ARM Kernel List" <linux-arm-kernel@lists.infradead.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        "Linux MMC List" <linux-mmc@vger.kernel.org>,
        "Linaro Patches List" <patches@linaro.org>
Subject: [PATCH v3 0/8] Update Kona drivers to use clocks
Date: Thu, 14 Nov 2013 11:10:35 -0800
Message-ID: <1384456243-27053-1-git-send-email-tim.kryger@linaro.org>
X-Mailer: git-send-email 1.8.0.1
MIME-Version: 1.0
X-WSS-ID: 7E9BFFBF1508205913-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series declares the clocks present on bcm11351 (aka bcm281xx) SoCs
to be fixed at the rates configured by development bootloaders and then
updates the Kona drivers to make use of clock calls where appropriate.

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

 .../devicetree/bindings/arm/bcm/kona-timer.txt     |   8 +-
 .../devicetree/bindings/mmc/kona-sdhci.txt         |   5 +
 arch/arm/boot/dts/bcm11351.dtsi                    | 111 ++++++++++++++++++++-
 drivers/clocksource/bcm_kona_timer.c               |  14 ++-
 drivers/mmc/host/sdhci-bcm-kona.c                  |  28 +++++-
 5 files changed, 156 insertions(+), 10 deletions(-)

-- 
1.8.0.1


