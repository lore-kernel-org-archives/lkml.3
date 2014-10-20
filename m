Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbaJTMf0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 08:35:26 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:41066 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaJTMfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 08:35:21 -0400
X-AuditID: cbfec7f4-b7f6c6d00000120b-5f-54450186a2c1
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, linux-api@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 0/5] power/mfd: Add max77693 charger driver
Date: Mon, 20 Oct 2014 14:34:44 +0200
Message-id: <1413808489-3524-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpiluLIzCtJLcpLzFFi42I5/e/4Nd02RtcQg1vbuS02zljPajHpyXtm
	i/lHzrFaTFw5mdni9QtDi7NNb9gt7n89ymix+XsHm8XlXXPYLD73HmG0WHvkLrvF6W5Wi9O7
	Sxx4PXbOusvusXmFlsemVZ1sHneu7WHzmHcy0KNvyypGj8+b5ALYo7hsUlJzMstSi/TtErgy
	fu54wlSwnqdiy/0vjA2MPZxdjJwcEgImEqfnr2CEsMUkLtxbzwZiCwksZZQ49zGni5ELyO5j
	kmj485AdJMEmYCyxefkSNpCEiMA+JolTz98ygzjMAkcZJab3vmUCqRIWsJNYsWMaC4jNIqAq
	sWwFRJxXwE3i/uInLBDr5CROHpvMOoGRewEjwypG0dTS5ILipPRcQ73ixNzi0rx0veT83E2M
	kHD7soNx8TGrQ4wCHIxKPLwCli4hQqyJZcWVuYcYJTiYlUR4Xf4DhXhTEiurUovy44tKc1KL
	DzEycXBKNTBy7OuKv+JT8nX7eq8EvhsyHL7bv75fsPj6o4sfamXOvbbNkOazvzrdjPne5OJz
	U+Ms5lsL8p2rvrD92oE/U9f8LauwbLrK/3KLuWTyjPOT3jsvO9Hh1Ls7cWJvj9LW4HrD0q19
	q1V1ciO0TNWLXbrXTm4Mf3lQ1+Gglk+bVIpzzJNMU4+gPh0lluKMREMt5qLiRAD5PYt8FQIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,


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

Everything rebased on next-20141020.


Best regards,
Krzysztof


Krzysztof Kozlowski (5):
  devicetree: mfd: max77693: Document new bindings for charger
  mfd: max77693: Map charger device to its own of_node
  mfd: max77693: Add defines for MAX77693 charger driver
  power: max77693: Add charger driver for Maxim 77693
  Documentation: charger: max77693: Document exported sysfs entry

 Documentation/ABI/testing/sysfs-class-power        |  42 ++
 Documentation/devicetree/bindings/mfd/max77693.txt |  46 ++
 drivers/mfd/max77693.c                             |   5 +-
 drivers/power/Kconfig                              |   6 +
 drivers/power/Makefile                             |   1 +
 drivers/power/max77693_charger.c                   | 763 +++++++++++++++++++++
 include/linux/mfd/max77693-private.h               | 108 +++
 include/linux/mfd/max77693.h                       |   8 +
 8 files changed, 978 insertions(+), 1 deletion(-)
 create mode 100644 drivers/power/max77693_charger.c

-- 
1.9.1

