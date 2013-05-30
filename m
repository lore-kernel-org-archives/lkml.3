Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab3E3Nwc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 09:52:32 -0400
Received: from smtp4.epfl.ch ([128.178.224.219]:37874 "HELO smtp4.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756440Ab3E3NwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 09:52:25 -0400
From: Florian Vaussard <florian.vaussard@epfl.ch>
To: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: Rob Landley <rob@landley.net>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Tero Kristo <t-kristo@ti.com>, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Florian Vaussard <florian.vaussard@epfl.ch>
Subject: [PATCH 0/3] mfd: twl4030-power: Start DT conversion
Date: Thu, 30 May 2013 15:51:53 +0200
Message-Id: <1369921916-7435-1-git-send-email-florian.vaussard@epfl.ch>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This series enables a partial DT support for twl4030-power. The
missing part is the power management scripts, as the required
binding should be defined first. It however enables the complete
shutdown of the processor at poweroff when booting with DT,
dropping the power consumption from around 350 mA on Overo+Tobi
to about 40 mA.

The poweroff callback was tested with both DT and non-DT boots.

Best regards,

Florian

Florian Vaussard (3):
  mfd: twl4030-power: Split from twl-core into a dedicated module
  mfd: twl4030-power: Start transition to DT
  mfd: twl4030-power: Simplify error path

 .../devicetree/bindings/mfd/twl4030-power.txt      |   28 ++++
 drivers/mfd/twl-core.c                             |   12 +-
 drivers/mfd/twl4030-power.c                        |  149 +++++++++++++++-----
 include/linux/i2c/twl.h                            |    1 -
 4 files changed, 148 insertions(+), 42 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/twl4030-power.txt

-- 
1.7.5.4

