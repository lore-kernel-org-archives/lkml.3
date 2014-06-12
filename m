Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538AbaFLSKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 14:10:34 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:44996 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaFLSKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 14:10:33 -0400
MIME-Version: 1.0
From: Bryan Wu <cooloney@gmail.com>
Date: Thu, 12 Jun 2014 11:10:10 -0700
Message-ID: <CAK5ve-+H7xamv9brhfJzDSi=6XiOo_UPn4BE5QXtc4X7C+RKqQ@mail.gmail.com>
Subject: [GIT PULL] LED updates for 3.16
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I just found merge window is open and I'm quite busy and almost forget
to send out this pull request. Thanks Russell and Alexandre ping me
about this.

So basically we got some clean up and leds-pwm fixing patches from Russell.

Please consider the following changes since commit
89ca3b881987f5a4be4c5dbaa7f0df12bbdde2fd:

  Linux 3.15-rc4 (2014-05-04 18:14:42 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds.git for-next

for you to fetch changes up to 0c9a03b68511daf078256367e7a98d7ff3b7dfcb:

  leds: Remove duplicated OOM message for individual driver
(2014-05-08 14:28:08 +0800)

----------------------------------------------------------------
Alex Hung (1):
      dell-led: add mic mute led interface

Axel Lin (1):
      leds: pca9685: Remove leds-pca9685 driver

Christoph Lameter (1):
      drivers/leds: Replace __get_cpu_var use through this_cpu_ptr

Daniel Mack (1):
      leds: lp55xx: add DT bindings for LP55231

Krzysztof Kozlowski (2):
      leds: 88pm860x: Use of_get_child_by_name
      leds: 88pm860x: Fix missing refcount decrement for parent of_node

Russell King (4):
      leds: leds-pwm: provide a common function to setup a single led-pwm device
      leds: leds-pwm: convert OF parsing code to use led_pwm_add()
      leds: leds-pwm: implement PWM inversion
      leds: leds-pwm: add DT support for LEDs wired to supply

Xiubo Li (1):
      leds: Remove duplicated OOM message for individual driver

 .../devicetree/bindings/leds/leds-lp55xx.txt       |   8 +-
 .../devicetree/bindings/leds/leds-pwm.txt          |   2 +
 drivers/leds/Kconfig                               |  10 -
 drivers/leds/Makefile                              |   1 -
 drivers/leds/dell-led.c                            | 171 ++++++++++++++++-
 drivers/leds/leds-88pm860x.c                       |   5 +-
 drivers/leds/leds-adp5520.c                        |   5 +-
 drivers/leds/leds-bd2802.c                         |   4 +-
 drivers/leds/leds-da903x.c                         |   4 +-
 drivers/leds/leds-da9052.c                         |   3 +-
 drivers/leds/leds-lp5523.c                         |   3 +-
 drivers/leds/leds-pca9685.c                        | 213 ---------------------
 drivers/leds/leds-pwm.c                            | 144 +++++++-------
 drivers/leds/leds-s3c24xx.c                        |   4 +-
 drivers/leds/leds-sunfire.c                        |   4 +-
 drivers/leds/trigger/ledtrig-cpu.c                 |   2 +-
 include/linux/dell-led.h                           |  10 +
 include/linux/platform_data/leds-pca9685.h         |  35 ----
 18 files changed, 264 insertions(+), 364 deletions(-)
 delete mode 100644 drivers/leds/leds-pca9685.c
 create mode 100644 include/linux/dell-led.h
 delete mode 100644 include/linux/platform_data/leds-pca9685.h
