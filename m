Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756935AbaDXM2r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:28:47 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:61102 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210AbaDXM2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 08:28:44 -0400
From: Peter Griffin <peter.griffin@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: linaro-kernel@lists.linaro.org, Peter Griffin <peter.griffin@linaro.org>
Subject: [PATCH 00/13] video: Arnds randconfig fixes for video
Date: Thu, 24 Apr 2014 13:28:16 +0100
Message-Id: <1398342509-10243-1-git-send-email-peter.griffin@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset series addresses various bugs found and fixed by Arnd Bergmann 
whilst doing randconfig builds.

My involvement has been to review, add/check the maintainers are correct
and submit upstream to try and reduce the backlog.

Regards,

Peter.

Arnd Bergmann (11):
  video: sh_mobile_lcdcfb depends on meram
  video: omap2dss: fix LPAE warnings
  video: clarify I2C dependencies
  video/omap: fix modular build
  video/mbx: fix building debugfs support
  video: export fb_prepare_logo
  video: atmel needs FB_BACKLIGHT
  video/pxa: LCD_CORGI needs BACKLIGHT_CLASS_DEVICE
  video/nuc900: allow modular build
  video/backlight: LP855X needs PWM
  video: omap: allow building on !MMU

Peter Griffin (2):
  video/backlight: LM3630A needs PWM
  video/backlight: LP8788 needs PWM

 drivers/video/backlight/Kconfig        |    8 ++++----
 drivers/video/fbdev/Kconfig            |    6 +++++-
 drivers/video/fbdev/core/fbmem.c       |    1 +
 drivers/video/fbdev/mbx/Makefile       |    3 +--
 drivers/video/fbdev/mbx/mbxdebugfs.c   |    2 +-
 drivers/video/fbdev/mbx/mbxfb.c        |    2 ++
 drivers/video/fbdev/omap/Kconfig       |    9 +++++++++
 drivers/video/fbdev/omap/Makefile      |   23 ++++++++++++-----------
 drivers/video/fbdev/omap/lcdc.c        |   28 +++++-----------------------
 drivers/video/fbdev/omap/omapfb_main.c |    1 +
 drivers/video/fbdev/omap2/dss/dispc.c  |    6 +++---
 include/linux/omap-dma.h               |    2 +-
 include/video/omapdss.h                |    4 ++--
 13 files changed, 47 insertions(+), 48 deletions(-)

-- 
1.7.9.5

