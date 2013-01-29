Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038Ab3A2Oxy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 09:53:54 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:52241 "HELO
	vsp-authed-02-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754224Ab3A2Oxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 09:53:53 -0500
From: Andreas Larsson <andreas@gaisler.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        software@gaisler.com
Subject: [PATCH v2 0/6] of, of_gpio, of_spi: Bugfix and improve of_parse_phandle_with_args, of_gpio_named_count and of_spi_register_master
Date: Tue, 29 Jan 2013 15:53:37 +0100
Message-Id: <1359471223-4794-1-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series fixes a bug where of_gpio_named count relied upon a return
value that was no longer returned from of_parse_phandle_with_args and adds the
possibility for of_gpio_named_count to return error values.

In addition, for of_spi_register_master it fixes a bug, adds documentation,
adds fetching of gpio flags and initializes gpio values to be consistent with
return values from of_parse_phandle_with_args.

Tested on sparc (excluding the changes to drivers gpio-fan, i2c-mux-gpio,
matrix_keypad, mdio-mux-gpio, spi-mpc52xx, spi-oc-tiny, spi-ppc4xx, selftest). 
Compile tested on x86, arm and ppc (all changed source files, when appropriate
for platform)

Changes since v1:
- PATCH 2/6: Handle error return values from calls to of_gpio_count

Andreas Larsson (6):
  of: Return -EEXIST from of_parse_phandle_with_args for holes in
    phandle list
  of: Return -ENXIO from of_parse_phandle_with_args for too large index
    and return errors from of_gpio_named_count
  of_spi: Initialize cs_gpios properly
  of_spi: Document cs_gpios and cs_gpio in kernel-doc
  of_spi: Add fetching of of_gpio flags to of_spi_register_master
  of_spi: Initialize cs_gpios and cs_gpio with -EEXIST

 Documentation/devicetree/bindings/spi/spi-bus.txt |    3 +-
 drivers/gpio/gpiolib-of.c                         |    8 +++--
 drivers/hwmon/gpio-fan.c                          |    6 ++--
 drivers/i2c/muxes/i2c-mux-gpio.c                  |    3 +-
 drivers/input/keyboard/matrix_keypad.c            |    2 +-
 drivers/net/phy/mdio-mux-gpio.c                   |    2 +-
 drivers/of/base.c                                 |    9 +++--
 drivers/of/selftest.c                             |    2 +-
 drivers/spi/spi-fsl-spi.c                         |    4 ++-
 drivers/spi/spi-mpc52xx.c                         |    5 +++
 drivers/spi/spi-oc-tiny.c                         |    4 ++-
 drivers/spi/spi-ppc4xx.c                          |    6 +++-
 drivers/spi/spi.c                                 |   40 ++++++++++++++++-----
 include/linux/spi/spi.h                           |   10 +++++
 14 files changed, 78 insertions(+), 26 deletions(-)

