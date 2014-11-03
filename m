Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbaKCLBv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 06:01:51 -0500
Received: from mga09.intel.com ([134.134.136.24]:41694 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628AbaKCLBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 06:01:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,307,1413270000"; 
   d="scan'208";a="630241760"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Ning Li <ning.li@intel.com>,
        Alan Cox <alan@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] pinctrl: Intel Cherryview/Braswell support
Date: Mon,  3 Nov 2014 13:01:31 +0200
Message-Id: <1415012493-134561-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is second version of the patch series adding pinctrl/GPIO support
for Intel Braswell and Cherrryview. The previous version can be found here:

https://lkml.org/lkml/2014/10/27/118

I've dropped patches [2/4] and [3/4] as they are already applied to the
pinctrl tree.

Changes to the previous version:

[1/2] - Removed unnecessary cast and added Rafael's ACK.

[2/2] - Use Ohms instead of kOhms in pin configuration.
      - Change chv_config_set_pull() to be not so convoluted.
      - Remove locking when we just read single register. This is not needed.
      - Use BIT() instead of (1 << something)

Mika Westerberg (2):
  gpio / ACPI: Add knowledge about pin controllers to acpi_get_gpiod()
  pinctrl: Add Intel Cherryview/Braswell pin controller support

 drivers/gpio/gpiolib-acpi.c                |   62 +-
 drivers/pinctrl/intel/Kconfig              |   12 +
 drivers/pinctrl/intel/Makefile             |    1 +
 drivers/pinctrl/intel/pinctrl-cherryview.c | 1519 ++++++++++++++++++++++++++++
 4 files changed, 1591 insertions(+), 3 deletions(-)
 create mode 100644 drivers/pinctrl/intel/pinctrl-cherryview.c

-- 
2.1.1

