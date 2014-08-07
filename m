Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932307AbaHGNJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 09:09:18 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:42720 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519AbaHGNJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 09:09:17 -0400
Date: Thu, 7 Aug 2014 14:09:11 +0100
From: Lee Jones <lee.jones@linaro.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] Backlight for v3.17 merge-window
Message-ID: <20140807130911.GA21618@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

 The following changes since commit a497c3ba1d97fc69c1e78e7b96435ba8c2cb42ee:

  Linux 3.16-rc2 (2014-06-21 19:02:54 -1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lee/backlight.git tags/backlight-for-linus-3.17

for you to fetch changes up to 87464cdba2aeec196e75908fbbeaf4a26753637a:

  backlight: ipaq_micro: Fix sparse non static symbol warning (2014-07-31 10:31:22 +0100)

----------------------------------------------------------------
 == Changes to existing drivers ==
  - Remove get brightness implementations in via-pmu-backlight samsung-q10
        aat2870_bl ams369fg06 bd6107 gpio_backlight ld9040 lp855x_bl lp8788_bl
	lv5207lp pandora_bl pwm_bl s6e63m0 tps65217_bl aty128fb atyfb_base
	radeon_backlight s6e8ax0 nv_backlight riva/fbdev
  - Improve error handling in jornada720_lcd
  - Make use of new 'get optional' GPIO command in pwm_bl
  - Fix sparse warning in ipaq_micro_bl

 == New drivers/supported devices ==
  - Add new driver for iPAQ

 == (Re-)moved drivers ==
  - None
----------------------------------------------------------------
Alexandre Courbot (1):
      backlight: pwm-backlight: Use devm_gpiod_get_optional()

Andrzej Hajda (2):
      backlight: Remove trivial get_brightness implementations
      backlight: Show brightness even if get_brightness is not implemented

Lee Jones (1):
      backlight: jornada720: Minimise code duplication and handle errors better

Linus Walleij (1):
      backlight: Add driver for iPAQ micro backlight

Wei Yongjun (1):
      backlight: ipaq_micro: Fix sparse non static symbol warning

 drivers/macintosh/via-pmu-backlight.c      |  6 ---
 drivers/platform/x86/samsung-q10.c         |  6 ---
 drivers/video/backlight/Kconfig            |  9 ++++
 drivers/video/backlight/Makefile           |  1 +
 drivers/video/backlight/aat2870_bl.c       |  6 ---
 drivers/video/backlight/ams369fg06.c       |  6 ---
 drivers/video/backlight/backlight.c        |  2 +
 drivers/video/backlight/bd6107.c           |  6 ---
 drivers/video/backlight/gpio_backlight.c   |  6 ---
 drivers/video/backlight/ipaq_micro_bl.c    | 83 ++++++++++++++++++++++++++++++
 drivers/video/backlight/jornada720_lcd.c   | 37 ++++++-------
 drivers/video/backlight/ld9040.c           |  6 ---
 drivers/video/backlight/lp855x_bl.c        |  6 ---
 drivers/video/backlight/lp8788_bl.c        |  6 ---
 drivers/video/backlight/lv5207lp.c         |  6 ---
 drivers/video/backlight/pandora_bl.c       |  6 ---
 drivers/video/backlight/pwm_bl.c           | 13 +----
 drivers/video/backlight/s6e63m0.c          |  6 ---
 drivers/video/backlight/tps65217_bl.c      |  6 ---
 drivers/video/fbdev/aty/aty128fb.c         |  6 ---
 drivers/video/fbdev/aty/atyfb_base.c       |  6 ---
 drivers/video/fbdev/aty/radeon_backlight.c |  6 ---
 drivers/video/fbdev/exynos/s6e8ax0.c       |  6 ---
 drivers/video/fbdev/nvidia/nv_backlight.c  |  6 ---
 drivers/video/fbdev/riva/fbdev.c           |  6 ---
 25 files changed, 116 insertions(+), 143 deletions(-)
 create mode 100644 drivers/video/backlight/ipaq_micro_bl.c

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
