Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbaA1Bcx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 20:32:53 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:44051 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbaA1Bcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 20:32:51 -0500
MIME-Version: 1.0
From: Bryan Wu <cooloney@gmail.com>
Date: Mon, 27 Jan 2014 17:32:29 -0800
Message-ID: <CAK5ve-JFvsN5RM3TY-p=LWVNK0cYcjH3FWMiZd-PuUtnVnTMnA@mail.gmail.com>
Subject: [GIT PULL] LED updates for 3.14
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus

Basically this cycle is most cleanup for LED subsystem.

Please consider the following changes since commit
802eee95bde72fd0cd0f3a5b2098375a487d1eda:

  Linux 3.13-rc6 (2013-12-29 16:01:33 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds.git for-next

for you to fetch changes up to 3cb6f44aedf519dce4a9106dec675b94d675c539:

  leds: s3c24xx: Remove hardware.h inclusion (2014-01-27 17:28:53 -0800)

----------------------------------------------------------------
Alexander Shiyan (2):
      leds: leds-mc13783: Remove duplicate field in platform data
      leds: leds-mc13783: Remove unneeded mc13xxx_{un}lock

Chen Gang (1):
      drivers: leds: leds-tca6507: check CONFIG_GPIOLIB whether
defined for 'gpio_base'

Milo Kim (2):
      leds: lp5521/5523: Fix multiple engine usage bug
      leds: lp5523: Support LED MUX configuration on running a pattern

NeilBrown (3):
      LEDS: tca6507 - fix bugs in parsing of device-tree configuration.
      LEDS: tca6507: add device-tree support for GPIO configuration.
      LEDS: tca6507 - fix up some comments.

Olof Johansson (1):
      leds: pwm: Remove a warning on non-DT platforms

Sachin Kamat (2):
      leds: kirkwood: Cleanup in header files
      leds: s3c24xx: Remove hardware.h inclusion

Xiubo Li (1):
      leds: leds-pwm: fix duty time overflow.

ZHAO Gang (1):
      leds: replace list_for_each with list_for_each_entry

 Documentation/devicetree/bindings/leds/tca6507.txt |  16 ++
 Documentation/leds/leds-lp55xx.txt                 |  10 +-
 arch/arm/mach-imx/mach-mx31moboard.c               |  16 +-
 drivers/leds/led-triggers.c                        |  15 +-
 drivers/leds/leds-lp5521.c                         |  18 +-
 drivers/leds/leds-lp5523.c                         |  20 +-
 drivers/leds/leds-lp55xx-common.c                  |   2 +
 drivers/leds/leds-mc13783.c                        |  89 +--------
 drivers/leds/leds-pwm.c                            |   9 +-
 drivers/leds/leds-s3c24xx.c                        |   3 +-
 drivers/leds/leds-tca6507.c                        | 207 ++++++++++++---------
 include/linux/mfd/mc13xxx.h                        |  37 +++-
 .../linux/platform_data/leds-kirkwood-netxbig.h    |   8 +-
 include/linux/platform_data/leds-kirkwood-ns2.h    |   8 +-
 14 files changed, 227 insertions(+), 231 deletions(-)
