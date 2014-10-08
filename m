Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbaJHNrr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 09:47:47 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60150 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756554AbaJHNrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 09:47:45 -0400
From: Markus Pargmann <mpa@pengutronix.de>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        =?UTF-8?q?Krzysztof=20Koz=C5=82owski?= <k.kozlowski@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Markus Pargmann <mpa@pengutronix.de>
Subject: [PATCH v2 0/4] regulator: Fix core behaviour for gpio 0
Date: Wed,  8 Oct 2014 15:47:04 +0200
Message-Id: <1412776028-15655-1-git-send-email-mpa@pengutronix.de>
X-Mailer: git-send-email 2.1.0
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In v2 of this series I renamed the added regulator_config field
'ena_gpio_valid' to 'ena_gpio_initialized'. We have a gpio_is_valid check in
the regulator core code, so no need to require a valid ena_gpio. It should
avoid a lot of gpio_is_valid checks in regulator drivers.

v2 is also backward compatible now, so if ena_gpio_initialized is false, it
will still handle gpios > 0. There are some more changes on the regulator
driver patches, which now do not set ena_gpio_initialized for pdata code.

This series fixes the handling of gpio 0 in the regulator framework.

Best regards,

Markus


Markus Pargmann (4):
  regulator: Add ena_gpio_initialized to regulator_config
  regulator: Set ena_gpio_initialized in regulator drivers
  regulator: fixed: Use gpio_is_valid
  regulator: gpio: Use gpio_is_valid

 drivers/regulator/arizona-ldo1.c       | 1 +
 drivers/regulator/core.c               | 3 ++-
 drivers/regulator/fixed.c              | 4 +++-
 drivers/regulator/gpio-regulator.c     | 4 +++-
 drivers/regulator/max8952.c            | 2 ++
 drivers/regulator/s2mps11.c            | 1 +
 drivers/regulator/s5m8767.c            | 1 +
 drivers/regulator/tps65090-regulator.c | 1 +
 drivers/regulator/wm8994-regulator.c   | 6 ++++--
 include/linux/regulator/driver.h       | 4 ++++
 10 files changed, 22 insertions(+), 5 deletions(-)

-- 
2.1.0

