Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999AbaGVHSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 03:18:22 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:4643 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbaGVHSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 03:18:21 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 22 Jul 2014 00:06:37 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 0/5] gpio: a few cleanup patches
Date: Tue, 22 Jul 2014 16:17:38 +0900
Message-ID: <1406013463-19218-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.0.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Still in order to prepare for the ability to share one GPIO between
several consumers, this series of mostly unrelated patches fixes a
few minor issues. Most of the patches should be no-brainers ; maybe
patch 2 should be looked more closely in order to understand why this
code was there in the first place. Patch 4 is not only a simplification
of the API, but a hard requirement if we are to allow several GPIO
descriptors to manipulate the same GPIO, as no driver function should
require a descriptor to perform properly.

This series has been tested on Raspberry Pi and Jetson TK1 without any
problem being noticed.

Alexandre Courbot (5):
  gpio: remove export of private of_get_named_gpio_flags()
  gpio: simplify gpiochip_export()
  gpio: make gpiochip_get_desc() gpiolib-private
  gpio: remove gpiod_lock/unlock_as_irq()
  gpio: move gpio_ensure_requested() into legacy C file

 Documentation/gpio/driver.txt |   4 +-
 drivers/gpio/gpiolib-acpi.c   |   6 +-
 drivers/gpio/gpiolib-legacy.c | 106 ++++++++++++++++++++++++++--
 drivers/gpio/gpiolib-of.c     |   3 +-
 drivers/gpio/gpiolib-sysfs.c  |  24 +++----
 drivers/gpio/gpiolib.c        | 160 ++++++------------------------------------
 drivers/gpio/gpiolib.h        |   2 +
 include/asm-generic/gpio.h    |  18 +----
 include/linux/gpio/driver.h   |   7 +-
 9 files changed, 144 insertions(+), 186 deletions(-)

-- 
2.0.1

