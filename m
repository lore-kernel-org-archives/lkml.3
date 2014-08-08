Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbaHHAMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 20:12:00 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:45476 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009AbaHHAL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 20:11:59 -0400
MIME-Version: 1.0
From: Bryan Wu <cooloney@gmail.com>
Date: Thu, 7 Aug 2014 17:11:36 -0700
Message-ID: <CAK5ve-LY_HNUX0HDEkjahzjTGDgbOYQO-g_jCwECOPwRu42Z-A@mail.gmail.com>
Subject: [GIT PULL] LED updates for 3.17
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This cycle we got:
 - a fix of attribute-creation race for the whole leds subsystem
 - new drivers (HID:GT683R, leds-ipaq-micro)
 - other fixing and clean up.

Please consider the following changes since commit
a497c3ba1d97fc69c1e78e7b96435ba8c2cb42ee:

  Linux 3.16-rc2 (2014-06-21 19:02:54 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds.git for-next

for you to fetch changes up to e661c8978e4833d4148d08b405a2f3175d6f97d9:

  leds: ipaq-micro: fix sparse non static symbol warning (2014-07-29
10:57:20 -0700)

----------------------------------------------------------------
Janne Kanniainen (3):
      HID: add support for MSI GT683R led panels
      HID: gt683r: fix race condition
      HID: gt683r: move mode attribute to led-class devices

Johan Hovold (13):
      leds: add led-class attribute-group support
      leds: lm3550: fix attribute-creation race
      leds: lm3533: fix attribute-creation race
      leds: lm355x: fix attribute-creation race
      leds: lm3642: fix attribute-creation race
      leds: max8997: fix attribute-creation race
      leds: netxbig: fix attribute-creation race
      leds: ns2: fix attribute-creation race
      leds: ss4200: fix attribute-creation race
      leds: wm831x-status: fix attribute-creation race
      input: lm8323: fix attribute-creation race
      leds: lp55xx-common: fix sysfs entry leak
      leds: lp55xx-common: fix attribute-creation race

Linus Walleij (1):
      leds: add driver for the iPAQ micro

Marek Belisko (1):
      Documentation: dts: tcs6507: Fix wrong statement about #gpio-cells

Peter Meerwald (3):
      leds:pca963x: Add support for PCA9635 LED driver chip
      leds:pca963x: Always initialize MODE2 register
      leds:pca963x: Update for PCA9635 and correct statement about
MODE2 OUTDRV default

Vincent Donnefort (1):
      leds: convert blink timer to workqueue

Wei Yongjun (1):
      leds: ipaq-micro: fix sparse non static symbol warning

 Documentation/ABI/testing/sysfs-class-leds-gt683r  |  16 +
 Documentation/devicetree/bindings/leds/pca963x.txt |   9 +-
 Documentation/devicetree/bindings/leds/tca6507.txt |   2 +-
 drivers/hid/Kconfig                                |  14 +
 drivers/hid/Makefile                               |   1 +
 drivers/hid/hid-core.c                             |   1 +
 drivers/hid/hid-gt683r.c                           | 321 +++++++++++++++++++++
 drivers/hid/hid-ids.h                              |   2 +-
 drivers/hid/usbhid/hid-quirks.c                    |   2 +-
 drivers/input/keyboard/lm8323.c                    |  22 +-
 drivers/leds/Kconfig                               |   7 +
 drivers/leds/Makefile                              |   1 +
 drivers/leds/led-class.c                           |  19 +-
 drivers/leds/led-core.c                            |  11 +-
 drivers/leds/leds-ipaq-micro.c                     | 141 +++++++++
 drivers/leds/leds-lm3530.c                         |  20 +-
 drivers/leds/leds-lm3533.c                         |  20 +-
 drivers/leds/leds-lm355x.c                         |  21 +-
 drivers/leds/leds-lm3642.c                         |  30 +-
 drivers/leds/leds-lp55xx-common.c                  |  20 +-
 drivers/leds/leds-max8997.c                        |  16 +-
 drivers/leds/leds-netxbig.c                        |  31 +-
 drivers/leds/leds-ns2.c                            |  16 +-
 drivers/leds/leds-pca963x.c                        |  28 +-
 drivers/leds/leds-ss4200.c                         |  14 +-
 drivers/leds/leds-wm831x-status.c                  |  23 +-
 include/linux/leds.h                               |   5 +-
 27 files changed, 644 insertions(+), 169 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-leds-gt683r
 create mode 100644 drivers/hid/hid-gt683r.c
 create mode 100644 drivers/leds/leds-ipaq-micro.c
