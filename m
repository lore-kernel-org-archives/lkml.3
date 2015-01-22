Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbbAVKbG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 05:31:06 -0500
Received: from regular1.263xmail.com ([211.150.99.130]:56588 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbbAVKaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 05:30:55 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-ADDR-CHECKED: 0
X-RL-SENDER: mark.yao@rock-chips.com
X-FST-TO: airlied@linux.ie
X-SENDER-IP: 192.69.251.64
X-LOGIN-NAME: mark.yao@rock-chips.com
X-UNIQUE-TAG: <4d9ff3ff20900b70eb998d546a9bb5b9>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Mark Yao <mark.yao@rock-chips.com>
To: David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        Rob Clark <robdclark@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Daniel Kurtz <djkurtz@chromium.org>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org
Cc: Mark Yao <mark.yao@rock-chips.com>
Subject: [PATCH v2 0/2] drm/rockchip: Optimization vop dpms control
Date: Thu, 22 Jan 2015 18:29:55 +0800
Message-Id: <1421922597-18351-1-git-send-email-mark.yao@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drm dpms have many power modes, ON,OFF,SUSPEND,STANDBY, etc.
but vop only have enable/disable mode, maybe case such bug:
 --> DRM_DPMS_ON: power on vop
 --> DRM_DPMS_SUSPEND: power off vop
 --> DRM_DPMS_OFF: already power off at SUSPEND, crash
so use a bool val is more suitable.

another problem at vop_crtc_dpms:
  vop_enable()->drm_vblank_on, drm_vblank_on may call vop
enable vblank. if it happen, vblank enable would failed,
then cause irq status error. because is_enabled value is set
after drm_vblank_on.

Changes in v2:
- fix mistake that set is_enabled wrong.

Mark Yao (2):
  drm/rockchip: vop use is_enabled instead of dpms mode
  drm/rockchip: vop: set vop enabled after enable iommu

 drivers/gpu/drm/rockchip/rockchip_drm_fbdev.c |    2 +-
 drivers/gpu/drm/rockchip/rockchip_drm_gem.c   |   17 +++++------------
 drivers/gpu/drm/rockchip/rockchip_drm_gem.h   |    3 +--
 3 files changed, 7 insertions(+), 15 deletions(-)

-- 
1.7.9.5


