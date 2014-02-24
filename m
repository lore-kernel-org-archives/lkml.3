Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbaBXQA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 11:00:29 -0500
Received: from mga11.intel.com ([192.55.52.93]:31272 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181AbaBXQA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 11:00:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,535,1389772800"; 
   d="scan'208";a="487165097"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Alexandre Courbot <gnurou@gmail.com>, Lan Tianyu <tianyu.lan@intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Alan Cox <alan.cox@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 0/6] gpio / ACPI: Rework ACPI GPIO events and add support for operation regions
Date: Mon, 24 Feb 2014 18:00:05 +0200
Message-Id: <1393257611-18031-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.9.0.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series tries to add what is missing in current Linux ACPI GPIO
support. There are two new features that were introduced with ACPI 5.0: 

 * ACPI GPIO signaled events
 * ACPI GPIO operation regions

The current ACPI GPIO support code already added preliminary support for
GPIO signaled events but at the time we didn't have real hardware with real
GPIO triggered events so it was never properly tested. Now there are
devices like Asus T100TA transformer that uses these events so we were able
to see that the ASL code is being executed when a GPIO interrupt is
triggered.

Patches [3,4/6] Rework the ACPI GPIO signaled event support.

Support for GPIO operation regions is a new thing (well, kind of, it was
tried already once [1] but never got further from that). The idea here is
that the ASL code can toggle GPIOs via help of ACPI enabled Linux GPIO
driver. Implementation is in Patch [6/6].

These patches are based on two patches from Alexandre Courbot [2] which
introduce gpiochip_get_desc() function.

[1] http://www.spinics.net/lists/linux-acpi/msg46230.html
[2] https://lkml.org/lkml/2014/2/9/24

Mika Westerberg (6):
  gpiolib: Allow GPIO chips to request their own GPIOs
  gpio / ACPI: Allocate ACPI specific data directly in acpi_gpiochip_add()
  gpio / ACPI: Rename acpi_gpio_evt_pin to acpi_gpio_event
  gpio / ACPI: Embed events list directly into struct acpi_gpio_chip
  gpio / ACPI: Rework ACPI GPIO event handling
  gpio / ACPI: Add support for ACPI GPIO operation regions

 drivers/gpio/gpiolib-acpi.c | 465 ++++++++++++++++++++++++++++++++------------
 drivers/gpio/gpiolib.c      |  60 +++++-
 drivers/gpio/gpiolib.h      |   3 +
 3 files changed, 398 insertions(+), 130 deletions(-)

-- 
1.9.0.rc3

