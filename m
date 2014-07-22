Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbaGVHlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 03:41:22 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:28311 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbaGVHlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 03:41:21 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-d2-53ce159e7dd8
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RESEND PATCH v3 0/6] charger/mfd: max14577: Add support for MAX77836
Date: Tue, 22 Jul 2014 09:41:00 +0200
Message-id: <1406014866-17744-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCLMWRmVeSWpSXmKPExsVy+t/xK7rzRM8FGzw7y2+xccZ6VoupD5+w
	WUx68p7ZYuLKycwW/W8Wslqce7WS0eL1C0OLs01v2C3ufz3KaPHtSgeTxebvHWwWl3fNYbNY
	e+Quu8XS6xeZLCZMX8ti0br3CLvF6W5WB0GPNfPWMHpc7utl8tg56y67x8rlX9g8Nq/Q8ti0
	qpPN4861PWwe804GevRtWcXo8XmTXABXFJdNSmpOZllqkb5dAlfG4+872Quui1R0fbjO2MD4
	hL+LkZNDQsBEYtXDuawQtpjEhXvr2UBsIYGljBL///N2MXIB2X1MEq//vgNLsAkYS2xevoQN
	JCEiMI1RYvGGiYwgDrPANBaJf3c7mLoYOTiEBfwk/n4VBTFZBFQl/l8G6+UVcJd41zmLHWKZ
	nMTJY5NZJzByL2BkWMUomlqaXFCclJ5rpFecmFtcmpeul5yfu4kRErJfdzAuPWZ1iFGAg1GJ
	h5fjxalgIdbEsuLK3EOMEhzMSiK87XvOBgvxpiRWVqUW5ccXleakFh9iZOLglGpgXMQgy3Pn
	X+MEp0fJ/l3t7bs5VkQdzM76uqDWU/JnZULus+mRipMmbLR28V5yflvw43CO9bnK6uck3drZ
	e1ZGz+5uzGIstg6sNm3/7vTY8dEdQ++dboI6uVMcqhUf7tJmXmq1gEWeZfHfbDm2W1t3f41U
	Fl8dc/ZqwpHbFQdepfV/s9YR6FqrxFKckWioxVxUnAgAmyg7KzcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


This is a resend of third version of patches adding support for
MAX77836 device to the max14577 drivers.

This patchset was already reviewed by some of the maintainers during
previous submissions.
I only need acks from power tree (patches: 1, 3, 4, 6).

The patches 1, 2 and 3 depend on each other so they should be
pulled at once. Patches 4, 5 and 6 can be applied independently.
Lee Jones said he can take the set through his tree. Still I need acks
from power subsystem.


Changes since v2
================
1. charger: Use sysfs instead of DTS for setting the fast charge timer.
   The charger driver now selects the CONFIG_SYSFS and exports
   a DEVICE_ATTR. (suggested by Mark Rutland)
2. Add patch 6 with documentation of exported sysfs entry for fast
   charge timer.
3. charger 3/6: Add missing 'break' in switch parsing valid values
   for fast charge timer.

Changes since v1
================
1. charger 3/5: Add an error message for each unsuccessful parse of DT
   property (suggested by Mark Rutland).
2. charger 3/5: Use 'u32' type for storing values from DT (suggested
   by Mark Rutland).
3. charger 3/5: Remove an error message for memory allocation failure.


The patchset (first and second part of the MAX77836 drivers) has been
on the lists since January. Changelog for the first part of drivers:
https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg628696.html


Best regards,
Krzysztof Kozlowski


Krzysztof Kozlowski (6):
  charger: max14577: Add support for MAX77836 charger
  regulator/mfd: max14577: Export symbols for calculating charger
    current
  charger: max14577: Configure battery-dependent settings from DTS and
    sysfs
  power: max17040: Add ID for MAX77836 Fuel Gauge block
  devicetree: mfd: max14577: Add device tree bindings document
  Documentation: charger: max14577: Document exported sysfs entry

 Documentation/ABI/testing/sysfs-class-power        |  14 +
 Documentation/devicetree/bindings/mfd/max14577.txt | 146 ++++++++
 drivers/mfd/max14577.c                             | 100 +++++-
 drivers/power/Kconfig                              |   5 +-
 drivers/power/max14577_charger.c                   | 370 +++++++++++++++++++--
 drivers/power/max17040_battery.c                   |   1 +
 drivers/regulator/max14577.c                       |  80 +----
 include/linux/mfd/max14577-private.h               |  95 ++++--
 include/linux/mfd/max14577.h                       |  30 ++
 9 files changed, 703 insertions(+), 138 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/max14577.txt

-- 
1.9.1

