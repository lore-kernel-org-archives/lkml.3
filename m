Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587Ab3DXD31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 23:29:27 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:56301 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757488Ab3DXD3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 23:29:25 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <dmitry.torokhov@gmail.com>, <haojian.zhuang@gmail.com>,
        <xiechao.mail@gmail.com>
CC: Chao Xie <chao.xie@marvell.com>
Subject: [PATCH 0/6] input: pxa27x-keypad: enhancement and device tree support
Date: Tue, 23 Apr 2013 23:20:27 -0400
Message-ID: <1366773633-7727-1-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patches include 3 parts
1. copy members of platform data to device private data
pdata pass when probing the device may be freed after device initialized.
It is not safe to use pdata in other places except probe device. So copy
some useful members from pdata to device private structure.

2. use matrix_keypad for matrix keyes support
3. add device tree support for pxa27x-keypad

Chao Xie (6):
  input: pxa27x-keypad: copy members of platform data to device private
    data
  input: pxa27x-keypad: use matrix_keymap for matrix keyes
  arm: mmp: use matrix_keymap for aspenite
  arm: mmp: use matrix_keymap for teton_bga
  input: pxa27x-keypad: remove the unused members at platform data
  input: pxa27x-keypad: add device tree support

 .../devicetree/bindings/input/pxa27x-keypad.txt    |   60 ++++
 arch/arm/mach-mmp/aspenite.c                       |   10 +-
 arch/arm/mach-mmp/teton_bga.c                      |    8 +-
 drivers/input/keyboard/Kconfig                     |    1 +
 drivers/input/keyboard/pxa27x_keypad.c             |  320 +++++++++++++++++---
 include/linux/platform_data/keypad-pxa27x.h        |    3 +-
 6 files changed, 346 insertions(+), 56 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/input/pxa27x-keypad.txt

-- 
1.7.4.1

