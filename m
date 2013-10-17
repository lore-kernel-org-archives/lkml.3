Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236Ab3JQRXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 13:23:46 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:7832 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076Ab3JQRXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 13:23:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 17 Oct 2013 10:19:14 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>, <gnurou@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v3 0/3] New descriptor-based GPIO interface
Date: Thu, 17 Oct 2013 10:21:35 -0700
Message-ID: <1382030498-23465-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This version should merge as-is in your tree (I hope!). A patch for
documentation will follow soon.

Changes since v2:
- rebased on top of Linus' for-next branch
- exported new gpiod_(un)lock_as_irq() functions in driver.h
- squashed a fix for a compilation error

Alexandre Courbot (3):
  gpiolib: export descriptor-based GPIO interface
  gpiolib: port of_ functions to use gpiod
  gpiolib: add gpiod_get() and gpiod_put() functions

 drivers/gpio/devres.c         |  83 ++++++
 drivers/gpio/gpiolib-of.c     |  28 +-
 drivers/gpio/gpiolib.c        | 623 +++++++++++++++++++++++++++++-------------
 include/asm-generic/gpio.h    | 222 +++++----------
 include/linux/gpio.h          |  11 +-
 include/linux/gpio/consumer.h | 253 +++++++++++++++++
 include/linux/gpio/driver.h   | 183 +++++++++++++
 include/linux/of_gpio.h       |  29 +-
 8 files changed, 1055 insertions(+), 377 deletions(-)
 create mode 100644 include/linux/gpio/consumer.h
 create mode 100644 include/linux/gpio/driver.h

-- 
1.8.4

