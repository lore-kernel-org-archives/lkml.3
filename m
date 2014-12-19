Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbaLSCBG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 21:01:06 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:34060 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbaLSCBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 21:01:04 -0500
From: Steve Longerbeam <slongerbeam@gmail.com>
X-Google-Original-From: Steve Longerbeam <steve_longerbeam@mentor.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, David Airlie <airlied@linux.ie>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>, Denis Carikli <denis@eukrea.com>,
        Jiada Wang <jiada_wang@mentor.com>,
        Steve Longerbeam <steve_longerbeam@mentor.com>
Subject: [PATCH v2 0/7] imx-drm: ipuv3-crtc: Implement mode_fixup
Date: Thu, 18 Dec 2014 18:00:19 -0800
Message-Id: <1418954426-21909-1-git-send-email-steve_longerbeam@mentor.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset implements ->mode_fixup() in the imx ipuv3-crtc driver,
using a new support function ipu_di_adjust_videomode(). This new
function needs to be subsystem independent, so it accepts a video
mode as a 'struct videomode'. Hence ipu-crtc ->mode_fixup() needs
another support function to convert a drm_display_mode to a videomode
before passing the mode to ipu_di_adjust_videomode() for fixup.

Also some related code cleanup: 'struct ipu_di_signal_cfg' should
use 'struct videomode' for mode timings.


Jiada Wang (1):
  gpu: ipu-di: Add ipu_di_adjust_videomode()

Steve Longerbeam (6):
  gpu: ipu-di: remove some non-functional code
  drm_modes: add videomode_from_drm_display_mode
  imx-drm: ipuv3-crtc: Implement mode_fixup
  imx-drm: encoder prepare/mode_set must use adjusted mode
  gpu: ipu-v3: Use videomode in struct ipu_di_signal_cfg
  gpu: ipu-di: Switch to DIV_ROUND_CLOSEST for DI clock divider calc

 drivers/gpu/drm/drm_modes.c            |   40 +++++++++++
 drivers/gpu/drm/imx/imx-hdmi.c         |    4 +-
 drivers/gpu/drm/imx/imx-ldb.c          |    6 +-
 drivers/gpu/drm/imx/imx-tve.c          |    4 +-
 drivers/gpu/drm/imx/ipuv3-crtc.c       |   38 +++++-----
 drivers/gpu/drm/imx/parallel-display.c |    4 +-
 drivers/gpu/ipu-v3/ipu-di.c            |  121 +++++++++++++++++++-------------
 include/drm/drm_modes.h                |    2 +
 include/video/imx-ipu-v3.h             |   21 ++----
 9 files changed, 147 insertions(+), 93 deletions(-)

-- 
1.7.9.5

