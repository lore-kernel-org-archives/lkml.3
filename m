Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603AbaBDP7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 10:59:22 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:45271 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbaBDP7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 10:59:19 -0500
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Cc: Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Chris Ball <chris@printf.net>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 00/17] amba: PM fixups for amba bus and some amba drivers
Date: Tue,  4 Feb 2014 16:58:41 +0100
Message-Id: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset fixes the PM problems you yet when combining CONFIG_PM_SLEEP and
CONFIG_PM_RUNTIME. In principle these drivers did not manage to put it's devices
into low power state at system suspend, which then this patchset intend to fix.

Both the drivers and the amba bus converts to the new SET_PM_RUNTIME_PM_OPS
macro while setting up the runtime PM callbacks, which is intended to be used
for solving these kind of issues.

The fixes for the amba bus needs to be merged prior to the other, thus I think
it could make sense to merge this complete patchset through Russell's tree,
if he and the other maintainers think this is okay.

Ulf Hansson (17):
  amba: Let runtime PM callbacks be available for CONFIG_PM
  amba: Add late and early PM callbacks
  mmc: mmci: Mask IRQs for all variants during runtime suspend
  mmc: mmci: Let runtime PM callbacks be available for CONFIG_PM
  mmc: mmci: Put the device into low power state at system suspend
  spi: pl022: Let runtime PM callbacks be available for CONFIG_PM
  spi: pl022: Don't ignore power domain and amba bus at system suspend
  spi: pl022: Fully gate clocks at request inactivity
  spi: pl022: Simplify clock handling
  spi: pl022: Remove redundant pinctrl to default state in probe
  i2c: nomadik: Convert to devm functions
  i2c: nomadik: Remove redundant call to pm_runtime_disable
  i2c: nomadik: Leave probe with the device in active state
  i2c: nomadik: Fixup deployment of runtime PM
  i2c: nomadik: Convert to late and early system PM callbacks
  i2c: nomadik: Remove busy check for transfers at suspend late
  i2c: nomadik: Fixup system suspend

 drivers/amba/bus.c               |   10 ++-
 drivers/i2c/busses/i2c-nomadik.c |  146 ++++++++++++++++++--------------------
 drivers/mmc/host/mmci.c          |   72 ++++++++++---------
 drivers/spi/spi-pl022.c          |   95 +++++++++++--------------
 4 files changed, 159 insertions(+), 164 deletions(-)

-- 
1.7.9.5

