Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942AbaIFI4G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 04:56:06 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:58828 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbaIFIzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 04:55:18 -0400
From: Mikko Perttunen <cyndis@kapsi.fi>
To: swarren@wwwdotorg.org, thierry.reding@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, wni@nvidia.com,
        Mikko Perttunen <cyndis@kapsi.fi>
Subject: [PATCH v3 0/5] Thermal reset support in PMC
Date: Sat,  6 Sep 2014 11:54:40 +0300
Message-Id: <1409993685-21911-1-git-send-email-cyndis@kapsi.fi>
X-Mailer: git-send-email 2.1.0
X-SA-Exim-Connect-IP: 2001:708:30:12d0:beee:7bff:fe5b:f272
X-SA-Exim-Mail-From: cyndis@kapsi.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this series adds support for hardware-triggered thermal reset to the PMC
driver. Namely, it adds device tree properties for specifying the I2C
command to be sent when thermtrip is triggered. It is to be noted
that thermtrip won't be ever triggered without a soctherm driver to
calibrate the sensors.

Git repo at
  git://github.com/cyndis/linux.git pmc-thermtrip-v3

Mikko Perttunen (5):
  of: Add descriptions of thermtrip properties to Tegra PMC bindings
  of: Add nvidia,controller-id property to Tegra I2C bindings
  ARM: tegra124: Add I2C controller ids to device tree
  ARM: tegra: Add PMC thermtrip programming to Jetson TK1 device tree
  ARM: tegra: Add thermal reset (thermtrip) support to PMC

 .../bindings/arm/tegra/nvidia,tegra20-pmc.txt      |  23 ++
 .../devicetree/bindings/i2c/nvidia,tegra20-i2c.txt |   5 +
 arch/arm/boot/dts/tegra124-jetson-tk1.dts          |   9 +-
 arch/arm/boot/dts/tegra124.dtsi                    |   6 +
 drivers/soc/tegra/pmc.c                            | 379 ++++++++++++++-------
 5 files changed, 289 insertions(+), 133 deletions(-)

-- 
2.1.0

