Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab3HEWUf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:20:35 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:47759 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946Ab3HEWU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:20:29 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: David Airlie <airlied@linux.ie>, Darren Etheridge <detheridge@ti.com>,
        Rob Clark <robdclark@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] Several NXP TDA998x patches
Date: Tue,  6 Aug 2013 00:20:10 +0200
Message-Id: <1375741218-10225-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set picks up several patches sent during the past months
related with NXP TDA998x HDMI transmitter driver. The patches have
been tested on Marvell Dove (Armada DRM) on several HDMI modes with
audio playing on S/PDIF. I have also quickly tested on Beaglebone
Black (tilcdc) for one DVI mode.

As I squashed some patches and fixed some audio issues, it would
be great to have a formal Tested-by or Acked-by from Russell and
Darren for the whole patch set.

Darren Etheridge (2):
  drm/i2c: tda998x: prepare for broken sync workaround
  drm/tilcdc fixup mode to workaound sync for tda998x

Russell King (5):
  drm/i2c: tda998x: fix EDID reading on TDA19988 devices
  drm/i2c: tda998x: ensure VIP output mux is properly set
  drm/i2c: tda998x: fix npix/nline programming
  drm/i2c: tda998x: prepare for video input configuration
  drm/i2c: tda998x: add video and audio input configuration

Sebastian Hesselbarth (1):
  drm/i2c: tda998x: fix sync generation and calculation

 arch/arm/boot/dts/am335x-boneblack.dts |    2 +-
 drivers/gpu/drm/i2c/tda998x_drv.c      |  526 +++++++++++++++++++++++++++-----
 drivers/gpu/drm/tilcdc/tilcdc_crtc.c   |    7 +-
 drivers/gpu/drm/tilcdc/tilcdc_slave.c  |   27 +-
 include/drm/i2c/tda998x.h              |   23 ++
 5 files changed, 507 insertions(+), 78 deletions(-)
 create mode 100644 include/drm/i2c/tda998x.h

---
Cc: David Airlie <airlied@linux.ie>
Cc: Darren Etheridge <detheridge@ti.com>
Cc: Rob Clark <robdclark@gmail.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
-- 
1.7.10.4

