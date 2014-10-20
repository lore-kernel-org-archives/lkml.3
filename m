Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbaJTOsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 10:48:36 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:39889 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbaJTOsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 10:48:33 -0400
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        Chris Zhong <zyw@rock-chips.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Abhilash Kesavan <kesavan.abhilash@gmail.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v3 0/5] Add max77802 regulator operating mode support
Date: Mon, 20 Oct 2014 16:47:47 +0200
Message-Id: <1413816472-1895-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Mark,

This is the third version of the series that adds operating modes
support for the regulators in the max77802 PMIC. This version uses the
standard regulator suspend states bindings as you suggested and also
drops the patches already picked by you from the first [0] and second [1]
version of the series.

The series adds a "regulator-initial-mode" property to configure at
startup the operating mode for the regulators that support changing
its mode during normal operation and a "regulator-mode" property for the
regulators that supports changing its operating mode when the system
enters in a suspend state. These properties were originally part of
Chanwoo Choi's regulator suspend state series [2] but were removed since
there wasn't a way to define the operatin modes in a generic way.

In this series, the generic regulator DT binding doc explains that each
device has to document what their valid operating modes are and the
driver has to parse those and translate to the standard regulator modes.

This series depend on [2] and also v2 of patch:
"ARM: EXYNOS: Call regulator core suspend prepare and finish functions" [3].

Javier Martinez Canillas (5):
  regulator: of: Decrement refcount for suspend state nodes
  regulator: core: Add regulator mode and initial mode properties
  regulator: max77802: Document regulator operating modes
  regulator: max77802: Parse regulator operating mode properties
  ARM: dts: Configure regulators for suspend on exynos Peach boards

 .../devicetree/bindings/regulator/max77802.txt     | 33 +++++++++
 .../devicetree/bindings/regulator/regulator.txt    | 14 ++++
 arch/arm/boot/dts/exynos5420-peach-pit.dts         | 81 ++++++++++++++++++++++
 arch/arm/boot/dts/exynos5800-peach-pi.dts          | 81 ++++++++++++++++++++++
 drivers/regulator/max77802.c                       | 44 ++++++++++++
 drivers/regulator/of_regulator.c                   |  1 +
 6 files changed, 254 insertions(+)

Patch #1 is a trivial fix to of_get_regulation_constraints() where the
suspend state device node refcount was not decremented after usage.

Patch #2 adds the regulator-initial-mode and regulator-mode properties to the
generic regulator suspend state bindings.

Patch #3 documents the valid operating modes for the max77802 regulators.

Patch #4 adds the parse logic to fill the regulation constraints to change the
regulator operating modes by the core.

Patch #5 configure the regulators operating modes on Exynos Peach Chromebooks.

Best regards,
Javier

[0]: https://lkml.org/lkml/2014/10/8/331
[1]: https://lkml.org/lkml/2014/10/16/504
[2]: https://lkml.org/lkml/2014/10/10/161
[3]: http://www.spinics.net/lists/arm-kernel/msg369923.html
