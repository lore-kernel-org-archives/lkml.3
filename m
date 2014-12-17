Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388AbaLQPvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 10:51:20 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:41775 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbaLQPvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 10:51:19 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH v5 0/7]gpio/xilinx: Add support for PCI mapped devices and rmmod
Date: Wed, 17 Dec 2014 16:51:07 +0100
Message-Id: <1418831474-24428-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The main purpose of this patchset is to use the driver on a PCI mapped fpga.

This patchset also converts the driver to platform device, so it will support
hot plugged devices and rmmod.

Changeset:
v5:
Suggested by Alexandre Courbot <gnurou@gmail.com>
-Create a single gpio chip on dual cores
-Create new function of_mm_gpiochip_remove

v4:
Suggested by Michal Simek <michal.simek@xilinx.com>
-Add missing module_exit

v3
Suggested by Michal Simek <michal.simek@xilinx.com>
-Add patch for fixing kernel-doc
-Leave the driver at subsys_initcall


v2
Suggested by Alexandre Courbot <gnurou@gmail.com>
Merge 2 and 3 (convert to platform device and implement remove)

Ricardo Ribalda Delgado (7):
  gpio/xilinx: Remove offset property
  gpio/xilinx: Convert the driver to platform device interface
  gpio/xilinx: Add support for X86 Arch
  gpio/xilinx: Fix kernel-doc
  gpio/xilinx: Create a single gpio chip on dual cores
  gpio/gpiolib-of: Create of_mm_gpiochip_remove
  gpio/xilinx: Use of_mm_gpiochip_remove

 drivers/gpio/Kconfig       |   4 +-
 drivers/gpio/gpio-xilinx.c | 284 ++++++++++++++++++++++++++-------------------
 drivers/gpio/gpiolib-of.c  |  17 +++
 include/linux/of_gpio.h    |   1 +
 4 files changed, 182 insertions(+), 124 deletions(-)

-- 
2.1.3

