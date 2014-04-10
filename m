Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934480AbaDJAhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 20:37:47 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:61390 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932847AbaDJAhp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 20:37:45 -0400
MIME-Version: 1.0
From: Bryan Wu <cooloney@gmail.com>
Date: Wed, 9 Apr 2014 17:37:23 -0700
Message-ID: <CAK5ve-JC2He351jeLBX_8KRAnHbxVm3hMZMskn9Gv_kSyQvvOw@mail.gmail.com>
Subject: [GIT PULL] LED updates for 3.15
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

This cycle we got:
 - new driver for leds-mc13783
 - bug fixes
 - code cleanup.

Please consider the following changes since commit
cfbf8d4857c26a8a307fb7cd258074c9dcd8c691:

  Linux 3.14-rc4 (2014-02-23 17:40:03 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds.git for-next

for you to fetch changes up to 14f5716bc23cebb627b40a2808e9f04eb77ab206:

  leds: make sure we unregister a trigger only once (2014-04-07 14:47:25 -0700)

----------------------------------------------------------------
Alexander Shiyan (5):
      leds: leds-mc13783: Add MC34708 LED support
      leds: leds-mc13783: Use LED core PM functions
      leds: leds-mc13783: Use proper "max_brightness" value fo LEDs
      leds: leds-mc13783: Remove unnecessary cleaning of registers on exit
      leds: leds-mc13783: Add devicetree support

Jean Delvare (2):
      leds-ot200: Fix dependencies
      leds: clevo-mail: Make probe function __init

Jingoo Han (5):
      leds: leds-ss4200: remove DEFINE_PCI_DEVICE_TABLE macro
      leds: lp5562: remove unnecessary parentheses
      leds: blinkm: remove unnecessary spaces
      leds: leds-ss4200: remove __initdata marker
      leds: clevo-mail: remove __initdata marker

Paolo Pisati (1):
      leds-gpio: of: introduce MODULE_DEVICE_TABLE for module autoloading

Paul Gortmaker (1):
      drivers/leds: delete non-required instances of include <linux/init.h>

Pawel Moll (1):
      ledtrig-cpu: Handle CPU hot(un)plugging

Robin Gong (1):
      leds: leds-gpio: add retain-state-suspended property

Russell King (1):
      leds: leds-pwm: properly clean up after probe failure

Sachin Kamat (1):
      leds: leds-s3c24xx: Trivial cleanup in header file

Sasha Levin (1):
      leds: make sure we unregister a trigger only once

Stefan Sørensen (1):
      leds: Turn off led if blinking is disabled

 .../devicetree/bindings/leds/leds-gpio.txt         |  12 ++
 Documentation/devicetree/bindings/mfd/mc13xxx.txt  |  47 +++++
 drivers/leds/Kconfig                               |   4 +-
 drivers/leds/led-core.c                            |   6 +-
 drivers/leds/led-triggers.c                        |   6 +-
 drivers/leds/leds-88pm860x.c                       |   1 -
 drivers/leds/leds-adp5520.c                        |   1 -
 drivers/leds/leds-asic3.c                          |   1 -
 drivers/leds/leds-blinkm.c                         |   3 +-
 drivers/leds/leds-clevo-mail.c                     |   5 +-
 drivers/leds/leds-cobalt-qube.c                    |   1 -
 drivers/leds/leds-da903x.c                         |   1 -
 drivers/leds/leds-da9052.c                         |   1 -
 drivers/leds/leds-fsg.c                            |   1 -
 drivers/leds/leds-gpio.c                           |   6 +-
 drivers/leds/leds-hp6xx.c                          |   1 -
 drivers/leds/leds-lm3533.c                         |   1 -
 drivers/leds/leds-lp5521.c                         |   1 -
 drivers/leds/leds-lp5523.c                         |   1 -
 drivers/leds/leds-lp5562.c                         |   7 +-
 drivers/leds/leds-lt3593.c                         |   1 -
 drivers/leds/leds-mc13783.c                        | 223 ++++++++++++++-------
 drivers/leds/leds-netxbig.c                        |   1 -
 drivers/leds/leds-ns2.c                            |   1 -
 drivers/leds/leds-ot200.c                          |   1 -
 drivers/leds/leds-pwm.c                            |  24 ++-
 drivers/leds/leds-s3c24xx.c                        |   1 -
 drivers/leds/leds-ss4200.c                         |   4 +-
 drivers/leds/leds-wm831x-status.c                  |   1 -
 drivers/leds/leds-wm8350.c                         |   1 -
 drivers/leds/trigger/ledtrig-cpu.c                 |  24 +++
 include/linux/mfd/mc13xxx.h                        |   6 +
 include/linux/platform_data/leds-s3c24xx.h         |   9 +-
 33 files changed, 275 insertions(+), 129 deletions(-)
