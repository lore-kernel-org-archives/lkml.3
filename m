Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab3JAPAq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 11:00:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:5815 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323Ab3JAO7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 10:59:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1013,1371106800"; 
   d="scan'208";a="412452531"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-gpio@vger.kernel.org
Cc: rjw@rjwysocki.net, Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Alexandre Courbot <acourbot@nvidia.com>, Rob Landley <rob@landley.net>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5/5] gpiolib / ACPI: document the GPIO descriptor based interface
Date: Tue,  1 Oct 2013 17:58:57 +0300
Message-Id: <1380639537-23406-6-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1380639537-23406-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1380639537-23406-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In addition to the existing ACPI specific GPIO interface, document the new
descriptor based GPIO interface in Documentation/acpi/enumeration.txt, so
it is clear that this new interface is preferred over the ACPI specific
version.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 Documentation/acpi/enumeration.txt | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/Documentation/acpi/enumeration.txt b/Documentation/acpi/enumeration.txt
index aca4e69..48bb9ab 100644
--- a/Documentation/acpi/enumeration.txt
+++ b/Documentation/acpi/enumeration.txt
@@ -322,3 +322,25 @@ suitable to the gpiolib before passing them.
 
 In case of GpioInt resource an additional call to gpio_to_irq() must be
 done before calling request_irq().
+
+Note that the above API is ACPI specific and not recommended for drivers
+that need to support non-ACPI systems. The recommended way is to use
+the descriptor based GPIO interfaces. The above example looks like this
+when converted to the GPIO desc:
+
+	#include <linux/gpio/consumer.h>
+	...
+
+	struct gpio_desc *irq_desc, *power_desc;
+
+	irq_desc = gpiod_get_index(dev, NULL, 1);
+	if (IS_ERR(irq_desc))
+		/* handle error */
+
+	power_desc = gpiod_get_index(dev, NULL, 0);
+	if (IS_ERR(power_desc))
+		/* handle error */
+
+	/* Now we can use the GPIO descriptors */
+
+See also Documentation/gpio.txt.
-- 
1.8.4.rc3

