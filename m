Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab3LQNAw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 08:00:52 -0500
Received: from smtp5.epfl.ch ([128.178.224.8]:50524 "EHLO smtp5.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753497Ab3LQNAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:00:50 -0500
From: Florian Vaussard <florian.vaussard@epfl.ch>
To: Joerg Roedel <joro@8bytes.org>, Tony Lindgren <tony@atomide.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        iommu@lists.linux-foundation.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/7] Fix omap-iommu probe and convert to DT for 3.14
Date: Tue, 17 Dec 2013 13:53:31 +0100
Message-Id: <1387284818-28739-1-git-send-email-florian.vaussard@epfl.ch>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OMAP2+ is heading towards a full device tree boot for 3.14. Currently,
the iommu used by the OMAP3 camera subsystem is not yet converted. It
cannot be probed as necessary data are only passed through device tree.

Patches 1 and 2 are small fixes for problems encountered while developing
this series.

Patches 3 to 5 add the device tree logic to omap-iommu, and complete iommu
data in omap3.dtsi. Patches 6 and 7 remove unused iommu hwmod data and
platform code from OMAP2+.

This was tested on Overo (OMAP36xx) with an MT9V032 sensor connected
to the isp interface. The full testing tree can be found here [2] (not
safe for merging).

Patches are based on 3.13-rc3. OMAP-related patches are based on Tony's
omap-for-v3.14/omap3-board-removal branch [1].

Regards,

Florian

[1] git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap.git
      omap-for-v3.14/omap3-board-removal
[2] git@github.com:vaussard/linux.git overo-for-3.14/iommu/dt

Florian Vaussard (7):
  iommu/omap: Do bus_set_iommu() only if probe() succeeds
  iommu/omap: omap_iommu_attach() should return ENODEV, not NULL
  iommu/omap: Convert to devicetree
  iommu/omap: Allow enable/disable even without pdata
  ARM: dts: Complete data for isp iommu
  ARM: OMAP2+: Remove legacy data from hwmod for omap3 isp iommu
  ARM: OMAP2+: Remove platform-specific omap-iommu

 .../devicetree/bindings/iommu/ti,omap-iommu.txt    |  19 ++
 arch/arm/boot/dts/omap3.dtsi                       |   4 +-
 arch/arm/mach-omap2/Makefile                       |   3 -
 arch/arm/mach-omap2/omap-iommu.c                   |  74 ------
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |   8 -
 drivers/iommu/omap-iommu.c                         | 247 +++++++++++----------
 6 files changed, 156 insertions(+), 199 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/iommu/ti,omap-iommu.txt
 delete mode 100644 arch/arm/mach-omap2/omap-iommu.c

-- 
1.8.1.2

