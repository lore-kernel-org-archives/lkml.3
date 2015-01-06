Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253AbbAFKye (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 05:54:34 -0500
Received: from mail.kapsi.fi ([217.30.184.167]:57593 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755182AbbAFKyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 05:54:11 -0500
From: Mikko Perttunen <mikko.perttunen@kapsi.fi>
To: swarren@wwwdotorg.org, thierry.reding@gmail.com, gnurou@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, wni@nvidia.com,
        Mikko Perttunen <mikko.perttunen@kapsi.fi>
Subject: [PATCH v5 REPOST 0/3] Thermal reset support in PMC
Date: Tue,  6 Jan 2015 12:52:55 +0200
Message-Id: <1420541578-27968-1-git-send-email-mikko.perttunen@kapsi.fi>
X-Mailer: git-send-email 2.2.1
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

The series is also available at
  git://github.com/cyndis/linux pmc-thermtrip-v5

Changes in v5:
- Dropped id property for I2C controllers
- Use integer field instead of phandle for thermtrip i2c controller id
- Rearrange pmc.c using a forward declaration to prevent huge patch

Mikko Perttunen (3):
  of: Add descriptions of thermtrip properties to Tegra PMC bindings
  ARM: tegra: Add PMC thermtrip programming to Jetson TK1 device tree
  ARM: tegra: Add thermal reset (thermtrip) support to PMC

 .../bindings/arm/tegra/nvidia,tegra20-pmc.txt      |  26 +++++
 arch/arm/boot/dts/tegra124-jetson-tk1.dts          |   7 ++
 drivers/soc/tegra/pmc.c                            | 107 +++++++++++++++++++++
 3 files changed, 140 insertions(+)

-- 
2.1.3

