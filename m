Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249AbaKGNA1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 08:00:27 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:44206 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaKGNAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 08:00:24 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Olof Johansson <olof@lixom.net>, Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v5 0/5] regulator: of: Add initial and suspend modes support
Date: Fri,  7 Nov 2014 14:00:00 +0100
Message-Id: <1415365205-27630-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

This is the fifth version of the series that adds regulator initial
and suspend operating modes support. It relies on the existing work
that added suspend states bindings. The opmodes are parsed by the
regulator core and drivers should only define a translation function
to map between hardware specific to standard modes.

The series adds a "regulator-initial-mode" property to configure at
startup, the operating mode for the regulators that support changing
its mode during normal operation and a "regulator-mode" property for
the regulators that supports changing its operating mode when the
system enters in a suspend state. These properties were originally
part of Chanwoo Choi's regulator suspend state series [0] but were
removed since there wasn't a way to define the operating modes in a
generic way.

The generic regulator DT binding doc explains that each device has
to document what their valid operating modes are and drivers must
add a translation function so the core knows how to map the opmodes.

Older versions of this series were meant to add initial and suspend
modes for the max77802 regulator driver but the feedback was that
this should had been done in a generic way. The latest version was
"[PATCH v4 00/14] Add Maxim 77802 PMIC support" [1] but that series
mixed core changes, bugfixes and new driver features.

This series instead contains only the patches that add the support
to the regulator core and drivers are only modified when a function
signature is changed to maintain git bisect-ability.

If the patches are merged, following series will change the drivers
using of_regulator_match() to pass the regulator description in the
match table and another series will add the new opmode feature in
the max77802 regulator driver.

The series is composed of the following patches:

Javier Martinez Canillas (5):
  regulator: Document binding for initial and suspend modes
  regulator: Add function to map modes to struct regulator_desc
  regulator: of: Add regulator desc param to
    of_get_regulator_init_data()
  regulator: of: Pass the regulator description in the match table
  regulator: of: Add support for parsing initial and suspend modes

 .../devicetree/bindings/regulator/regulator.txt    | 14 ++++++++++
 drivers/regulator/88pm8607.c                       |  3 +-
 drivers/regulator/anatop-regulator.c               |  4 +--
 drivers/regulator/arizona-ldo1.c                   |  8 ++++--
 drivers/regulator/arizona-micsupp.c                |  8 ++++--
 drivers/regulator/da9052-regulator.c               |  3 +-
 drivers/regulator/da9210-regulator.c               |  2 +-
 drivers/regulator/fan53555.c                       | 17 ++++++------
 drivers/regulator/fixed.c                          | 18 ++++++------
 drivers/regulator/gpio-regulator.c                 | 18 ++++++------
 drivers/regulator/max8952.c                        |  2 +-
 drivers/regulator/max8973-regulator.c              |  3 +-
 drivers/regulator/max8997.c                        |  3 +-
 drivers/regulator/max8998.c                        |  5 ++--
 drivers/regulator/mc13xxx-regulator-core.c         |  3 +-
 drivers/regulator/of_regulator.c                   | 32 ++++++++++++++++++----
 drivers/regulator/pwm-regulator.c                  |  3 +-
 drivers/regulator/qcom_rpm-regulator.c             |  9 +++---
 drivers/regulator/s5m8767.c                        |  3 +-
 drivers/regulator/sky81452-regulator.c             |  2 +-
 drivers/regulator/stw481x-vmmc.c                   |  3 +-
 drivers/regulator/ti-abb-regulator.c               |  3 +-
 drivers/regulator/tps51632-regulator.c             | 16 ++++++-----
 drivers/regulator/tps62360-regulator.c             | 17 +++++++-----
 drivers/regulator/tps65218-regulator.c             |  3 +-
 drivers/regulator/twl-regulator.c                  |  3 +-
 drivers/regulator/vexpress.c                       |  3 +-
 include/linux/regulator/driver.h                   |  8 ++++++
 include/linux/regulator/of_regulator.h             |  9 ++++--
 29 files changed, 151 insertions(+), 74 deletions(-)

Best regards,
Javier

[0]: https://lkml.org/lkml/2014/10/10/161
[1]: https://lkml.org/lkml/2014/6/25/668
