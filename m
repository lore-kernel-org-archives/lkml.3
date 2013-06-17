Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932934Ab3FQMRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 08:17:23 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38031 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932727Ab3FQMRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 08:17:21 -0400
From: J Keerthy <j-keerthy@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <broonie@kernel.org>, <j-keerthy@ti.com>, <ldewangan@nvidia.com>,
        <sameo@linux.intel.com>, <grant.likely@secretlab.ca>,
        <swarren@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <gg@slimlogic.co.uk>
Subject: [PATCH 0/4] MFD: Palmas: Add TPS659038 PMIC to supported devices of Palmas
Date: Mon, 17 Jun 2013 17:39:10 +0530
Message-ID: <1371470954-9124-1-git-send-email-j-keerthy@ti.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Patch series adds TPS659038 PMIC support in the palmas mfd/voltage driver.
The TPS659038 has almost the same registers as of the earlier
supported variants of PALMAS family such as the TWL6035.

The critical differences between TPS659038 and TWL6035 being:

1) TPS659038 has nothing related to battery charging and back up battery stuff.
2) TPS659038 does not have does not have SMPS10(Boost) step up convertor.
3) TPS659038 does not have Battery detection and anything related to battery.
4) SD card detection, Battery presence detection, Vibrator, USB OTG are missing
   when compared to TWL6035.

The patch series is based on the patch:
	http://www.mail-archive.com/linux-omap@vger.kernel.org/msg90598.html

J Keerthy (4):
  MFD: Palmas: Add Interrupt feature
  mfd: Palmas: Add TPS659038 PMIC support
  MFD: Palmas: Add SMPS10_BOOST feature
  regulator: Palmas: Add TPS659038 support

 Documentation/devicetree/bindings/mfd/palmas.txt   |    2 +
 .../devicetree/bindings/regulator/palmas-pmic.txt  |    1 +
 drivers/mfd/palmas.c                               |   39 ++++++++++++++++----
 drivers/regulator/palmas-regulator.c               |    4 ++
 include/linux/mfd/palmas.h                         |   18 +++++++++
 5 files changed, 57 insertions(+), 7 deletions(-)

-- 
1.7.5.4

