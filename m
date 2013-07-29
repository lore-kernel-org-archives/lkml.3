Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021Ab3G2RAz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 13:00:55 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58120 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab3G2RAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 13:00:54 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Subject: [PATCH v3 0/6] Add Dialog DA9063 core and regulator drivers
Date: Mon, 29 Jul 2013 19:00:41 +0200
Message-Id: <1375117247-6376-1-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.8.3.2
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is the third round of the DA9063 mfd core and regulator patches, with the
following changes since v2:
 - Split DA9063 core driver patch into three more digestible parts
   (register definitions, core mfd/i2c driver, regmap irqchip support)
 - Removed 32k clock output from the regulator driver
 - Added device tree binding documentation
 - Added 32k clock output to mfd driver using clock API

The regmap irq patch depends on regmap changes available at

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tags/regmap-irq-ack-mask

regards
Philipp

 .../devicetree/bindings/mfd/da9063-i2c.txt         |   68 ++
 drivers/mfd/Kconfig                                |   12 +
 drivers/mfd/Makefile                               |    3 +
 drivers/mfd/da9063-core.c                          |  261 +++++
 drivers/mfd/da9063-i2c.c                           |  182 ++++
 drivers/mfd/da9063-irq.c                           |  193 ++++
 drivers/regulator/Kconfig                          |   10 +
 drivers/regulator/Makefile                         |    1 +
 drivers/regulator/da9063-regulator.c               |  941 ++++++++++++++++++
 include/linux/mfd/da9063/core.h                    |   93 ++
 include/linux/mfd/da9063/pdata.h                   |  111 +++
 include/linux/mfd/da9063/registers.h               | 1028 ++++++++++++++++++++
 12 files changed, 2903 insertions(+)


