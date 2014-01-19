Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484AbaASTBE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 14:01:04 -0500
Received: from smtp2-g21.free.fr ([212.27.42.2]:60095 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393AbaASTA7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 14:00:59 -0500
Date: Sun, 19 Jan 2014 19:58:40 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH v3 08/24] drm/i2c: tda998x: fix bad value in the AIF
Message-ID: <20140119195840.57b5214d@armhf>
In-Reply-To: <cover.1390153344.git.moinejf@free.fr>
References: <cover.1390153344.git.moinejf@free.fr>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AIF has an uninitialized byte. This patch clears the whole buffer
before filling it.

Tested-by: Russell King <rmk+kernel@arm.linux.org.uk>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index 5d82301..78d324b 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -551,10 +551,10 @@ tda998x_write_aif(struct tda998x_priv *priv, struct tda998x_encoder_params *p)
 {
 	uint8_t buf[PB(5) + 1];
 
+	memset(buf, 0, sizeof(buf));
 	buf[HB(0)] = 0x84;
 	buf[HB(1)] = 0x01;
 	buf[HB(2)] = 10;
-	buf[PB(0)] = 0;
 	buf[PB(1)] = p->audio_frame[1] & 0x07; /* CC */
 	buf[PB(2)] = p->audio_frame[2] & 0x1c; /* SF */
 	buf[PB(4)] = p->audio_frame[4];
-- 
1.8.5.3

