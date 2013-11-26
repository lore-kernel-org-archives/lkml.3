Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab3KZKGF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 05:06:05 -0500
Received: from mga11.intel.com ([192.55.52.93]:50778 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755122Ab3KZKF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 05:05:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,773,1378882800"; 
   d="scan'208";a="440032059"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-acpi@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Rhyland Klein <rklein@nvidia.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Rob Landley <rob@landley.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/6] gpio / ACPI: convert users to gpiod_* and drop acpi_gpio.h
Date: Tue, 26 Nov 2013 12:05:44 +0200
Message-Id: <1385460350-17543-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.4.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Now that the mainline kernel has full ACPI support for the GPIO descriptor
interface we can get rid of ACPI specific GPIO functions in favor of GPIO
descriptor (gpiod_*) interfaces.

This series first converts the existing two users to this interface and
then modifies gpiolib and gpiolib-acpi so that the ACPI functions are only
called internally in drivers/gpio. We then remove the acpi_gpio.h and
require all users to use gpiod_* interfaces.

This is third version of the series. Changes to the previous version [1]:

 * Instead of adding temporary conversion from GPIO descriptors to numbers
   in rfkill-gpio.c we now first introduce a lookup table for paz00 and
   in the next patch convert the driver to use only GPIO descriptors.

 * Corrected a typo in subject of patch [3/6] "covert" -> "convert".

 * Corrected a typo in changelog of patch [5/6] "user" -> "use".

 * Dropped EXPORT_SYMBOL_GPL(acpi_get_gpiod_by_index) from patch [5/6] that
   was left there accidentally.

Since the patches in the series depend on each other I would propose this
to be merged via GPIO tree.

[1] http://www.spinics.net/lists/linux-acpi/msg47472.html (v2 of the series)

Heikki Krogerus (2):
  ARM: tegra: add gpiod_lookup table for paz00
  net: rfkill: gpio: convert to descriptor-based GPIO interface

Mika Westerberg (4):
  mmc: sdhci-acpi: convert to use GPIO descriptor API
  gpio / ACPI: register to ACPI events automatically
  gpio / ACPI: get rid of acpi_gpio.h
  Documentation / ACPI: update to GPIO descriptor API

 Documentation/acpi/enumeration.txt | 36 ++++--------------
 arch/arm/mach-tegra/board-paz00.c  |  7 ++++
 drivers/gpio/gpiolib-acpi.c        | 21 ++++++++---
 drivers/gpio/gpiolib.c             |  5 ++-
 drivers/gpio/gpiolib.h             | 46 +++++++++++++++++++++++
 drivers/mmc/host/sdhci-acpi.c      | 26 ++++++-------
 drivers/pinctrl/pinctrl-baytrail.c |  4 --
 include/linux/acpi_gpio.h          | 51 -------------------------
 net/rfkill/rfkill-gpio.c           | 77 +++++++++++++++++---------------------
 9 files changed, 125 insertions(+), 148 deletions(-)
 create mode 100644 drivers/gpio/gpiolib.h
 delete mode 100644 include/linux/acpi_gpio.h

-- 
1.8.4.3

