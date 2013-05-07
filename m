Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757070Ab3EGTcX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 15:32:23 -0400
Received: from smtp.outflux.net ([198.145.64.163]:39357 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973Ab3EGTcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 15:32:22 -0400
Date: Tue, 7 May 2013 12:32:16 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: [PATCH] drm: refactor call to request_module
Message-ID: <20130507193216.GA2214@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reduces the size of the stack frame when calling request_module().
Performing the sprintf before the call is not needed.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/gpu/drm/drm_encoder_slave.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/drm_encoder_slave.c b/drivers/gpu/drm/drm_encoder_slave.c
index 48c52f7..0cfb60f 100644
--- a/drivers/gpu/drm/drm_encoder_slave.c
+++ b/drivers/gpu/drm/drm_encoder_slave.c
@@ -54,16 +54,12 @@ int drm_i2c_encoder_init(struct drm_device *dev,
 			 struct i2c_adapter *adap,
 			 const struct i2c_board_info *info)
 {
-	char modalias[sizeof(I2C_MODULE_PREFIX)
-		      + I2C_NAME_SIZE];
 	struct module *module = NULL;
 	struct i2c_client *client;
 	struct drm_i2c_encoder_driver *encoder_drv;
 	int err = 0;
 
-	snprintf(modalias, sizeof(modalias),
-		 "%s%s", I2C_MODULE_PREFIX, info->type);
-	request_module(modalias);
+	request_module("%s%s", I2C_MODULE_PREFIX, info->type);
 
 	client = i2c_new_device(adap, info);
 	if (!client) {
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
