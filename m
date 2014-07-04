Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbaGDH7D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 03:59:03 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:64497 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaGDH7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 03:59:00 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-05-53b65ec2dc39
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
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
Subject: [PATCH v2 0/5] charger/mfd: max14577: Add support for MAX77836
Date: Fri, 04 Jul 2014 09:58:24 +0200
Message-id: <1404460709-17178-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHLMWRmVeSWpSXmKPExsVy+t/xq7qH4rYFG3TPlbHYOGM9q8XUh0/Y
	LCY9ec9sMXHlZGaL/jcLWS3OvVrJaPH6haHF2aY37Bb3vx5ltPh2pYPJ4vKuOWwWa4/cZbdY
	ev0ik8WE6WtZLFr3HmG3ON3N6iDgsWbeGkaPy329TB47Z91l91i5/Aubx+YVWh6bVnWyedy5
	tofNY97JQI++LasYPT5vkgvgiuKySUnNySxLLdK3S+DKOP5CpmCZQMXVveYNjOt4uhg5OSQE
	TCRatq5nhrDFJC7cW88GYgsJLGWU+DhVtYuRC8juY5Jo3/UFrIhNwFhi8/IlYEUiApUS306f
	YAEpYhaYxiLx724HE0hCWMBdYvX55WA2i4CqxPtTRxhBbF6geMflBSwQ2+QkTh6bzDqBkXsB
	I8MqRtHU0uSC4qT0XEO94sTc4tK8dL3k/NxNjJAw/bKDcfExq0OMAhyMSjy8jSs2BAuxJpYV
	V+YeYpTgYFYS4a1S2hYsxJuSWFmVWpQfX1Sak1p8iJGJg1OqgTGN/azyksfi3m/t1Rjk73M2
	JORXmx/gu+8n3nihOCmy/3Odeh37k+v3zqwR694p8TmU92HW2WdTYncEGJq8/fWnX5lFI878
	FfcKpq5D2pvfcNhO+Hrr2pkio870mb51a9olbn7lXnzGytKGe3Pf4Z49cZYaIQpSKUrMVUZ7
	XKSUdrVVzX+4SYmlOCPRUIu5qDgRAFiPJEYxAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


This is second version of patches adding support for MAX77836
device to the max14577 drivers. The first part of patches (main MFD,
extcon and regulator drivers) was merged already.

The patches 1, 2 and 3 depend on each other so they should be
pulled at once. Patches 4 and 5 can be applied independently.

This patchset was already reviewed by some of the maintainers during
previous submissions.

I only need acks from power tree (patches: 1, 3, 4).


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


Krzysztof Kozlowski (5):
  charger: max14577: Add support for MAX77836 charger
  regulator/mfd: max14577: Export symbols for calculating charger
    current
  charger: max14577: Configure battery-dependent settings from DTS
  power: max17040: Add ID for MAX77836 Fuel Gauge block
  devicetree: mfd: max14577: Add device tree bindings document

 Documentation/devicetree/bindings/mfd/max14577.txt | 152 +++++++++++
 drivers/mfd/max14577.c                             | 100 ++++++-
 drivers/power/Kconfig                              |   4 +-
 drivers/power/max14577_charger.c                   | 299 ++++++++++++++++++---
 drivers/power/max17040_battery.c                   |   1 +
 drivers/regulator/max14577.c                       |  80 +-----
 include/linux/mfd/max14577-private.h               |  92 +++++--
 include/linux/mfd/max14577.h                       |  31 +++
 8 files changed, 622 insertions(+), 137 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/max14577.txt

-- 
1.9.1

