Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751163AbaDOHWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 03:22:18 -0400
Received: from mirror2.csie.ntu.edu.tw ([140.112.30.76]:36234 "EHLO
	mirror2.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983AbaDOHWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 03:22:14 -0400
From: Chen-Yu Tsai <wens@csie.org>
To: Linus Walleij <linus.walleij@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Chen-Yu Tsai <wens@csie.org>, Arnd Bergmann <arnd@arndb.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-gpio@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: [PATCH 0/7] net: rfkill: gpio: Add device tree support
Date: Tue, 15 Apr 2014 14:41:34 +0800
Message-Id: <1397544101-18135-1-git-send-email-wens@csie.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

This patch series adds device tree support to rfkill-gpio, and
fixes some issues I ran into. This is so we can define and control
RF devices through the device tree, such as the Broadcom BCM20710
UART-based Bluetooth device found on the CubieTruck.

The series is based on Heikki's rfkill-gpio cleanup patches [1],
applied on 3.15-rc1. Kudos to Heikki for paving the way.

 [1] https://lkml.org/lkml/2014/4/1/451

The device tree bindings are much better than was defined in the
RFC series I sent a few months earlier [2], due to cleanups by
Heikki, and named gpios (via gpio-names) implemented in the first
two patches. Hopefully this will satisfy everyone.

 [2] https://lkml.org/lkml/2014/1/17/31

The CubieTruck uses a non-default clock rate oscillator for the
BCM20710 device. As the datasheet states, a precise 32.768 KHz
low power clock must be provided at power on for the device to
detect the correct clock rate of the main oscillator. Hence the
need for the "clock-frequency" property.

The first 2 patches should go through the gpio tree. The 4 rfkill-gpio
patches should go through the same tree that Heikki's patches are
in. Maxime, can you take the last one?

A big thanks to everyone who gave reviews and suggestions.


Changes since RFC:

  - Dropped gpio name buffer fix patch (not needed after cleanup patches)
  - New gpios/gpio-names support for device trees
  - Simplify device tree bindings due to name cleanup and gpio-names
    support


Cheers

ChenYu

Chen-Yu Tsai (7):
  gpiolib: gpiolib-of: Implement device tree gpio-names based lookup
  gpiolib: Support purely name based gpiod lookup in device trees
  net: rfkill: gpio: use clk_prepare_enable/clk_disable_unprepare
  net: rfkill: gpio: fix reversed clock enable state
  net: rfkill: gpio: add device tree support
  net: rfkill: gpio: add clock-frequency device tree property
  ARM: sun7i: cubietruck: enable bluetooth module

 .../devicetree/bindings/rfkill/rfkill-gpio.txt     | 26 ++++++++++++
 arch/arm/boot/dts/sun7i-a20-cubietruck.dts         | 25 +++++++++++
 drivers/gpio/gpiolib-of.c                          | 48 ++++++++++++++++++++++
 drivers/gpio/gpiolib.c                             |  9 +++-
 include/linux/of_gpio.h                            |  3 ++
 net/rfkill/rfkill-gpio.c                           | 34 +++++++++++++--
 6 files changed, 140 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/rfkill/rfkill-gpio.txt

-- 
1.9.1

