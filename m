Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927Ab3FYO2H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 10:28:07 -0400
Received: from multi.imgtec.com ([194.200.65.239]:39208 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113Ab3FYO2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 10:28:05 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>,
        Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Rob Herring" <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>
Subject: [PATCH v4 0/3] Add TZ1090 pinctrl/gpio drivers
Date: Tue, 25 Jun 2013 15:27:42 +0100
Message-ID: <1372170465-28450-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01192__2013_06_25_15_28_02
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds GPIO drivers for the TZ1090, for both the general
GPIOs, and the low power (PDC) GPIOs.

LinusW: Please consider taking the first 2 patches for v3.11. Patch 3
converts gpio-tz1090 (from patch 1) to use generic irqchip, but it
depends on code currently in tip/irq/core (for generic irqchip to work
with linear irq domains). Does it just make sense to apply that patch
later (i.e. for v3.12 or something)?

Changes in v4:
 - fix typos in DT bindings compatible properties
 - reference Documentation/devicetree/bindings/gpio/gpio.txt in
   gpio-ranges description in DT bindings
 - fix gpio-ranges examples in DT bindings (it must now have 3 cells)
 - gpio-tz1090: use of_property_read_u32 instead of of_get_property
 - gpio-tz1090: convert to use generic irqchip callbacks
 - gpio-tz1090: convert to use irq_setup_alt_chip() instead of
   __irq_set_handler_locked()

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

James Hogan (3):
  gpio-tz1090: add TZ1090 gpio driver
  gpio-tz1090-pdc: add TZ1090 PDC gpio driver
  gpio-tz1090: convert to use generic irqchip

 .../devicetree/bindings/gpio/gpio-tz1090-pdc.txt   |  45 ++
 .../devicetree/bindings/gpio/gpio-tz1090.txt       |  88 +++
 drivers/gpio/Kconfig                               |  15 +
 drivers/gpio/Makefile                              |   2 +
 drivers/gpio/gpio-tz1090-pdc.c                     | 243 +++++++++
 drivers/gpio/gpio-tz1090.c                         | 606 +++++++++++++++++++++
 6 files changed, 999 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-tz1090-pdc.txt
 create mode 100644 Documentation/devicetree/bindings/gpio/gpio-tz1090.txt
 create mode 100644 drivers/gpio/gpio-tz1090-pdc.c
 create mode 100644 drivers/gpio/gpio-tz1090.c

-- 
1.8.1.2


