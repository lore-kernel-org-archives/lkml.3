Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab3JJIBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 04:01:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:53682 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754224Ab3JJIBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 04:01:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1070,1371106800"; 
   d="scan'208";a="390951847"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-gpio@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>, Rob Landley <rob@landley.net>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v2 0/5] gpiolib: convert ACPI gpio helpers to gpiod_ interfaces
Date: Thu, 10 Oct 2013 11:01:06 +0300
Message-Id: <1381392071-21407-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is an updated version of the patches that convert ACPI GPIO helpers to
the new gpiod_ interfaces. The previous version can be seen here:

 http://www.spinics.net/lists/linux-acpi/msg46542.html

Changes to the previous version:
 * Added check that pin is in range of available pins in acpi_get_gpiod()
 * Dropped acpi_get_gpio()
 * Added acks from Rafael and Alexandre

We still have acpi_get_gpio(d)_by_index() exported outside of gpiolib-acpi.c
but the plan is to get rid of acpi_gpio.h completely in near future.

The series is based on the latest gpiod_ patches from Alexandre Courbot and
tested on Intel Haswell machine.

Mika Westerberg (5):
  gpiolib / ACPI: move acpi_gpiochip_free_interrupts next to the request function
  gpiolib / ACPI: convert to gpiod interfaces
  gpiolib / ACPI: add ACPI support for gpiod_get_index()
  gpiolib / ACPI: allow passing GPIOF_ACTIVE_LOW for GpioInt resources
  gpiolib / ACPI: document the GPIO descriptor based interface

 Documentation/acpi/enumeration.txt |  26 ++++++--
 drivers/gpio/gpiolib-acpi.c        | 129 +++++++++++++++++++------------------
 drivers/gpio/gpiolib.c             |  20 ++++++
 include/linux/acpi_gpio.h          |  31 +++++----
 4 files changed, 127 insertions(+), 79 deletions(-)

-- 
1.8.4.rc3

