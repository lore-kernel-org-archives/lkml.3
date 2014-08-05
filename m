Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697AbaHEMVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 08:21:31 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:14035 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbaHEMV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 08:21:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 05 Aug 2014 05:12:47 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <rui.zhang@intel.com>, <edubezval@gmail.com>, <swarren@wwwdotorg.org>,
        <thierry.reding@gmail.com>
CC: <linux-pm@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH v2 0/4] Tegra124 soctherm driver
Date: Tue, 5 Aug 2014 15:18:53 +0300
Message-ID: <1407241137-32232-1-git-send-email-mperttunen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this series adds support for the thermal monitoring features of the
soctherm unit on the Tegra124 SoC. v2 drops support for interrupt-
based trip points. Thermtrip (emergency thermal shutdown) still
works when this driver is loaded and the PMC thermal reset patch
series is applied.

The branch is also available in my github repo,
  git://github.com/cyndis/linux.git soctherm-v2

Thanks,
Mikko

Mikko Perttunen (4):
  of: Add bindings for nvidia,tegra124-soctherm
  ARM: tegra: Add soctherm and thermal zones to Tegra124 device tree
  ARM: tegra: Add thermal trip points for Jetson TK1
  thermal: Add Tegra SOCTHERM thermal management driver

 .../devicetree/bindings/thermal/tegra-soctherm.txt |  35 ++
 arch/arm/boot/dts/tegra124-jetson-tk1.dts          |  32 ++
 arch/arm/boot/dts/tegra124.dtsi                    |  47 +++
 drivers/thermal/Kconfig                            |   7 +
 drivers/thermal/Makefile                           |   1 +
 drivers/thermal/tegra_soctherm.c                   | 452 +++++++++++++++++++++
 include/dt-bindings/thermal/tegra124-soctherm.h    |  13 +
 7 files changed, 587 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/thermal/tegra-soctherm.txt
 create mode 100644 drivers/thermal/tegra_soctherm.c
 create mode 100644 include/dt-bindings/thermal/tegra124-soctherm.h

-- 
1.8.1.5

