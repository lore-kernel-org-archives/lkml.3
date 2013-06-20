Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965139Ab3FTIkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 04:40:11 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55869 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935303Ab3FTIiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 04:38:17 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <ldewangan@nvidia.com>, <broonie@kernel.org>
CC: <grant.likely@linaro.org>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <lgirdwood@gmail.com>, <swarren@nvidia.com>, <gg@slimlogic.co.uk>,
        <sameo@linux.intel.com>, <ian@slimlogic.co.uk>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kishon@ti.com>
Subject: [PATCH 0/2] Model SMPS10 regulator
Date: Thu, 20 Jun 2013 14:07:36 +0530
Message-ID: <1371717458-10307-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Palmas has SMPS10 regulator which can generate two voltage level 3.75 and 5V.
This SMPS10 has two outputs OUT1 and OUT2 and having one input IN1.

SMPS10-OUT2 is always connected to SMPS10-IN1 via following logic:
- Through parasitic diode (no sw control)
- In bypass mode (bit  configuration is there to enable/disable Bypass)
- In Boost mode (bit configuration is there to enable/disable Boost mode)

SMPS10-OUT1 is connected to the SMPS10-OUT2 pin through Switch (SW control
for enabling/disabling this switch).

There currently doesn't exist a property to indicate if the regulator
supports bypass mode. So added a property to indicate if the regulator
supports bypass mode. Also modified of_get_regulation_constraints() 
to check for that property and set appropriate constraints.

The second patch models SMPS10 as two regulators, SMPS10-OUT1 and SMPS10-OUT2.

Tested regulator enable of SMPS10-OUT1.
Dint test bypass mode.

Kishon Vijay Abraham I (2):
  regulator: of: Added a property to indicate bypass mode support
  regulator: palmas: model SMPS10 as two regulators

 .../devicetree/bindings/regulator/regulator.txt    |    1 +
 drivers/regulator/of_regulator.c                   |    3 ++
 drivers/regulator/palmas-regulator.c               |   39 ++++++++++++++++++--
 include/linux/mfd/palmas.h                         |    9 +++--
 4 files changed, 44 insertions(+), 8 deletions(-)

-- 
1.7.10.4

