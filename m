Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708AbaHRQvJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 12:51:09 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:12376 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbaHRQvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 12:51:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 18 Aug 2014 09:41:33 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
CC: <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 0/2] gpio: acpi: some sanity fixes
Date: Mon, 18 Aug 2014 09:50:55 -0700
Message-ID: <1408380657-6718-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.0.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two small patches perform some sanity changes in gpiolib-acpi:

1) Stop assuming there is a direct 1:1 mapping between GPIO descriptors
and GPIO numbers. This should not be taken for granted and will likely
change in the future. GPIO descriptors should be handled like regulators
and other allocated resources, i.e. obtained and preserved for later use
instead of constantly requested using gpiochip_get_desc()

2) Change the prototype of gpiochip_request_own_desc() to match other
functions in driver.h. This results is a simplification of the related
code in gpiolib-acpi, which should be a good thing.

Mika, could I have your ack (or even better, tested-by) on these patches?
They change some parts of gpiolib-acpi which I cannot test by myself.
Thanks!

Alexandre Courbot (2):
  gpio: acpi: normalize use of gpiochip_get_desc()
  gpio: change gpiochip_request_own_desc() prototype

 Documentation/gpio/driver.txt |  3 ++-
 drivers/gpio/gpiolib-acpi.c   | 30 +++++++++++-------------------
 drivers/gpio/gpiolib.c        | 18 ++++++++++++++----
 include/linux/gpio/driver.h   |  3 ++-
 4 files changed, 29 insertions(+), 25 deletions(-)

-- 
2.0.4

