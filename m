Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933992Ab3JOVLE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 17:11:04 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:59400 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933818Ab3JOVLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 17:11:01 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 0/5] MFD: fixup tc3589x for device tree
Date: Tue, 15 Oct 2013 23:10:48 +0200
Message-Id: <1381871448-21492-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches defines the device tree bindings for the
Toshiba TC3589x multi-purpose expander. This has been half-useable
with devicetree using the "device tree node named like the I2C
device ID" approach, but this adds proper bindings and put them
to use.

It is partly documenting how it is already working, but since
there never was a proper binding document I do not regard the
old bindings "deployed".

The patches are orthogonal so once these are cleared, patches
1-3 can be applied to the MFD tree, patch 4 to the input tree,
and I will pick patch 5 to the ux500 device tree branch.

Linus Walleij (5):
  mfd: tc3589x: add device tree bindings
  mfd: tc3589x: detect the precise version
  mfd: tc3589x: reform device tree probing
  input: tc3589x-keypad: support probing from device tree
  ARM: ux500: adjust the TC3589x devices to the binding

 Documentation/devicetree/bindings/mfd/tc3589x.txt |  61 ++++++++++
 arch/arm/boot/dts/ste-href-tvk1281618.dtsi        |  39 ++++++-
 arch/arm/boot/dts/ste-hrefprev60.dtsi             |   8 +-
 drivers/input/keyboard/tc3589x-keypad.c           |  63 ++++++++++-
 drivers/mfd/tc3589x.c                             | 129 ++++++++++++++++++----
 5 files changed, 264 insertions(+), 36 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/tc3589x.txt

-- 
1.8.3.1

