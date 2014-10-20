Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752423AbaJTRwD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 13:52:03 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:49530 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbaJTRwA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 13:52:00 -0400
MIME-Version: 1.0
From: Bryan Wu <cooloney@gmail.com>
Date: Mon, 20 Oct 2014 10:51:39 -0700
Message-ID: <CAK5ve-+RmcoQGD=jz8gHUjWHn1_TnUwZ3kBJrYT2tu_HY+WeVA@mail.gmail.com>
Subject: [GIT PULL] LED subsystem for 3.18 merge window
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Sorry for the delay, hope I can still make this merge window.

Basically we have some bug fixing and clean up and one big thing is we
start to merge patch to add support LED Flash class. So Please
consider the following changes since commit
2ce7598c9a453e0acd0e07be7be3f5eb39608ebd:

  Linux 3.17-rc4 (2014-09-07 16:09:43 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds.git for-next

for you to fetch changes up to a4c84e6aafda0ddd8cb004c464cd11e47e211049:

  leds: gpio: cleanup the leds-gpio driver (2014-09-29 10:22:26 -0700)

----------------------------------------------------------------
Andreas Werner (4):
      mfd: menf21bmc: Introduce MEN 14F021P00 BMC MFD Core driver
      watchdog: menf21bmc_wdt: Introduce MEN 14F021P00 BMC Watchdog driver
      leds: leds-menf21bmc: Introduce MEN 14F021P00 BMC LED driver
      hwmon: (menf21bmc) Introduce MEN14F021P00 BMC HWMON driver

Bryan Wu (1):
      Merge tag 'mfd-hwmon-leds-watchdog-v3.18' into devel

Jacek Anaszewski (5):
      leds: Reorder include directives
      leds: make brightness type consistent across whole subsystem
      leds: avoid using DEVICE_ATTR macro for max_brightness attribute
      leds: lp3944: fix sparse warning
      leds: Improve and export led_update_brightness

Lothar Waßmann (1):
      leds: trigger: gpio: fix warning in gpio trigger for gpios whose
accessor function may sleep

Xiubo Li (3):
      led: gpio: Sort include headers alphabetically
      led: gpio: Fix possible ZERO_SIZE_PTR pointer dereferencing error.
      leds: gpio: cleanup the leds-gpio driver

 Documentation/hwmon/menf21bmc       |  50 ++++++++
 drivers/hwmon/Kconfig               |  10 ++
 drivers/hwmon/Makefile              |   1 +
 drivers/hwmon/menf21bmc_hwmon.c     | 230 ++++++++++++++++++++++++++++++++++++
 drivers/leds/Kconfig                |   9 ++
 drivers/leds/Makefile               |   1 +
 drivers/leds/led-class.c            |  23 ++--
 drivers/leds/led-core.c             |  19 ++-
 drivers/leds/leds-gpio-register.c   |   5 +-
 drivers/leds/leds-gpio.c            |  14 +--
 drivers/leds/leds-lp3944.c          |   3 +-
 drivers/leds/leds-menf21bmc.c       | 131 ++++++++++++++++++++
 drivers/leds/trigger/ledtrig-gpio.c |   2 +-
 drivers/mfd/Kconfig                 |  15 +++
 drivers/mfd/Makefile                |   1 +
 drivers/mfd/menf21bmc.c             | 132 +++++++++++++++++++++
 drivers/watchdog/Kconfig            |  10 ++
 drivers/watchdog/Makefile           |   1 +
 drivers/watchdog/menf21bmc_wdt.c    | 203 +++++++++++++++++++++++++++++++
 include/linux/leds.h                |  16 ++-
 20 files changed, 847 insertions(+), 29 deletions(-)
 create mode 100644 Documentation/hwmon/menf21bmc
 create mode 100644 drivers/hwmon/menf21bmc_hwmon.c
 create mode 100644 drivers/leds/leds-menf21bmc.c
 create mode 100644 drivers/mfd/menf21bmc.c
 create mode 100644 drivers/watchdog/menf21bmc_wdt.c
