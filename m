Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154AbaFRWbm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 18:31:42 -0400
Received: from mout.gmx.net ([212.227.15.19]:64068 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754933AbaFRWbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 18:31:40 -0400
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sergio Aguirre <sergio.a.aguirre@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH 1/1] [media] v4l: omap4iss: configuration using uninitialized variable
Date: Thu, 19 Jun 2014 00:31:27 +0200
Message-Id: <1403130687-28598-1-git-send-email-xypron.glpk@gmx.de>
X-Mailer: git-send-email 2.0.0
X-Provags-ID: V03:K0:nN/PtnGhqcUBp6752fBSAvFM9kL7TkjvKkdBB0EGy/tL5T+S87o
 mKFXtksu4C8yMDcGaGlyuKvTlFdvcxHe699fptkGn6ruNOvFMxpU9+MFzyB6fAPH3M2O/RS
 h/scSfO3cx0LZJt0ovH/V5shvqss1/+z/ZAgB5PExYJ7gjQWWvfYw2SGa+D9rmdOK64yK2h
 WDRKAvTPIlNpusFod6l+g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable reg is not initialized.
Random values are written to OMAP4 ISS registers if !ctx->eof_enabled.

Signed-off-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
---
 drivers/staging/media/omap4iss/iss_csi2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/omap4iss/iss_csi2.c b/drivers/staging/media/omap4iss/iss_csi2.c
index bf8a657..9ae4871 100644
--- a/drivers/staging/media/omap4iss/iss_csi2.c
+++ b/drivers/staging/media/omap4iss/iss_csi2.c
@@ -317,7 +317,7 @@ static void csi2_ctx_enable(struct iss_csi2_device *csi2, u8 ctxnum, u8 enable)
 static void csi2_ctx_config(struct iss_csi2_device *csi2,
 			    struct iss_csi2_ctx_cfg *ctx)
 {
-	u32 reg;
+	u32 reg = 0;
 
 	/* Set up CSI2_CTx_CTRL1 */
 	if (ctx->eof_enabled)
-- 
2.0.0

