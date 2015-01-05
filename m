Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbbAEKRM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 05:17:12 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36950 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbbAEKRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 05:17:10 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-45-54aa64a3aa1e
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-api@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v4 0/4] power: Add max77693 charger driver
Date: Mon, 05 Jan 2015 11:16:55 +0100
Message-id: <1420453019-28614-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMJMWRmVeSWpSXmKPExsVy+t/xq7qLU1aFGBydq2Ex6cl7Zov5R86x
	WkxcOZnZ4vULQ4v7X48yWmz+3sFmcXnXHDaLz71HGC1Od7NanN5d4sDlsXPWXXaPzSu0PDat
	6mTzuHNtD5vHvJOBHn1bVjF6fN4kF8AexWWTkpqTWZZapG+XwJUx/ex7toKDfBX77k9ibmCc
	yN3FyMkhIWAicfXjE3YIW0ziwr31bF2MXBxCAksZJU51TWCHcPqYJI6vu8QEUsUmYCyxefkS
	sCoRgT1MEp9erGAFSTALGEr8fPcHbJSwgJXE0YbLLCA2i4CqxM4Dn8DivALuEisX7INaJydx
	8thk1gmM3AsYGVYxiqaWJhcUJ6XnGuoVJ+YWl+al6yXn525ihATUlx2Mi49ZHWIU4GBU4uH1
	OLEyRIg1say4MvcQowQHs5II77pbQCHelMTKqtSi/Pii0pzU4kOMTBycUg2MuWpWK71iE05e
	/rDtyfSP9gypV+c9vnneVNS62Iuj5+jNgm9x2xxcnRXcONoZd/5Zkb23bJnExpyL7DG/mqKm
	JKZPKj9x2m3Ts2MGhz4c07Hz2l5mfGj3kX6eqveWmr8m5t9h/br7lNVmF0GOmKCbS2fW3z10
	Zv2phOZT/fZXnF4GxLy6JnNdQ4mlOCPRUIu5qDgRACzzQmoGAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,


Changes since v3
================
1. Patch 3/4: Don't create platform data structure for charger settings
   because driver won't be used on non-DT SoCs (its for Exynos based
   Trats2).
2. Patch 3/4: Drop Sebastian's ack [1] because of change above.

Changes since v2
================
1. Add ack from Sebastian Reichel (charger driver).
2. Drop patch "mfd: max77693: Map charger device to its own of_node"
   (applied by Lee Jones).


Changes since v1
================
1. Add patch 2/5: mfd: max77693: Map charger device to its own of_node
   (forgot to send it in v1)
2. Remove patches for DTS and configs. I'll send them later.
3. Add ack from Lee Jones (patch 3/5).


Description
===========
The patchset adds max77693 charger driver present on Trats2 board
(and Galaxy S III). The driver configures battery charger and exposes
power supply interface.

Driver is necessary to provide full charging stack on Trats2 device
(extcon, charger-manager etc.).

[1] https://lkml.org/lkml/2014/10/27/774


Best regards,
Krzysztof



Krzysztof Kozlowski (4):
  devicetree: power/mfd: max77693: Document new bindings for charger
  mfd: max77693: Add defines for MAX77693 charger driver
  power: max77693: Add charger driver for Maxim 77693
  Documentation: power: max77693-charger: Document exported sysfs entry

 Documentation/ABI/testing/sysfs-class-power        |  42 ++
 Documentation/devicetree/bindings/mfd/max77693.txt |  45 ++
 drivers/power/Kconfig                              |   6 +
 drivers/power/Makefile                             |   1 +
 drivers/power/max77693_charger.c                   | 758 +++++++++++++++++++++
 include/linux/mfd/max77693-private.h               | 108 +++
 6 files changed, 960 insertions(+)
 create mode 100644 drivers/power/max77693_charger.c

-- 
1.9.1

