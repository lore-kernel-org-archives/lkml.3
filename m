Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403AbaLOVg2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 16:36:28 -0500
Received: from mail-ig0-f177.google.com ([209.85.213.177]:49854 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbaLOVg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 16:36:27 -0500
MIME-Version: 1.0
From: Bryan Wu <cooloney@gmail.com>
Date: Mon, 15 Dec 2014 13:36:06 -0800
Message-ID: <CAK5ve-+vs3vZWH5zBVBKV1+-Uo-v_LZSOy-5Tqojoq_TmvfFrw@mail.gmail.com>
Subject: [GIT PULL] LED subsystem for 3.19 merge window
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

We got some cleanup and driver for LP8860 as well as some patches for
LED Flash Class. So please consider the following changes since commit
206c5f60a3d902bc4b56dab2de3e88de5eb06108:

  Linux 3.18-rc4 (2014-11-09 14:55:29 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds.git for-next

for you to fetch changes up to 2969bb18f8895eb4e0fbbc98efe706f15a3acff5:

  leds: lp8860: Fix module dependency (2014-12-01 14:49:42 -0800)

----------------------------------------------------------------
Axel Lin (2):
      leds: regulator: Convert to devm_regulator_get_exclusive
      leds: lp8860: Fix module dependency

Dan Murphy (1):
      leds: lp8860: Introduce TI lp8860 4 channel LED driver

Jacek Anaszewski (2):
      leds: implement sysfs interface locking mechanism
      leds: Add support for setting brightness in a synchronous way

Linus Walleij (2):
      leds: delete copy/paste mistake
      leds: syscon: handle multiple syscon instances

 .../devicetree/bindings/leds/leds-lp8860.txt       |  29 ++
 drivers/leds/Kconfig                               |  11 +
 drivers/leds/Makefile                              |   1 +
 drivers/leds/led-class.c                           |  29 +-
 drivers/leds/led-core.c                            |  36 +-
 drivers/leds/led-triggers.c                        |  16 +-
 drivers/leds/leds-lp8860.c                         | 491 +++++++++++++++++++++
 drivers/leds/leds-regulator.c                      |  18 +-
 drivers/leds/leds-syscon.c                         |  71 +--
 drivers/leds/leds.h                                |  20 +-
 drivers/leds/trigger/ledtrig-backlight.c           |   8 +-
 drivers/leds/trigger/ledtrig-default-on.c          |   2 +-
 drivers/leds/trigger/ledtrig-gpio.c                |   6 +-
 drivers/leds/trigger/ledtrig-heartbeat.c           |   2 +-
 drivers/leds/trigger/ledtrig-oneshot.c             |   4 +-
 drivers/leds/trigger/ledtrig-transient.c           |  10 +-
 include/linux/leds.h                               |  40 ++
 17 files changed, 714 insertions(+), 80 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/leds/leds-lp8860.txt
 create mode 100644 drivers/leds/leds-lp8860.c
