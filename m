Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbaKFPMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 10:12:19 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:53130 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbaKFPMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 10:12:12 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-4c-545b8fc878bb
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-api@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH RESEND v3 0/4] power/mfd: Add max77693 charger driver
Date: Thu, 06 Nov 2014 16:11:56 +0100
Message-id: <1415286720-6358-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGLMWRmVeSWpSXmKPExsVy+t/xK7on+qNDDFbvl7XYOGM9q8WkJ++Z
	LeYfOcdqMXHlZGaL1y8MLc42vWG3uP/1KKPF5u8dbBabHl9jtbi8aw6bxefeI4wWM87vY7JY
	e+Quu8XpblaL07tLLFbt+sPoIOCxc9Zddo/NK7Q8Nq3qZPO4c20Pm8e8k4Eem5fUe/RtWcXo
	8XmTXABHFJdNSmpOZllqkb5dAlfG4Y9zGAu6+CrWTjzO3MB4lauLkZNDQsBEYtnmBjYIW0zi
	wr31QDYXh5DAUkaJM4+bWSCcPiaJL0ufsYBUsQkYS2xevgSsSkRgD5PEpxcrWEEcZoHtTBJ/
	vk1gBakSFnCV2HbyHdhcFgFViaen/rOD2LwCbhL/ji1nh9gnJ3Hy2GTWCYzcCxgZVjGKppYm
	FxQnpeca6RUn5haX5qXrJefnbmKEhOXXHYxLj1kdYhTgYFTi4Y1gjw4RYk0sK67MPcQowcGs
	JMJb3QMU4k1JrKxKLcqPLyrNSS0+xMjEwSnVwHic42Oq3HOuljOrj/wUnxPKupEtf3Xsv67a
	8rMpS3w+MDKLzA9dWbbjloDHCTfNU04vEmdvPe8el7+re9H7ty45vx20ZES/131azxJenxGv
	dH6ljdOG/xEuHMEreKUPcv/8esuBzyRmr9mNoJUJhmvUZ1/csn1WxYWugDOLezs73a7sN556
	YK4SS3FGoqEWc1FxIgDiF1ubKQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,


I got ack from Sebastian [1] but only for charger driver patch. This
means that I still need an ack for documentation (bindings, sysfs)...


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
 drivers/power/max77693_charger.c                   | 763 +++++++++++++++++++++
 include/linux/mfd/max77693-private.h               | 108 +++
 include/linux/mfd/max77693.h                       |   8 +
 7 files changed, 973 insertions(+)
 create mode 100644 drivers/power/max77693_charger.c

-- 
1.9.1

