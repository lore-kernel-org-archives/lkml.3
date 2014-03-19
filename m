Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933753AbaCSK1g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 06:27:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46804 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759288AbaCSK1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 06:27:35 -0400
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: broonie@kernel.org
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        ckeepax@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] Arizona regulator updates v3
Date: Wed, 19 Mar 2014 10:18:53 +0000
Message-Id: <1395224338-3709-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series of patches are small fixes/improvements to the
Arizona regulators. The main thing added is proper device
tree bindings for getting the regulator init_data.

Changes Since v2:
  - We now set external_dcvdd in arizona-core and then clear
  in the LDO1 regulator driver, such that if the regulator
  driver is not compiled in then we will default to an
  external DCVDD.

Thanks,
Charles

Charles Keepax (5):
  arizona: Correct small errors in the DT binding documentation
  mfd: arizona: Fix and factor out read of device tree GPIOs
  regulator: arizona-ldo1: Move setup processing from arizona-core
  regulator: arizona-ldo1: Add processing of init_data from device tree
  regulator: arizona-micsupp: Add processing of init_data from device
    tree

 Documentation/devicetree/bindings/mfd/arizona.txt |   32 +++++++---
 drivers/mfd/arizona-core.c                        |   43 ++++++++-----
 drivers/regulator/arizona-ldo1.c                  |   70 +++++++++++++++++++++
 drivers/regulator/arizona-micsupp.c               |   50 +++++++++++++++
 include/linux/mfd/arizona/core.h                  |    3 +
 5 files changed, 171 insertions(+), 27 deletions(-)

-- 
1.7.2.5

