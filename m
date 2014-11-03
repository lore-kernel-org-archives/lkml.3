Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbaKCOmS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 09:42:18 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:38817 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbaKCOmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 09:42:15 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        Olof Johansson <olof@lixom.net>, Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v4 00/14] Add max77802 regulator operating mode support
Date: Mon,  3 Nov 2014 15:40:35 +0100
Message-Id: <1415025649-8119-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

This is the fourth version of the series that adds operating modes
support for the regulators in the max77802 PMIC. This version uses
the standard suspend states bindings and the opmodes are parsed by
the regulator core while drivers only define a translation function
to map between hardware specific to standard modes as you suggested.

The series adds a "regulator-initial-mode" property to configure at
startup the operating mode for the regulators that support changing
its mode during normal operation and a "regulator-mode" property for
the regulators that supports changing its operating mode when the
system enters in a suspend state. These properties were originally
part of Chanwoo Choi's regulator suspend state series [0] but were
removed since there wasn't a way to define the operating modes in a
generic way.

In this series, the generic regulator DT binding doc explains that each
device has to document what their valid operating modes are. Drivers
must provide a translation function so the core can map the modes.

Since parsing the modes in the core is a very different approach, most
of the patches are new but those that remains have a changelog.

This series depend on [0] and also v2 of patch:
"ARM: EXYNOS: Call regulator core suspend prepare and finish functions" [1].

Javier Martinez Canillas (14):
  regulator: Document binding for initial and suspend modes
  regulator: Add function to map modes to struct regulator_desc
  regulator: of: Add regulator desc param to
    of_get_regulator_init_data()
  regulator: of: Pass the regulator description in the match table
  regulator: max1586: zero-initialize regulator match table array
  regulator: max77686: zero-initialize regulator match table
  regulator: max77802: zero-initialize regulator match table
  regulator: max8660: zero-initialize regulator match table array
  regulator: s2mpa01: zero-initialize regulator match table array
  regulator: of: Add support for parsing initial and suspend modes
  regulator: max77802: Document binding for regulator operating modes
  regulator: max77802: Use unsigned int for modes in max77802_map_mode()
  regulator: max77802: Set regulator modes translation callback
  ARM: dts: Configure regulators for suspend on exynos Peach boards

Patch #1 extends the regulator DT binding to document the initial and
suspend modes properties.

Patch #2 adds a function pointer to the static regulator description
so drivers can define a callback that does the modes translation.

Patch #3 does some refactoring to pass the regulator descriptor to the
function extracting the regulator initial data from DT.

Patch #4 adds a pointer to the regulator descriptor in the match table
so users extracting the init_data from of_regulator_match can also map
the modes.

Patch #5-#9 are fixes to be sure that all callers are passing an
initialised match table.

Patch #10 modifies the function that extracts the regulator data from
DT to parse the initial and suspend modes.

Patch #11 extends the max77802 DT binding to document the valid opmodes
for the regulators on this device.

Patch #12 change the signature of the function doing the modes mapping
for the max77802 regulators mode.

Patch #13 set the function handler for the max77802 modes translation.

Patch #14 configure the regulators for the Peach Pit and Pi Chromebooks.

Best regards,
Javier

[0]: https://lkml.org/lkml/2014/10/10/161
[1]: http://www.spinics.net/lists/arm-kernel/msg369923.html
