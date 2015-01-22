Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291AbbAVDQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 22:16:50 -0500
Received: from regular2.263xmail.com ([211.157.152.3]:49762 "EHLO
	regular2.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbbAVDQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 22:16:42 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-ADDR-CHECKED: 0
X-RL-SENDER: mark.yao@rock-chips.com
X-FST-TO: airlied@linux.ie
X-SENDER-IP: 172.245.202.11
X-LOGIN-NAME: mark.yao@rock-chips.com
X-UNIQUE-TAG: <6f3d1fdcdc93bcba0b2001f9b836745f>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 5
From: Mark Yao <mark.yao@rock-chips.com>
To: David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        Rob Clark <robdclark@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Daniel Kurtz <djkurtz@chromium.org>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org
Cc: Mark Yao <mark.yao@rock-chips.com>
Subject: [PATCH] drm/rockchip: vop: fix vop vsync/hsync polarity
Date: Thu, 22 Jan 2015 11:15:02 +0800
Message-Id: <1421896502-9943-1-git-send-email-mark.yao@rock-chips.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vop set wrong vsync/hsync polarity, it may cause some
display problem. known problem is that caused HDMI hdcp
authenticate failed, caused pixel offset with hdmi display.
the polarity description at RK3288 TRM doc:
  dsp_vsync_pol
    VSYNC polarity
      1'b0 : negative
      1'b1 : positive
      dsp_hsync_pol
    HSYNC polarity
      1'b0 : negative
      1'b1 : positive

Signed-off-by: Mark Yao <mark.yao@rock-chips.com>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
index 9a5c571..2b145ba5 100644
--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop.c
@@ -874,8 +874,8 @@ static int vop_crtc_mode_set(struct drm_crtc *crtc,
 	VOP_CTRL_SET(vop, out_mode, vop->connector_out_mode);
 
 	val = 0x8;
-	val |= (adjusted_mode->flags & DRM_MODE_FLAG_NHSYNC) ? 1 : 0;
-	val |= (adjusted_mode->flags & DRM_MODE_FLAG_NVSYNC) ? (1 << 1) : 0;
+	val |= (adjusted_mode->flags & DRM_MODE_FLAG_NHSYNC) ? 0 : 1;
+	val |= (adjusted_mode->flags & DRM_MODE_FLAG_NVSYNC) ? 0 : (1 << 1);
 	VOP_CTRL_SET(vop, pin_pol, val);
 
 	VOP_CTRL_SET(vop, htotal_pw, (htotal << 16) | hsync_len);
-- 
1.7.9.5


