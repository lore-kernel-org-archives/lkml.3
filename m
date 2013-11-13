Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758662Ab3KMHlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 02:41:17 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:23388 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758617Ab3KMHlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 02:41:10 -0500
X-AuditID: cbfec7f5-b7fe66d00000432e-12-52832d143ecf
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Anton Vorontsov <anton@enomsg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 0/4] mfd: max14577: Add max14577 MFD drivers
Date: Wed, 13 Nov 2013 08:40:53 +0100
Message-id: <1384328457-5147-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOLMWRmVeSWpSXmKPExsVy+t/xa7oius1BBh1f2SwObtW02DhjPavF
	1IdP2Cyuf3nOajH/yDlWi4krJzNbHPizg9Hi9QtDi7NNb9gt7n89ymjx7UoHk8XlXXPYLNYe
	uctucbtxBZvF4RUHmCxOd7M6CHgs+HyF3WNC/ydGj52z7rJ7bF6h5bFpVSebx51re9g85p0M
	9OjbsorR4/MmuQDOKC6blNSczLLUIn27BK6MCXdnMRZ8FqroPNbM0sB4nK+LkYNDQsBEYssu
	/y5GTiBTTOLCvfVsILaQwFJGievd6RB2H5PEnDliIDabgLHE5uVLgGq4OEQE9jNLTLx+mxnE
	YRY4yijxtnMXE0iVsICNxL+JWxhBFrAIqEp8uGoIEuYVcJNYOP06E8ReBYk5k2wmMHIvYGRY
	xSiaWppcUJyUnmukV5yYW1yal66XnJ+7iRESmF93MC49ZnWIUYCDUYmH1yKmKUiINbGsuDL3
	EKMEB7OSCO8B4eYgId6UxMqq1KL8+KLSnNTiQ4xMHJxSDYyLzpwQUVXw7NkhySdUmrMrpW1N
	3YE1NibHKiIfPbUSeXxqj4LEbmlGK7lePbb6y5+L3W1lT02ouPX7qEB5YKTed0cVgXk/lv7U
	m73tbeIiDu2cH7KrXpj/+/sjbscWMb74jLlf2MKurqv0CXWMneP995Knv7jWFvsTjTJbpz/5
	zFd/r2aC2HYlluKMREMt5qLiRABJHf5JKgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset adds drivers for MAXIM 14577 chip. The chip contains Micro-USB
Interface Circuit and Li+ Battery Charger. It contains accessory and USB
charger detection logic. It supports USB 2.0 Hi-Speed, UART and stereo
audio signals over Micro-USB connector.

The battery charger is compliant with the USB Battery Charging Specification
Revision 1.1. It has also SFOUT LDO output for powering USB devices.

The patchset consists of following drivers:
1. MFD core driver.
2. Extcon driver for the MUIC (Micro USB Interface Controller).
3. Charger driver using power supply class.
4. Regulator driver for SFOUT and charger.

The patchset is rebased on latest Linus' tree (v3.12-4849-g10d0c97) however
testing was mostly done on 3.10. Except minor change in extcon_dev_register()
function the patchset cleanly applies to 3.10 and 3.12.


Best regards,
Krzysztof Kozlowski


Chanwoo Choi (2):
  mfd: max14577: Add max14577 MFD driver core
  extcon: max77693: Add extcon-max14577 driver to support MUIC device

Krzysztof Kozlowski (2):
  charger: max14577: Add charger support for Maxim 14577
  regulator: max14577: Add regulator driver for Maxim 14577

 drivers/extcon/Kconfig               |   10 +
 drivers/extcon/Makefile              |    1 +
 drivers/extcon/extcon-max14577.c     |  806 ++++++++++++++++++++++++++++++++++
 drivers/mfd/Kconfig                  |   13 +
 drivers/mfd/Makefile                 |    1 +
 drivers/mfd/max14577-irq.c           |  283 ++++++++++++
 drivers/mfd/max14577.c               |  268 +++++++++++
 drivers/power/Kconfig                |    7 +
 drivers/power/Makefile               |    1 +
 drivers/power/max14577_charger.c     |  327 ++++++++++++++
 drivers/regulator/Kconfig            |    8 +
 drivers/regulator/Makefile           |    1 +
 drivers/regulator/max14577.c         |  365 +++++++++++++++
 include/linux/mfd/max14577-private.h |  291 ++++++++++++
 include/linux/mfd/max14577.h         |   76 ++++
 15 files changed, 2458 insertions(+)
 create mode 100644 drivers/extcon/extcon-max14577.c
 create mode 100644 drivers/mfd/max14577-irq.c
 create mode 100644 drivers/mfd/max14577.c
 create mode 100644 drivers/power/max14577_charger.c
 create mode 100644 drivers/regulator/max14577.c
 create mode 100644 include/linux/mfd/max14577-private.h
 create mode 100644 include/linux/mfd/max14577.h

-- 
1.7.9.5

