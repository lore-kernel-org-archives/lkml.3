Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705Ab3CLWKC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:10:02 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7713 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190Ab3CLWKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:10:00 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 12 Mar 2013 15:09:59 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, Samuel Ortiz <sameo@linux.intel.com>
CC: <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>
Subject: [Patch v3 0/4] Add support for tps65090-charger
Date: Tue, 12 Mar 2013 18:08:05 -0400
Message-ID: <1363126089-9071-1-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds support for the TPS65090-charger. This charger is
registered as a subdevice of the TPS65090 PMIC.

This series includes a fix for the tps65090 header file where all
the interrupts were shifted by 1.

v3:
 - fixed up the tps65090-charger driver to fix build errors/warnings

v2:
 - cleaned up tps65090 driver per comments (mostly var naming)
 - flushed out commit description for driver
 - reordered probe so irq is registered after power_supply and cleaned up 1st


Rhyland Klein (4):
  mfd: tps65090: Fix enum in header file
  mfd: tps65090: Add resources for charger
  power_supply: tps65090-charger: Add binding doc
  power: tps65090: Add support for tps65090-charger

 .../devicetree/bindings/power_supply/tps65090.txt  |   23 ++
 drivers/mfd/tps65090.c                             |   10 +
 drivers/power/Kconfig                              |    7 +
 drivers/power/Makefile                             |    1 +
 drivers/power/tps65090-charger.c                   |  315 ++++++++++++++++++++
 include/linux/mfd/tps65090.h                       |    6 +
 6 files changed, 362 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/power_supply/tps65090.txt
 create mode 100644 drivers/power/tps65090-charger.c

-- 
1.7.9.5

