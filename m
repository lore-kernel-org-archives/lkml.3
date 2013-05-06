Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab3EFSJY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 14:09:24 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:36832 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab3EFSJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 14:09:22 -0400
MIME-Version: 1.0
From: Bryan Wu <cooloney@gmail.com>
Date: Mon, 6 May 2013 11:09:00 -0700
Message-ID: <CAK5ve-+iX_fR3XYMPpSJOqGDg_jQSf4_sVUeb4j0=+Yx6-2eag@mail.gmail.com>
Subject: [GIT PULL] leds: updates for 3.10
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

LED subsystem updates for 3.10:
 - move LED trigger drivers into a new directory
 - lp55xx common driver updates
 - other led drivers updates and bug fixing

So please consider the following changes since commit
07961ac7c0ee8b546658717034fe692fd12eefa9:

  Linux 3.9-rc5 (2013-03-31 15:12:43 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds.git for-next

for you to fetch changes up to df92d5ff5e70999274f53884cc2c40ae620a109a:

  leds: leds-asic3: switch to using SIMPLE_DEV_PM_OPS (2013-04-01
11:04:54 -0700)

----------------------------------------------------------------
Florian Vaussard (1):
      leds: leds-pwm: Defer led_pwm_set() if PWM can sleep

Jingoo Han (7):
      leds: atmel-pwm: remove erroneous __exit annotation
      leds: leds-bd2802: remove erroneous __exit annotation
      leds: leds-lt3593: set devm_gpio_request_one() flags param correctly
      leds: leds-ns2: set devm_gpio_request_one() flags param correctly
      leds: renesas: set gpio_request_one() flags param correctly
      leds: leds-bd2802: add CONFIG_PM_SLEEP to suspend/resume functions
      leds: leds-asic3: switch to using SIMPLE_DEV_PM_OPS

Kim, Milo (8):
      leds: add new LP5562 LED driver
      leds: move LED trigger drivers into new subdirectory
      leds: trigger: use inline functions instead of macros
      leds: add camera LED triggers
      leds: lm355x, lm3642: support camera LED triggers for flash and torch
      leds: lp55xx: fix the sysfs read operation
      leds: lp55xx: use common clock framework when external clock is used
      leds: lp55xx: configure the clock detection

Mark Brown (1):
      leds: wm8350: Complain if we fail to reenable DCDC

Sachin Kamat (1):
      leds: tca6507: Use of_match_ptr() macro

Simon Guinot (1):
      leds: leds-ns2: fix oops at module removal

 Documentation/leds/00-INDEX                     |   2 +
 Documentation/leds/leds-lp5521.txt              |  19 -
 Documentation/leds/leds-lp5562.txt              | 120 +++++
 Documentation/leds/leds-lp55xx.txt              |  46 +-
 drivers/leds/Kconfig                            | 115 +----
 drivers/leds/Makefile                           |  11 +-
 drivers/leds/leds-asic3.c                       |   7 +-
 drivers/leds/leds-atmel-pwm.c                   |   4 +-
 drivers/leds/leds-bd2802.c                      |  14 +-
 drivers/leds/leds-lm355x.c                      |   2 +
 drivers/leds/leds-lm3642.c                      |   2 +
 drivers/leds/leds-lp5521.c                      |  22 +-
 drivers/leds/leds-lp5562.c                      | 599 ++++++++++++++++++++++++
 drivers/leds/leds-lp55xx-common.c               |  42 +-
 drivers/leds/leds-lp55xx-common.h               |   4 +
 drivers/leds/leds-lt3593.c                      |   5 +-
 drivers/leds/leds-ns2.c                         |  44 +-
 drivers/leds/leds-pwm.c                         |  50 +-
 drivers/leds/leds-renesas-tpu.c                 |   3 +-
 drivers/leds/leds-tca6507.c                     |   4 +-
 drivers/leds/leds-wm8350.c                      |   5 +-
 drivers/leds/trigger/Kconfig                    | 111 +++++
 drivers/leds/trigger/Makefile                   |  10 +
 drivers/leds/{ => trigger}/ledtrig-backlight.c  |   2 +-
 drivers/leds/trigger/ledtrig-camera.c           |  57 +++
 drivers/leds/{ => trigger}/ledtrig-cpu.c        |   2 +-
 drivers/leds/{ => trigger}/ledtrig-default-on.c |   2 +-
 drivers/leds/{ => trigger}/ledtrig-gpio.c       |   2 +-
 drivers/leds/{ => trigger}/ledtrig-heartbeat.c  |   2 +-
 drivers/leds/{ => trigger}/ledtrig-ide-disk.c   |   0
 drivers/leds/{ => trigger}/ledtrig-oneshot.c    |   2 +-
 drivers/leds/{ => trigger}/ledtrig-timer.c      |   1 -
 drivers/leds/{ => trigger}/ledtrig-transient.c  |   2 +-
 include/linux/leds.h                            |  33 +-
 include/linux/mmc/host.h                        |   2 -
 include/linux/platform_data/leds-lp55xx.h       |  21 +-
 36 files changed, 1149 insertions(+), 220 deletions(-)
 create mode 100644 Documentation/leds/leds-lp5562.txt
 create mode 100644 drivers/leds/leds-lp5562.c
 create mode 100644 drivers/leds/trigger/Kconfig
 create mode 100644 drivers/leds/trigger/Makefile
 rename drivers/leds/{ => trigger}/ledtrig-backlight.c (99%)
 create mode 100644 drivers/leds/trigger/ledtrig-camera.c
 rename drivers/leds/{ => trigger}/ledtrig-cpu.c (99%)
 rename drivers/leds/{ => trigger}/ledtrig-default-on.c (98%)
 rename drivers/leds/{ => trigger}/ledtrig-gpio.c (99%)
 rename drivers/leds/{ => trigger}/ledtrig-heartbeat.c (99%)
 rename drivers/leds/{ => trigger}/ledtrig-ide-disk.c (100%)
 rename drivers/leds/{ => trigger}/ledtrig-oneshot.c (99%)
 rename drivers/leds/{ => trigger}/ledtrig-timer.c (99%)
 rename drivers/leds/{ => trigger}/ledtrig-transient.c (99%)
