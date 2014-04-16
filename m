Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161640AbaDPOob (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 10:44:31 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:46484 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161145AbaDPOo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 10:44:27 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Silvio F <silvio.fricke@gmail.com>, Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Shiraz Hashim <shiraz.hashim@st.com>, spear-devel@list.st.com,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 0/6] mfd/gpio: cleanup of STMPE driver
Date: Wed, 16 Apr 2014 16:44:09 +0200
Message-Id: <1397659455-13638-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This cleans up the STMPE driver a bit:

- Remove all static GPIO and IRQ number assignments as all platforms
  with this hardware use device tree now.
- Add optional regulators.
- Add proper device tree probe path using compatible strings.
- Block mask fix for STMPE1601.
- Switch GPIO portions to use the gpiolib irqchip helpers.

This branch is available here if you want to test it:

git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-stericsson.git stmpe

It'd be great if someone with the i.MX 53 or 6q platforms using
this could test it, the same goes for the SPEAr people.

The last patch need to be merged in the GPIO tree, but patches
1 thru 4 can be merged directly to MFD (as I am GPIO maintainer
take the few hunks on the GPIO driver as ACKed). If that goes
well I can pull an immutable branch into the GPIO tree to apply
the last patch there, and the Ux500 DT patch should go through
the Ux500 tree.

Linus Walleij (6):
  mfd: stmpe: root out static GPIO and IRQ assignments
  mfd: stmpe: add optional regulators
  mfd: stmpe: prope properly from the device tree
  mfd: stmpe: mask off unused blocks properly
  ARM: ux500: add VCC and VIO regulators to STMPE IC
  gpio: stmpe: switch to use gpiolib irqchip helpers

 arch/arm/boot/dts/ste-href-stuib.dtsi |   2 +
 drivers/gpio/Kconfig                  |   1 +
 drivers/gpio/gpio-stmpe.c             | 127 +++++++++-------------------------
 drivers/mfd/stmpe-i2c.c               |  60 +++++++++++++++-
 drivers/mfd/stmpe.c                   |  30 +++++++-
 drivers/mfd/stmpe.h                   |   2 +-
 include/linux/mfd/stmpe.h             |  19 ++---
 7 files changed, 127 insertions(+), 114 deletions(-)

-- 
1.9.0

