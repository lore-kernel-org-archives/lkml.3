Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760302Ab3HNTno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 15:43:44 -0400
Received: from mail-ea0-f178.google.com ([209.85.215.178]:39981 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760145Ab3HNTnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 15:43:40 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: David Airlie <airlied@linux.ie>, Darren Etheridge <detheridge@ti.com>,
        Rob Clark <robdclark@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/8] Several NXP TDA998x patches
Date: Wed, 14 Aug 2013 21:43:25 +0200
Message-Id: <1376509413-1462-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set picks up several patches sent during the past months
related with NXP TDA998x HDMI transmitter driver. The patches have
been tested on Marvell Dove (Armada DRM) on several HDMI and DVI modes
with audio playing on S/PDIF.

I bumped all patches to v2, although only patches 2, 5, and 6 have
changed. I also fixed a typo in commit line of patch 8. As Darren
Etheridge already gave his Tested-by and tilcdc related patches have
not changed, I added it to all patches for v2, too.

I have not added Russell King's Tested-by, as I hope he will have a
close look at what I changed after his review comments.

Darren Etheridge (1):
  drm/tilcdc fixup mode to workaround sync for tda998x

Russell King (5):
  drm/i2c: tda998x: fix EDID reading on TDA19988 devices
  drm/i2c: tda998x: ensure VIP output mux is properly set
  drm/i2c: tda998x: fix npix/nline programming
  drm/i2c: tda998x: prepare for video input configuration
  drm/i2c: tda998x: add video and audio input configuration

Sebastian Hesselbarth (2):
  drm/i2c: tda998x: fix sync generation and calculation
  drm/i2c: tda998x: prepare for broken sync workaround

 drivers/gpu/drm/i2c/tda998x_drv.c     |  481 +++++++++++++++++++++++++++------
 drivers/gpu/drm/tilcdc/tilcdc_crtc.c  |    7 +-
 drivers/gpu/drm/tilcdc/tilcdc_slave.c |   27 +-
 include/drm/i2c/tda998x.h             |   30 ++
 4 files changed, 467 insertions(+), 78 deletions(-)
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

