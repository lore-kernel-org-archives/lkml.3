Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbaAHKlW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 05:41:22 -0500
Received: from mga01.intel.com ([192.55.52.88]:12595 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755069AbaAHKlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 05:41:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,623,1384329600"; 
   d="scan'208";a="455354071"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-acpi@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Rhyland Klein <rklein@nvidia.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>, Rob Landley <rob@landley.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/4] gpio / ACPI: convert users to gpiod_* and drop acpi_gpio.h
Date: Wed,  8 Jan 2014 12:40:53 +0200
Message-Id: <1389177657-29266-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is fourth revision of the patch series. The previous version can be
found here [1].

We convert the remaining user (sdhci-acpi) to use the GPIO descriptor API
and get rid for ACPI specific GPIO helpers in favor of the new GPIO
descriptor API.

Changes to v3:

 * Dropped patches 1 and 2 as they got merged already.
 * Rebased on top of latest linux-gpio.git devel -branch.
 * Moved patch [4/4] in previous version to be the first in this version.

[1] https://lkml.org/lkml/2013/11/26/104

Mika Westerberg (4):
  gpio / ACPI: register to ACPI events automatically
  mmc: sdhci-acpi: convert to use GPIO descriptor API
  gpio / ACPI: get rid of acpi_gpio.h
  Documentation / ACPI: update to GPIO descriptor API

 Documentation/acpi/enumeration.txt | 36 ++++++---------------------
 drivers/gpio/gpiolib-acpi.c        | 21 +++++++++++-----
 drivers/gpio/gpiolib.c             |  5 +++-
 drivers/gpio/gpiolib.h             | 46 ++++++++++++++++++++++++++++++++++
 drivers/mmc/host/sdhci-acpi.c      | 26 +++++++++----------
 drivers/pinctrl/pinctrl-baytrail.c |  4 ---
 include/linux/acpi_gpio.h          | 51 --------------------------------------
 7 files changed, 84 insertions(+), 105 deletions(-)
 create mode 100644 drivers/gpio/gpiolib.h
 delete mode 100644 include/linux/acpi_gpio.h

-- 
1.8.5.2

