Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbaCJMzC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 08:55:02 -0400
Received: from mga11.intel.com ([192.55.52.93]:61169 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628AbaCJMy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 08:54:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,623,1389772800"; 
   d="scan'208";a="489123988"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Alexandre Courbot <gnurou@gmail.com>, Lan Tianyu <tianyu.lan@intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Alan Cox <alan.cox@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v2 0/5] gpio / ACPI: Rework ACPI GPIO events and add support for operation regions
Date: Mon, 10 Mar 2014 14:54:49 +0200
Message-Id: <1394456094-21671-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is second revision of the patch series. The first version is available
for example here [1].

This series tries to add support for two new ACPI 5.0 features that were
either missing on incomplete in the current Linux kernel:

 * ACPI GPIO signaled events
 * ACPI GPIO operation regions

The current ACPI GPIO support code already added preliminary support for
GPIO signaled events but at the time we didn't have real hardware with real
GPIO triggered events so it was never properly tested. Now there are
devices like Asus T100TA transformer that uses these events so we were able
to see that the ASL code is being executed when a GPIO interrupt is
triggered.

Changes to the previous version:

 * Moved module refcount manipulation to gpiod_request().
 * Call achip acpi_gpio instead.
 * Fold patches [2,4/6] into one [2/5].
 * Update changelog for [3/5] to state that no functional changes, it is
   rename only.
 * Explain ACPI operations regions a bit better in [5/5].

These patches apply on top of two patches from Alexandre Courbot [2] which
introduce gpiochip_get_desc() function.

[1] http://linux-kernel.2935.n7.nabble.com/PATCH-0-6-gpio-ACPI-Rework-ACPI-GPIO-events-and-add-support-for-operation-regions-td811694.html
[2] https://lkml.org/lkml/2014/2/9/24

Mika Westerberg (5):
  gpiolib: Allow GPIO chips to request their own GPIOs
  gpio / ACPI: Allocate ACPI specific data directly in acpi_gpiochip_add()
  gpio / ACPI: Rename acpi_gpio_evt_pin to acpi_gpio_event
  gpio / ACPI: Rework ACPI GPIO event handling
  gpio / ACPI: Add support for ACPI GPIO operation regions

 drivers/gpio/gpiolib-acpi.c | 465 ++++++++++++++++++++++++++++++++------------
 drivers/gpio/gpiolib.c      | 103 +++++++---
 drivers/gpio/gpiolib.h      |   3 +
 3 files changed, 421 insertions(+), 150 deletions(-)

-- 
1.9.0

