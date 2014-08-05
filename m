Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932610AbaHEIOL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 04:14:11 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:3846 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932590AbaHEIOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 04:14:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 05 Aug 2014 01:01:23 -0700
From: Mikko Perttunen <mperttunen@nvidia.com>
To: <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH 0/3] Thermal reset support in PMC
Date: Tue, 5 Aug 2014 11:12:57 +0300
Message-ID: <1407226380-747-1-git-send-email-mperttunen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this series adds support for hardware-triggered thermal reset to the PMC
driver. Namely, it adds device tree properties for specifying the I2C
command to be sent when thermtrip is triggered. It is to be noted
that thermtrip won't be ever triggered without a soctherm driver to
calibrate the sensors, but I'll follow up with that patch.

pmc.c required some juggling around to make the match data usable in
probe, since I didn't want to put the code into the initcall either, since
the soctherm driver won't be initialized by that point anyway.

Series tested on Jetson-TK1. Should work on Tegra30 and Tegra114 too.

Thanks,
Mikko

Mikko Perttunen (3):
  of: Add descriptions of thermtrip properties to Tegra PMC bindings
  ARM: tegra: Add PMC thermtrip programming to Jetson TK1 device tree
  ARM: tegra: Add thermal reset (thermtrip) support to PMC

 .../bindings/arm/tegra/nvidia,tegra20-pmc.txt      |  13 +
 arch/arm/boot/dts/tegra124-jetson-tk1.dts          |   5 +
 drivers/soc/tegra/pmc.c                            | 348 +++++++++++++--------
 3 files changed, 234 insertions(+), 132 deletions(-)

-- 
1.8.1.5

