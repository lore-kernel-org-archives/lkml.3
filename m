Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200Ab3KLAVB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 19:21:01 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:37898 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab3KLAUw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 19:20:52 -0500
MIME-Version: 1.0
From: Bryan Wu <cooloney@gmail.com>
Date: Mon, 11 Nov 2013 16:20:30 -0800
Message-ID: <CAK5ve-LOqn9gpxuvZ=Zx9deHGpuwXt=f-jRARe94wqj54k8Ybw@mail.gmail.com>
Subject: [GIT PULL] leds: updates for 3.13
To: Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

LED subsystem updates for 3.13 are basically cleanup and also add a
new driver for PCA9685.

So please consider the following changes since commit
31d141e3a666269a3b6fcccddb0351caf7454240:

  Linux 3.12-rc6 (2013-10-19 12:28:15 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds.git for-next

for you to fetch changes up to 30dae2f98612d7c8cd855861b9de205ebd9ef4fa:

  leds: lp55xx: handle enable pin in driver (2013-10-25 10:13:25 -0700)

----------------------------------------------------------------
Bryan Wu (1):
      of: introduce of_get_available_child_count

Josh Wu (1):
      leds-gpio: of: led should not be created if its status is disabled

Linus Walleij (1):
      leds: lp55xx: enable setting default trigger

Maximilian Güntner (1):
      leds: Added driver for the NXP PCA9685 I2C chip

Sachin Kamat (4):
      leds: blinkm: Remove redundant break
      leds: dac124s085: Remove redundant spi_set_drvdata
      leds: Include linux/of.h header
      leds: pwm: Remove redundant of_match_ptr

Sebastian Reichel (1):
      leds: lp55xx: handle enable pin in driver

 .../devicetree/bindings/leds/leds-lp55xx.txt       |  11 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c       |  20 +-
 arch/arm/mach-ux500/board-mop500.c                 |   2 +
 drivers/leds/Kconfig                               |  10 +
 drivers/leds/Makefile                              |   1 +
 drivers/leds/leds-blinkm.c                         |   3 -
 drivers/leds/leds-dac124s085.c                     |   3 -
 drivers/leds/leds-gpio.c                           |   7 +-
 drivers/leds/leds-lp5523.c                         |   1 +
 drivers/leds/leds-lp5562.c                         |   1 +
 drivers/leds/leds-lp55xx-common.c                  |  28 +--
 drivers/leds/leds-lp8501.c                         |   1 +
 drivers/leds/leds-ns2.c                            |   1 +
 drivers/leds/leds-pca9685.c                        | 213 +++++++++++++++++++++
 drivers/leds/leds-pwm.c                            |   2 +-
 include/linux/of.h                                 |  16 ++
 include/linux/platform_data/leds-lp55xx.h          |   7 +-
 include/linux/platform_data/leds-pca9685.h         |  35 ++++
 18 files changed, 314 insertions(+), 48 deletions(-)
 create mode 100644 drivers/leds/leds-pca9685.c
 create mode 100644 include/linux/platform_data/leds-pca9685.h
