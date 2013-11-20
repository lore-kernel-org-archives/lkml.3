Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab3KTOMc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 09:12:32 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:30386 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364Ab3KTOM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 09:12:29 -0500
X-AuditID: cbfec7f5-b7fe66d00000432e-1f-528cc34be280
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 0/5] mfd: max14577: Add max14577 MFD drivers
Date: Wed, 20 Nov 2013 15:12:07 +0100
Message-id: <1384956732-19526-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrALMWRmVeSWpSXmKPExsVy+t/xK7reh3uCDFq6pC0ObtW02DhjPavF
	1IdP2Cyuf3nOajH/yDlWi4krJzNbHPizg9Hi3KuVjBavXxhanG16w25x/+tRRotvVzqYLDY9
	vsZqsbBtCYvF5V1z2CzWHrnLbnG7cQWbxYTpa1ksDq84wGSx7uV0FovT3awWrw62sTiIeayZ
	t4bRY8HnK+weE/o/MXrsnHWX3WPl8i9sHptXaHlsWtXJ5vFq9UxWjzvX9rB5zDsZ6LF5Sb1H
	35ZVjB6fN8l5bJwbGsAXxWWTkpqTWZZapG+XwJVx7twiloLpkhXPFr9mbmDcINTFyMkhIWAi
	cfLIHnYIW0ziwr31bF2MXBxCAksZJWZPf8AK4fQxSZw5s5QJpIpNwFhi8/IlYFUiAnNYJXaf
	ecYC4jALHGWUeNu5C6xKWMBe4tuZHWBzWQRUJaasWw5m8wq4S7z4NBNoLAfQPgWJOZNsJjBy
	L2BkWMUomlqaXFCclJ5rpFecmFtcmpeul5yfu4kREgtfdzAuPWZ1iFGAg1GJh1diQXeQEGti
	WXFl7iFGCQ5mJRHerr09QUK8KYmVValF+fFFpTmpxYcYmTg4pRoYz2bV1d5W11zmyy70XW3f
	+VOGtzQWzQ3Ws3u9ojxoz5fo3G3xL+bHXYhhk/5nvrUq5usVqadpmYfytkeXODLdMHJqyt0n
	Kr5gz3yhw4k3JlUEa1c0ZP7XYUl8vnSroSvTrbp+t6LI7wu6vhVPny0bYRekv9sw/DXnx5CP
	LYflDzcbV0ZInr+qxFKckWioxVxUnAgA7zLy72MCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is second version of patchset adding drivers for MAXIM 14577 chip.
The chip contains Micro-USB Interface Circuit and Li+ Battery Charger.
It contains accessory and USB charger detection logic. It supports USB 2.0
Hi-Speed, UART and stereo audio signals over Micro-USB connector.

The battery charger is compliant with the USB Battery Charging Specification
Revision 1.1. It has also SFOUT LDO output for powering USB devices.

The patchset consists of following drivers:
1. MFD core driver.
2. Extcon driver for the MUIC (Micro USB Interface Controller).
3. Charger driver using power supply class.
4. Regulator driver for SFOUT and charger.
5. Documentation of device tree bindings.

The patchset is rebased on latest Linus' tree (vv3.12-10710-gb4789b8) however
testing was mostly done on 3.10.


Changes since v1:
-----------------
1. Applied comments from review (Mark Brown, Mark Rutland).
2. Removed any DT bindings which are not needed.
3. Removed "wakeup" node from bindings.
4. Fixed interrupt handling during resume. This lead to removal of the weird
   IRQ/GPIO code discussed during review.
5. Minor fixes pointed by checkpatch, added authors.
6. Use of_get_child_by_name() for accessing regulators bindings.
7. Added documentation of bindings (fifth patch).


Best regards,
Krzysztof Kozlowski


Chanwoo Choi (2):
  mfd: max14577: Add max14577 MFD driver core
  extcon: max14577: Add extcon-max14577 driver to support MUIC device

Krzysztof Kozlowski (3):
  charger: max14577: Add charger support for Maxim 14577
  regulator: max14577: Add regulator driver for Maxim 14577
  mfd: max14577: Add device tree bindings document

 Documentation/devicetree/bindings/mfd/max14577.txt |   49 ++
 drivers/extcon/Kconfig                             |   10 +
 drivers/extcon/Makefile                            |    1 +
 drivers/extcon/extcon-max14577.c                   |  806 ++++++++++++++++++++
 drivers/mfd/Kconfig                                |   13 +
 drivers/mfd/Makefile                               |    1 +
 drivers/mfd/max14577-irq.c                         |  245 ++++++
 drivers/mfd/max14577.c                             |  216 ++++++
 drivers/power/Kconfig                              |    7 +
 drivers/power/Makefile                             |    1 +
 drivers/power/max14577_charger.c                   |  323 ++++++++
 drivers/regulator/Kconfig                          |    7 +
 drivers/regulator/Makefile                         |    1 +
 drivers/regulator/max14577.c                       |  282 +++++++
 include/linux/mfd/max14577-private.h               |  317 ++++++++
 include/linux/mfd/max14577.h                       |   72 ++
 16 files changed, 2351 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/max14577.txt
 create mode 100644 drivers/extcon/extcon-max14577.c
 create mode 100644 drivers/mfd/max14577-irq.c
 create mode 100644 drivers/mfd/max14577.c
 create mode 100644 drivers/power/max14577_charger.c
 create mode 100644 drivers/regulator/max14577.c
 create mode 100644 include/linux/mfd/max14577-private.h
 create mode 100644 include/linux/mfd/max14577.h

-- 
1.7.9.5

