Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbaE1RL2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 13:11:28 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46272 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751419AbaE1RL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 13:11:27 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: carlo@caione.org, Boris Brezillon <boris@free-electrons.com>,
        Mark Brown <broonie@kernel.org>, lgirdwood@gmail.com,
        lee.jones@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH 0/5] regulator: Enhance AXP209 DT support
Date: Wed, 28 May 2014 19:11:04 +0200
Message-Id: <1401297069-7423-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

This patchset modifies the regulator core and axp209 regulator driver
to be able to set in each regulators sub-node the supply, that should
be possible, given that it's documented as such in the bindings, but
is not at the moment, since whenever looking up the supply in the DT,
of_get_regulator will always look into the parent's device of_node
pointer.

This leads to a common pattern accross the regulators to have multiple
supply in the main device node, while it would be more intuitive yet
follow the documented bindings to look into the regulator sub-nodes
first.

Any comments are, of course, welcome.
Maxime

Maxime Ripard (5):
  regulator: Allow to pass the device node to regulator_dev_lookup
  regulator: Pass the config device node to regulator_dev_lookup
  regulator: axp20x: Update the bindings to use a local parent regulator
  mfd: axp209x: Drop the parent supplies field
  ARM: sun7i: cubieboard2: Enable the AXP209

 Documentation/devicetree/bindings/mfd/axp20x.txt | 22 +++++--------
 arch/arm/boot/dts/sun7i-a20-cubieboard2.dts      | 41 +++++++++++++++++++++++
 drivers/mfd/axp20x.c                             | 11 -------
 drivers/regulator/axp20x-regulator.c             | 42 ++++++++++++++----------
 drivers/regulator/core.c                         | 16 ++++++---
 5 files changed, 87 insertions(+), 45 deletions(-)

-- 
1.9.3

