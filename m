Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065AbaCDQdI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 11:33:08 -0500
Received: from top.free-electrons.com ([176.31.233.9]:42171 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755024AbaCDQdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 11:33:04 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v3 0/5] ARM: sun6i: Add support for the A31 I2C controller
Date: Tue,  4 Mar 2014 17:28:36 +0100
Message-Id: <1393950521-4173-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

This patchset adds support the A31 i2c controller. This is mostly the
same controller as the one found in the other Allwinner SoCs, except
for the interrupts acking.

On the other SoCs using this driver, the interrupts are acked by
clearing the INT_FLAG bit in the control register, while on the A31,
the interrupt is acked by writing that bit into the control register.

The other difference is that the I2C IP is maintained in reset by a
reset controller, so we're adding optionnal support for the reset
framework in the driver to deassert the device from reset.

Thanks!
Maxime

Changes from v2:
  - Rebased on top of v3.14-rc5
  - Added Gregory Clement's Reviewed-by and Tested-by tags

Changes from v1:
  - Handle EPROBE_DEFER from the reset framework
  - Put the device back in reset at remove/failed probe
  - Document the newly introduced compatible string

Maxime Ripard (5):
  i2c: mv64xxx: Add reset deassert call
  i2c: mv64xxx: Add support for the Allwinner A31 I2C driver
  ARM: sun6i: Enable the I2C controllers
  ARM: sun6i: Enable the I2C muxing options
  ARM: sun6i: colombus: Enable the I2C controllers

 .../devicetree/bindings/i2c/i2c-mv64xxx.txt        | 20 ++++---
 arch/arm/boot/dts/sun6i-a31-colombus.dts           | 18 +++++++
 arch/arm/boot/dts/sun6i-a31.dtsi                   | 61 ++++++++++++++++++++++
 drivers/i2c/busses/Kconfig                         |  1 +
 drivers/i2c/busses/i2c-mv64xxx.c                   | 32 +++++++++++-
 5 files changed, 124 insertions(+), 8 deletions(-)

-- 
1.9.0

