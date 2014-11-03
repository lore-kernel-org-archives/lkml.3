Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbaKCSMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 13:12:24 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38942 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbaKCSMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 13:12:23 -0500
From: Markus Pargmann <mpa@pengutronix.de>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        =?UTF-8?q?Krzysztof=20Koz=C5=82owski?= <k.kozlowski@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Markus Pargmann <mpa@pengutronix.de>
Subject: [PATCH v3 0/4] regulator: Fix core behaviour for gpio 0, remaining patches
Date: Mon,  3 Nov 2014 19:12:03 +0100
Message-Id: <1415038327-32616-1-git-send-email-mpa@pengutronix.de>
X-Mailer: git-send-email 2.1.1
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here are the remaining patches of the series. Version 3 contains some fixes for
the first three patches. I added another patch which fixes a problem I noticed
in the tps65090 driver.

Changes in v3:
 - Moved the ena_gpio_initialized initialization out of the loop for s2m/s5m
   drivers.
 - Fixed a of_node check in max8952
 - Fixed ena_gpio_initialized for the 'fixed' regulator to only be set for
   gpios from DT


Best regards,

Markus


Markus Pargmann (4):
  regulator: Set ena_gpio_initialized in regulator drivers
  regulator: fixed: Use gpio_is_valid
  regulator: gpio: Use gpio_is_valid
  regulator: tps65090: Fix gpio initialization

 drivers/regulator/arizona-ldo1.c       | 2 ++
 drivers/regulator/fixed.c              | 5 ++++-
 drivers/regulator/gpio-regulator.c     | 4 +++-
 drivers/regulator/max8952.c            | 2 ++
 drivers/regulator/s2mps11.c            | 1 +
 drivers/regulator/s5m8767.c            | 1 +
 drivers/regulator/tps65090-regulator.c | 4 ++++
 drivers/regulator/wm8994-regulator.c   | 6 ++++--
 8 files changed, 21 insertions(+), 4 deletions(-)

-- 
2.1.1

