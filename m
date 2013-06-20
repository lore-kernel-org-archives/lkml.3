Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965310Ab3FTJ2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 05:28:32 -0400
Received: from multi.imgtec.com ([194.200.65.239]:6430 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965205Ab3FTJ2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 05:28:13 -0400
From: James Hogan <james.hogan@imgtec.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: <linux-kernel@vger.kernel.org>, James Hogan <james.hogan@imgtec.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>
Subject: [PATCH v3 0/4] Add TZ1090 pinctrl/gpio drivers
Date: Thu, 20 Jun 2013 10:26:26 +0100
Message-ID: <1371720391-21825-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01192__2013_06_20_10_28_01
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds GPIO and pin controller drivers for the TZ1090, for
both the general GPIOs/pins, and the low power (PDC) GPIOs/pins.

LinusW: Please consider taking these for v3.11. The pinctrl ones need to
go via your pinctrl tree due to the dependence on the new pinconf
bindings.

Changes in v3:
 - separated from irq-imgpdc and removed arch/metag changes to allow
   these patches to go upstream separately via the pinctrl[/gpio] trees
   (particularly the pinctrl drivers depend on the new pinconf DT
   bindings).
 - some s/unsigned/unsigned int/.
 - some s/unsigned int/bool/ and use of BIT().
 - pinctrl-tz1090*: switch to generic pinconfig DT bindings and
   pinconf_generic_dump_config.
 - pinctrl-tz1090*: use tz1090, prefix for pins and function in DT
   bindings.
 - pinctrl-tz1090*: make internal functions static.
 - pinctrl-tz1090*: move initcall from postcore to arch.
 - gpio-tz1090*: refer to <dt-bindings/gpio/gpio.h> and
   <dt-bindings/interrupt-controller/irq.h> flags in bindings.
 - gpio-tz1090*: move initcall from postcore to subsys.
 - gpio-tz1090: add REG_ prefix to some constants for consistency.
 - gpio-tz1090: add comment to explain tz1090_gpio_irq_next_edge
   cunningness.

Changes in v2:

There've been plenty of changes since v1 (thanks for all the feedback!)
so I think it's time for v2. I believe the only feedback not yet
addressed is changing irq-imgpdc driver to use generic irqchip.

 - rebased on v3.10-rc2
 - removed arch/metag/soc/ directory
 - removed arch/metag/include/asm/soc-tz1090/gpio.h
 - irq-imgpdc: use cached versions of irq_en and irq_route registers
 - irq-imgpdc: switch to using raw_spinlock
 - irq-imgpdc: (not had time to switch to generic irqchip yet)
 - add drive strength to generic pinconf debugfs output (patch 4)
 - add BIAS_BUS_HOLD generic pinconf (patch 5)
 - pinctrl-tz1090: switched to generic pinconf (a previous patch adds
   the BIAS_BUS_HOLD generic pinconf)
 - pinctrl-tz1090: changed device tree bindings to more closely match
   generic pinconf (separate tristate, pull-up, pull-down, bus-hold
   flags instead of pull=<X>, drive-strength measured in mA)
 - pinctrl-tz1090: removed "select" pinconf. Instead pins in a pin group
   have their own individual pin groups and can be individually muxed.
   Different pins in same pin mux group muxed to different functions is
   disallowed. Pin switched to peripheral mode when mux enabled.
 - pinctrl-tz1090: make use of BIT() from linux/bitops.h
 - pinctrl-tz1090: add a whole bunch of comments
 - gpio-tz1090: remove references to Linux flags in dt bindings
 - gpio-tz1090: make use of BIT() from linux/bitops.h
 - gpio-tz1090: make register accessors inline to match pinctrl
 - gpio-tz1090: update gpio-ranges to use 3 cells after recent ABI
   breakage
 - pinctrl-tz1090-pdc: switched to generic pinconf (a previous patch
   adds the BIAS_BUS_HOLD generic pinconf)
 - pinctrl-tz1090-pdc: changed device tree bindings to more closely
   match generic pinconf (separate tristate, pull-up, pull-down,
   bus-hold flags instead of pull=<X>, drive-strength measured in mA)
 - pinctrl-tz1090-pdc: make use of BIT() from linux/bitops.h
 - pinctrl-tz1090-pdc: add a whole bunch of comments
 - gpio-tz1090-pdc: remove references to Linux flags in dt bindings
 - gpio-tz1090-pdc: make use of BIT() from linux/bitops.h
 - gpio-tz1090-pdc: make register accessors inline to match pinctrl
 - gpio-tz1090-pdc: update gpio-ranges to use 3 cells after recent ABI
   breakage

Cc: Grant Likely <grant.likely@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-doc@vger.kernel.org

James Hogan (4):
  pinctrl-tz1090: add TZ1090 pinctrl driver
  gpio-tz1090: add TZ1090 gpio driver
  pinctrl-tz1090-pdc: add TZ1090 PDC pinctrl driver
  gpio-tz1090-pdc: add TZ1090 PDC gpio driver

 .../devicetree/bindings/gpio/gpio-tz1090-pdc.txt   |   43 +
 .../devicetree/bindings/gpio/gpio-tz1090.txt       |   87 +
 .../bindings/pinctrl/img,tz1090-pdc-pinctrl.txt    |  130 ++
 .../bindings/pinctrl/img,tz1090-pinctrl.txt        |  232 +++
 drivers/gpio/Kconfig                               |   14 +
 drivers/gpio/Makefile                              |    2 +
 drivers/gpio/gpio-tz1090-pdc.c                     |  243 +++
 drivers/gpio/gpio-tz1090.c                         |  633 ++++++
 drivers/pinctrl/Kconfig                            |   12 +
 drivers/pinctrl/Makefile                           |    2 +
 drivers/pinctrl/pinctrl-tz1090-pdc.c               | 1029 ++++++++++
 drivers/pinctrl/pinctrl-tz1090.c                   | 2077 ++++++++++++++++++++
 12 files changed, 4504 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-tz1090-pdc.txt
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-tz1090.txt
 create mode 100644 Documentation/devicetree/bindings/pinctrl/img,tz1090-pdc-pinctrl.txt
 create mode 100644 Documentation/devicetree/bindings/pinctrl/img,tz1090-pinctrl.txt
 create mode 100644 drivers/gpio/gpio-tz1090-pdc.c
 create mode 100644 drivers/gpio/gpio-tz1090.c
 create mode 100644 drivers/pinctrl/pinctrl-tz1090-pdc.c
 create mode 100644 drivers/pinctrl/pinctrl-tz1090.c

-- 
1.8.1.2


