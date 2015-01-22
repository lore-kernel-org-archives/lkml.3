Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbbAVPpw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 10:45:52 -0500
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:37184 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbbAVPpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 10:45:50 -0500
X-Greylist: delayed 393 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Jan 2015 10:45:50 EST
From: Chen-Yu Tsai <wens@csie.org>
To: Mark Brown <broonie@kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Chen-Yu Tsai <wens@csie.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v9 0/5] mfd: axp20x: add support for AXP202 and AXP209
Date: Thu, 22 Jan 2015 23:39:02 +0800
Message-Id: <1421941147-9682-1-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

This is v9 of the axp209 series. v9 changes the DT bindings per Lee's
recommendations. This introduces 3 new patches to update the regulator
driver and dtsi to use the new bindings.

The regulator patches are based on the axp209 topic branch from the
regulator tree, which atm is just the 2 patches I did to use the
regulator core DT parsing functions:

    regulator: axp20x: Migrate to regulator core's simplified DT parsing code
    regulator: axp20x: Fill regulators_node and of_match descriptor fields

So far, "x-powers,dcdc-workmode" is not used anywhere. "x-powers,dcdc-freq"
is only used in axp209.dtsi which was just introduced. It should be fairly
safe to change the bindings.

Lee, Mark, could you take a look at the new changes? If they're OK, could
you merge them through your respective trees?

Maxime, could you merge the axp209.dtsi patch after the others are merged?

Thank you!


Regards,
ChenYu


Changes since v8:

    - Dropped patches that were merged
    - Changed "x-powers,dcdc-workmode" to boolean flag
      "x-powers,dcdc-workmode-pwm", and default to auto when not present.
    - Use standard "clock-frequency" instead of custom "x-powers,dcdc-freq"
      and use HZ as unit.
    - Added missing ldo5 regulator node in DT binding example.
    - Added 2 patches to update regulator driver to new bindings.
    - Added patch to update axp209.dtsi to new bindings.


Carlo Caione (2):
  dt-bindings: add vendor-prefix for X-Powers
  mfd: AXP20x: Add bindings documentation

Chen-Yu Tsai (3):
  regulators: axp20x: Use "clock-frequency" property for dcdc work
    frequency
  regulators: axp20x: Change dcdc-workmode DT property to boolean flag
  ARM: sunxi: dts: axp209: Use clock-frequency for DC-DC work frequency

 Documentation/devicetree/bindings/mfd/axp20x.txt   | 102 +++++++++++++++++++++
 .../devicetree/bindings/vendor-prefixes.txt        |   1 +
 arch/arm/boot/dts/axp209.dtsi                      |   2 +-
 drivers/regulator/axp20x-regulator.c               |  33 +++----
 4 files changed, 121 insertions(+), 17 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/axp20x.txt

-- 
2.1.4

