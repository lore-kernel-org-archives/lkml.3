Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350AbaJPDwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 23:52:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:62064 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbaJPDwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 23:52:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="401039171"
From: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mika Westerberg <mika.westerberg@intel.com>,
        Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>,
        GPIO Subsystem Mailing List <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Denis Turischev <denis.turischev@compulab.co.il>
Subject: [PATCHv3 0/3] Enable Quark X1000 support in gpio-sch
Date: Thu, 16 Oct 2014 11:51:12 +0800
Message-Id: <1413431475-12799-1-git-send-email-rebecca.swee.fun.chang@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a revised version for enabling Quark X1000 in gpio-sch.

Change log for V3:
The patches had been rebased on "devel" branch and it has dependency on
Mika Westerberg's commit at: https://lkml.org/lkml/2014/9/16/213

Patch 3:
- Change variable type of irq_support to bool.
- Update error message and remove redundant code.
- Revert gpiochip_remove() to avoid it to return a value.

The changes had been verified by passing build test and functional test
on Intel Galileo board.

Thank you.
Regards,
Rebecca

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
 drivers/gpio/gpio-sch.c |  353 ++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 311 insertions(+), 53 deletions(-)

-- 
1.7.9.5

