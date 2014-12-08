Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584AbaLHJkD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 04:40:03 -0500
Received: from mga01.intel.com ([192.55.52.88]:11355 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753410AbaLHJj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 04:39:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,537,1413270000"; 
   d="scan'208";a="634337763"
From: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@intel.com>,
        Alexandre Courbot <gnurou@gmail.com>
Cc: GPIO Subsystem Mailing List <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        denis.turischev@compulab.co.il,
        Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Subject: [PATCHv5 0/2] Enable Quark X1000 support in gpio-sch
Date: Mon,  8 Dec 2014 17:38:08 +0800
Message-Id: <1418031490-17716-1-git-send-email-rebecca.swee.fun.chang@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This is a revised version for enabling Quark X1000 support in gpio-sch.
This version of patch series had changed according to the feedback provided
by Alexandre and Linus.

Change log for V5:
Patch 1:
- Change variable curr_dirs to reg_val in order to make driver code easier to
  understand.

Patch 3:
- Dropped patch 3 for now. We need to re-design the driver's IRQ implementation.

The patches need to be patched on top of Mika Westerberg's commit at:
gpio: sch: Consolidate core and resume banks
http://marc.info/?l=linux-kernel&m=141392647225885&w=2

The patches has been verifed and tested working on Galileo Board. GPIO sysfs
was able to export gpio pins and changing pin direction. GPIO values were
able to controlled. One of the GPIO pins which is connected to on-board LED
was used to test GPIO functionality. We are able to turn the LED on/off by
changing the pin direction and pin value.

Please help to review the patches once again and thanks for all the review
comments. Your comments are valuable to me and help me to gain more in this
Open Source community as I'm quite a newbie in this area. Thanks for your
patience.

Regards,
Rebecca

Change log for V4:
Patch 1:
- Removed redundant/duplicated functions of sch_gpio_register_set() and
  sch_gpio_register_clear(). The function call had been replaced by
  sch_gpio_reg_set(gc, gpio, reg, 1) in place of sch_gpio_register_set() and
  sch_gpio_reg_set(gc, gpio, reg, 0) for sch_gpio_register_clear().
- Resolved double spinlock issue caught by Alexandre.

Patch 3:
- Dropped the usage of "if" block that checking irq_data struct
- Restructured the irq detect by using platform_get_irq(pdev, 0) instead of
  platform_get_resource(pdev, IORESOURCE_IRQ, 0) to get IRQ resources from
  MFD LPS-SCH.

Change log for V3:
Patch 3:
- Change variable type of irq_support to bool.
- Update error message and remove redundant code.
- Revert gpiochip_remove() to avoid it to return a value.

Change log for V2:
Patch 1:
- Move sch_gpio_get() and sch_gpio_set() to avoid forward declaration.
- Changed sch_gpio_enable()/sch_gpio_disable() to sch_gpio_register_set()/
  sch_gpio_register_clear().

Patch 3:
- Changed all sch_gpio_enable()/sch_gpio_disable() to sch_gpio_register_set()/
  sch_gpio_register_clear().

Version 1:
Initial version.

Chang Rebecca Swee Fun (2):
  gpio: sch: Consolidate similar algorithms
  gpio: sch: Add support for Intel Quark X1000 SoC

 drivers/gpio/Kconfig    | 11 +++++--
 drivers/gpio/gpio-sch.c | 87 +++++++++++++++++++------------------------------
 2 files changed, 43 insertions(+), 55 deletions(-)

-- 
1.9.1

