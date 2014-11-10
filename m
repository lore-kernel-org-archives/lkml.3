Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbaKJNNW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 08:13:22 -0500
Received: from mail.kapsi.fi ([217.30.184.167]:47625 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204AbaKJNNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 08:13:16 -0500
From: Mikko Perttunen <mikko.perttunen@kapsi.fi>
To: swarren@wwwdotorg.org, thierry.reding@gmail.com, gnurou@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, wni@nvidia.com,
        Mikko Perttunen <mikko.perttunen@kapsi.fi>
Subject: [PATCH v4 REPOST 0/5] Thermal reset support in PMC
Date: Mon, 10 Nov 2014 15:12:12 +0200
Message-Id: <1415625137-4791-1-git-send-email-mikko.perttunen@kapsi.fi>
X-Mailer: git-send-email 2.1.3
X-SA-Exim-Connect-IP: 2001:708:30:12d0:beee:7bff:fe5b:f272
X-SA-Exim-Mail-From: mikko.perttunen@kapsi.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this series adds support for hardware-triggered thermal reset to the PMC
driver. Namely, it adds device tree properties for specifying the I2C
command to be sent when thermtrip is triggered.

The soctherm driver has now been acked and will be taken into 3.19, so we
can move forward with this. Note that there are no compile time dependencies
between the two series; it's just that this series is no-op without the
soctherm driver being present.

Mikko Perttunen (5):
  of: Add descriptions of thermtrip properties to Tegra PMC bindings
  of: Add nvidia,controller-id property to Tegra I2C bindings
  ARM: tegra124: Add I2C controller ids to device tree
  ARM: tegra: Add PMC thermtrip programming to Jetson TK1 device tree
  ARM: tegra: Add thermal reset (thermtrip) support to PMC

 .../bindings/arm/tegra/nvidia,tegra20-pmc.txt      |  24 ++
 .../devicetree/bindings/i2c/nvidia,tegra20-i2c.txt |   5 +
 arch/arm/boot/dts/tegra124-jetson-tk1.dts          |   9 +-
 arch/arm/boot/dts/tegra124.dtsi                    |   6 +
 drivers/soc/tegra/pmc.c                            | 379 ++++++++++++++-------
 5 files changed, 290 insertions(+), 133 deletions(-)

-- 
2.1.3

