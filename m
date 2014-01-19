Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006AbaASTDt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 14:03:49 -0500
Received: from smtp2-g21.free.fr ([212.27.42.2]:55878 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752916AbaASTDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 14:03:44 -0500
Date: Sun, 19 Jan 2014 19:58:47 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH v3 22/24] drm/i2c: tda998x: change the frequence in the
 audio channel
Message-ID: <20140119195847.646a40b0@armhf>
In-Reply-To: <cover.1390153344.git.moinejf@free.fr>
References: <cover.1390153344.git.moinejf@free.fr>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch sets the frequence as 'not indicated' instead of '48kHz'
and adds some comments.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index 05713f7..2fcc432 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -745,10 +745,11 @@ tda998x_configure_audio(struct tda998x_priv *priv,
 	reg_clear(priv, REG_AIP_CNTRL_0, AIP_CNTRL_0_RST_CTS);
 
 	/* Write the channel status */
-	buf[0] = 0x04;
+	buf[0] = (1 << 2);			/* copyright unprotected */
 	buf[1] = 0x00;
-	buf[2] = 0x00;
-	buf[3] = 0xf1;
+	buf[2] = 1;				/* freq not indicated */
+	buf[3] = (0 << 4) |			/* orig freq = not indicated */
+			1;			/* max word length 24 bits */
 	reg_write_range(priv, REG_CH_STAT_B(0), buf, 4);
 
 	tda998x_audio_mute(priv, true);
-- 
1.8.5.3

