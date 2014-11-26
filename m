Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167AbaKZEsP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 23:48:15 -0500
Received: from mga02.intel.com ([134.134.136.20]:60465 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055AbaKZEsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 23:48:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,460,1413270000"; 
   d="scan'208";a="614155568"
From: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: GPIO Subsystem Mailing List <linux-gpio@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@intel.com>,
        Denis Turischev <denis.turischev@compulab.co.il>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: [PATCHv4 0/3] Enable Quark X1000 support in gpio-sch
Date: Wed, 26 Nov 2014 12:47:57 +0800
Message-Id: <1416977280-27319-1-git-send-email-rebecca.swee.fun.chang@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This is a revised version for enabling Quark X1000 support in gpio-sch.
This version of patch series had changed according to the feedback provided
by Alexandre and Mika.

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

The patches need to be patched on top of Mika Westerberg's commit at:
gpio: sch: Consolidate core and resume banks
http://marc.info/?l=linux-kernel&m=141392647225885&w=2

The patches has been verifed and tested working on Galileo Board. GPIO sysfs
was able to export gpio pins and changing pin direction. GPIO values were
able to controlled and interrupt was enabled.

Please help to review the patches so that we can make it to upstream kernel
as soon as possible. Thanks for all the review comments during this period of
review cycle.

Regards,
Rebecca

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

Chang Rebecca Swee Fun (3):
  gpio: sch: Consolidate similar algorithms
  gpio: sch: Add support for Intel Quark X1000 SoC
  gpio: sch: Enable IRQ support for Quark X1000

 drivers/gpio/Kconfig    |   11 +-
 drivers/gpio/gpio-sch.c |  316 ++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 266 insertions(+), 61 deletions(-)

-- 
1.7.9.5

