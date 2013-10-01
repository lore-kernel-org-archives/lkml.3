Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab3JAO7K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 10:59:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:49898 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798Ab3JAO7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 10:59:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1013,1371106800"; 
   d="scan'208";a="386261037"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-gpio@vger.kernel.org
Cc: rjw@rjwysocki.net, Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>, Rob Landley <rob@landley.net>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 0/5] gpiolib: convert ACPI GPIO helpers to gpiod_ interfaces
Date: Tue,  1 Oct 2013 17:58:52 +0300
Message-Id: <1380639537-23406-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This series converts the ACPI GPIO helpers in gpiolib-acpi.c to use the new
and preferred GPIO descriptor based interface as suggested by the GPIO
subsystem maintainer.

The first patch is just a cosmetic fix to move acpi_gpiochip_free_interrupts()
closer to acpi_gpiochip_request_interrupts(). Patches [2-5/5] do the actual
conversion.

The series is based on the latest patches from Alexandre Courbot and I've
tested them on Intel Haswell based machine.

Please review.

Mika Westerberg (5):
  gpiolib / ACPI: move acpi_gpiochip_free_interrupts next to the request function
  gpiolib / ACPI: convert to gpiod interfaces
  gpiolib / ACPI: add ACPI support for gpiod_get_index()
  gpiolib / ACPI: allow passing GPIOF_ACTIVE_LOW for GpioInt resources
  gpiolib / ACPI: document the GPIO descriptor based interface

 Documentation/acpi/enumeration.txt |  22 +++++++
 drivers/gpio/gpiolib-acpi.c        | 129 ++++++++++++++++++-------------------
 drivers/gpio/gpiolib.c             |  20 ++++++
 include/linux/acpi_gpio.h          |  40 +++++++++---
 4 files changed, 138 insertions(+), 73 deletions(-)

-- 
1.8.4.rc3

