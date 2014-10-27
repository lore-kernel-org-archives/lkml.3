Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508AbaJ0IIi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 04:08:38 -0400
Received: from mga01.intel.com ([192.55.52.88]:33019 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbaJ0IIg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 04:08:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,794,1406617200"; 
   d="scan'208";a="621212285"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Ning Li <ning.li@intel.com>,
        Alan Cox <alan@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] pinctrl: Intel Cherryview/Braswell support
Date: Mon, 27 Oct 2014 10:08:28 +0200
Message-Id: <1414397312-94609-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[The previous series never reached LKML to misconfiguration in my mailer.
 Resending the whole series with LKML included.]

Hi,

This is a complete rewrite of the GPIO driver patch I sent previously. The
mail thread can be found here:

	http://marc.info/?l=linux-gpio&m=141079024403000&w=2

Outcome of that discussion was that instead of GPIO driver, we should have
a combined pinctrl/GPIO driver.

This patch series implements pinctrl/GPIO driver for Intel
Cherryview/Braswell. While there we decided to put all Intel pinctrl
drivers under drivers/pinctrl/intel/* and add an entry to MAINTAINERS. We
are expecting to have more pinctrl drivers in future for Intel hardware.

Mika Westerberg (4):
  gpio / ACPI: Add knowledge about pin controllers to acpi_get_gpiod()
  pinctrl: Move Intel Baytrail pinctrl driver under intel directory
  MAINTAINERS: Add entry for Intel pin controller drivers
  pinctrl: Add Intel Cherryview/Braswell pin controller support

 MAINTAINERS                                    |    6 +
 drivers/gpio/gpiolib-acpi.c                    |   62 +-
 drivers/pinctrl/Kconfig                        |   13 +-
 drivers/pinctrl/Makefile                       |    2 +-
 drivers/pinctrl/intel/Kconfig                  |   27 +
 drivers/pinctrl/intel/Makefile                 |    4 +
 drivers/pinctrl/{ => intel}/pinctrl-baytrail.c |    0
 drivers/pinctrl/intel/pinctrl-cherryview.c     | 1507 ++++++++++++++++++++++++
 8 files changed, 1605 insertions(+), 16 deletions(-)
 create mode 100644 drivers/pinctrl/intel/Kconfig
 create mode 100644 drivers/pinctrl/intel/Makefile
 rename drivers/pinctrl/{ => intel}/pinctrl-baytrail.c (100%)
 create mode 100644 drivers/pinctrl/intel/pinctrl-cherryview.c

-- 
2.1.1

