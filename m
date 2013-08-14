Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932934Ab3HNTqF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 15:46:05 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:44267 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760184Ab3HNTnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 15:43:41 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        David Airlie <airlied@linux.ie>, Darren Etheridge <detheridge@ti.com>,
        Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/8] drm/i2c: tda998x: fix npix/nline programming
Date: Wed, 14 Aug 2013 21:43:28 +0200
Message-Id: <1376509413-1462-4-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376509413-1462-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1376509413-1462-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King <rmk+kernel@arm.linux.org.uk>

The npix/nline registers are supposed to be programmed with the total
number of pixels/lines, not the displayed pixels/lines, and not minus
one either.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Tested-by: Darren Etheridge <detheridge@ti.com>
Tested-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: David Airlie <airlied@linux.ie>
Cc: Darren Etheridge <detheridge@ti.com>
Cc: Rob Clark <robdclark@gmail.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/gpu/drm/i2c/tda998x_drv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index cb9b13a..a701411 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -587,8 +587,8 @@ tda998x_encoder_mode_set(struct drm_encoder *encoder,
 		reg_set(encoder, REG_VIP_CNTRL_3, VIP_CNTRL_3_H_TGL);
 
 	reg_write(encoder, REG_VIDFORMAT, 0x00);
-	reg_write16(encoder, REG_NPIX_MSB, mode->hdisplay - 1);
-	reg_write16(encoder, REG_NLINE_MSB, mode->vdisplay - 1);
+	reg_write16(encoder, REG_NPIX_MSB, mode->htotal);
+	reg_write16(encoder, REG_NLINE_MSB, mode->vtotal);
 	reg_write16(encoder, REG_VS_LINE_STRT_1_MSB, line_start);
 	reg_write16(encoder, REG_VS_LINE_END_1_MSB, line_end);
 	reg_write16(encoder, REG_VS_PIX_STRT_1_MSB, hs_start);
-- 
1.7.10.4

