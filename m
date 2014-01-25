Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbaA2J0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 04:26:09 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:42085 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbaA2J0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 04:26:05 -0500
X-Mailbox-Line: From 383e7d5309d18830aef19497df4a308f9be39532 Mon Sep 17 00:00:00 2001
Message-Id: <383e7d5309d18830aef19497df4a308f9be39532.1390986083.git.moinejf@free.fr>
In-Reply-To: <cover.1390986082.git.moinejf@free.fr>
References: <cover.1390986082.git.moinejf@free.fr>
From: Jean-Francois Moine <moinejf@free.fr>
Date: Sat, 25 Jan 2014 18:14:40 +0100
Subject: [PATCH v5 20/23] drm/i2c: tda998x: add the active aspect in HDMI AVI
 frame
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The picture aspect setting was zero, which is reserved.
A setting of Same As Picture makes more sense.

Tested-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index 1242da1..dba5b96 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -616,6 +616,7 @@ tda998x_write_avi(struct tda998x_priv *priv, struct drm_display_mode *mode)
 	buf[HB(1)] = 0x02;
 	buf[HB(2)] = HDMI_AVI_INFOFRAME_SIZE;
 	buf[PB(1)] = HDMI_SCAN_MODE_UNDERSCAN;
+	buf[PB(2)] = HDMI_ACTIVE_ASPECT_PICTURE;
 	buf[PB(3)] = HDMI_QUANTIZATION_RANGE_FULL << 2;
 	buf[PB(4)] = drm_match_cea_mode(mode);
 
-- 
1.9.rc1

