Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbaEORwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 13:52:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:34504 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755172AbaEORwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 13:52:05 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Lee Jones <lee.jones@linaro.org>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dev@linux-sunxi.org, Carlo Caione <carlo@caione.org>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Hans de Goede <hdegoede@redhat.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [RFC PATCH 0/3] mfd: AXP22x: add support for APX221 PMIC
Date: Thu, 15 May 2014 19:51:42 +0200
Message-Id: <1400176305-22737-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch series adds basic support for the X-Powers' AXP221 PMIC.
It's mainly based on Carlo's series [1], which is almost merged (at least
the mfd and regulator drivers are merged).

At the moment I only added support for the AXP221 regulators but other
subdevices will be added later.

But, before going any further in my developement I'd like to get feedback
on some points:

1) I'm pretty sure we can share some code between the axp20x and axp22x
   drivers, but I'm not sure how it should be done:
 a) defining an axp2xx-core.c driver and make the axp20x and axp22x driver
    use this core implementation.
 b) just share some macros (like the AXP_DESC one) and the keep drivers
    separated
 c) keep only one generic driver that support all PMICs revisions (axp2xx-
    drivers).

2) The ipsout regulator is currently represented as a fixed regulator
   providing a 5v output, and this is not exactly the case.
   AFAIU (here's is the datasheet traduction if you want to check [2]), the
   ipsout output is a multiplexer that choose among vbus (5V), acin (12V
   which is then converted to 5V) and the battery power supply (3,5 -> 4,2 V).
   This means the output voltage of ipsout vary between 3,5V and 5V.
   How can we express this kind of muxer in the regulator framework (is there
   already something available ?) ?
   Note that the power supply selection is automatic, though we could force
   one power supply, but then we loose the ability to unplug one power supply
   without impacting the system.

Best Regards,

Boris

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2014-May/252638.html
[2] http://linux-sunxi.org/AXP221#Regulators

Boris BREZILLON (3):
  mfd: AXP22x: add support for APX221 PMIC
  regulator: AXP22x: add support for AXP221 regulators
  ARM: sunxi: dt: define AXP221 pmic node available on the APP4-EVB1
    board

 arch/arm/boot/dts/sun6i-a31-app4-evb1.dts |  83 ++++++++
 drivers/mfd/Kconfig                       |  12 ++
 drivers/mfd/Makefile                      |   1 +
 drivers/mfd/axp22x.c                      | 237 +++++++++++++++++++++
 drivers/regulator/Kconfig                 |   7 +
 drivers/regulator/Makefile                |   1 +
 drivers/regulator/axp22x-regulator.c      | 328 ++++++++++++++++++++++++++++++
 include/linux/mfd/axp22x.h                | 149 ++++++++++++++
 8 files changed, 818 insertions(+)
 create mode 100644 drivers/mfd/axp22x.c
 create mode 100644 drivers/regulator/axp22x-regulator.c
 create mode 100644 include/linux/mfd/axp22x.h

-- 
1.8.3.2

