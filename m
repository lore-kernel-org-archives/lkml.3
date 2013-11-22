Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067Ab3KVMPc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 07:15:32 -0500
Received: from mga09.intel.com ([134.134.136.24]:43845 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755586Ab3KVMOo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 07:14:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,751,1378882800"; 
   d="scan'208";a="413007375"
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
Subject: [PATCH v2 7/7] Documentation / ACPI: update to GPIO descriptor API
Date: Fri, 22 Nov 2013 14:14:34 +0200
Message-Id: <1385122474-14926-8-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1385122474-14926-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1385122474-14926-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the documentation also to reflect the fact that there are no ACPI
specific GPIO interfaces anymore but drivers should instead use the
descriptor based GPIO APIs.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 Documentation/acpi/enumeration.txt | 36 +++++++-----------------------------
 1 file changed, 7 insertions(+), 29 deletions(-)

diff --git a/Documentation/acpi/enumeration.txt b/Documentation/acpi/enumeration.txt
index b994bcb32b92..2a1519b87177 100644
--- a/Documentation/acpi/enumeration.txt
+++ b/Documentation/acpi/enumeration.txt
@@ -293,36 +293,13 @@ the device to the driver. For example:
 
 These GPIO numbers are controller relative and path "\\_SB.PCI0.GPI0"
 specifies the path to the controller. In order to use these GPIOs in Linux
-we need to translate them to the Linux GPIO numbers.
+we need to translate them to the corresponding Linux GPIO descriptors.
 
-In a simple case of just getting the Linux GPIO number from device
-resources one can use acpi_get_gpio_by_index() helper function. It takes
-pointer to the device and index of the GpioIo/GpioInt descriptor in the
-device resources list. For example:
+There is a standard GPIO API for that and is documented in
+Documentation/gpio.txt.
 
-	int gpio_irq, gpio_power;
-	int ret;
-
-	gpio_irq = acpi_get_gpio_by_index(dev, 1, NULL);
-	if (gpio_irq < 0)
-		/* handle error */
-
-	gpio_power = acpi_get_gpio_by_index(dev, 0, NULL);
-	if (gpio_power < 0)
-		/* handle error */
-
-	/* Now we can use the GPIO numbers */
-
-Other GpioIo parameters must be converted first by the driver to be
-suitable to the gpiolib before passing them.
-
-In case of GpioInt resource an additional call to gpio_to_irq() must be
-done before calling request_irq().
-
-Note that the above API is ACPI specific and not recommended for drivers
-that need to support non-ACPI systems. The recommended way is to use
-the descriptor based GPIO interfaces. The above example looks like this
-when converted to the GPIO desc:
+In the above example we can get the corresponding two GPIO descriptors with
+a code like this:
 
 	#include <linux/gpio/consumer.h>
 	...
@@ -339,4 +316,5 @@ when converted to the GPIO desc:
 
 	/* Now we can use the GPIO descriptors */
 
-See also Documentation/gpio.txt.
+There are also devm_* versions of these functions which release the
+descriptors once the device is released.
-- 
1.8.4.3

