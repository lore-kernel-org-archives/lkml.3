Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbaASTCy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 14:02:54 -0500
Received: from smtp2-g21.free.fr ([212.27.42.2]:51720 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831AbaASTCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 14:02:47 -0500
Date: Sun, 19 Jan 2014 19:58:44 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: dri-devel@lists.freedesktop.org
Cc: Dave Airlie <airlied@gmail.com>, Rob Clark <robdclark@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: [PATCH v3 17/24] drm/i2c: tda998x: get a better status of the
 connection
Message-ID: <20140119195844.202f021b@armhf>
In-Reply-To: <cover.1390153344.git.moinejf@free.fr>
References: <cover.1390153344.git.moinejf@free.fr>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch refines the connection status testing both bits RXSENS and
HPD of the CEC register giving the connection level.

Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
---
 drivers/gpu/drm/i2c/tda998x_drv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
index 013a67c..ea7d1b4 100644
--- a/drivers/gpu/drm/i2c/tda998x_drv.c
+++ b/drivers/gpu/drm/i2c/tda998x_drv.c
@@ -1050,7 +1050,9 @@ tda998x_encoder_detect(struct drm_encoder *encoder,
 	struct tda998x_priv *priv = to_tda998x_priv(encoder);
 	uint8_t val = cec_read(priv, REG_CEC_RXSHPDLEV);
 
-	return (val & CEC_RXSHPDLEV_HPD) ? connector_status_connected :
+	return (val & (CEC_RXSHPDLEV_RXSENS | CEC_RXSHPDLEV_HPD)) ==
+				(CEC_RXSHPDLEV_RXSENS | CEC_RXSHPDLEV_HPD) ?
+			connector_status_connected :
 			connector_status_disconnected;
 }
 
-- 
1.8.5.3

