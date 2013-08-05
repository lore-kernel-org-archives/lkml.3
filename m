Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab3HEWUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:20:32 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:48369 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706Ab3HEWU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:20:28 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        David Airlie <airlied@linux.ie>, Darren Etheridge <detheridge@ti.com>,
        Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/8] drm/i2c: tda998x: fix npix/nline programming
Date: Tue,  6 Aug 2013 00:20:13 +0200
Message-Id: <1375741218-10225-4-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1375741218-10225-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1375741218-10225-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King <rmk+kernel@arm.linux.org.uk>

The npix/nline registers are supposed to be programmed with the total
number of pixels/lines, not the displayed pixels/lines, and not minus
one either.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
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
index 4b4db95..da2917b 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -586,8 +586,8 @@ tda998x_encoder_mode_set(struct drm_encoder *encoder,
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

