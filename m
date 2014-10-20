Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915AbaJTVtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 17:49:19 -0400
Received: from smtp.outflux.net ([198.145.64.163]:34499 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753861AbaJTVtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 17:49:16 -0400
Date: Mon, 20 Oct 2014 14:49:04 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
Subject: [PATCH] [media] anysee: make sure loading modules is const
Message-ID: <20141020214904.GA32437@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure that loaded modules are const char strings so we don't
load arbitrary modules in the future, nor allow for format string
leaks in the module request call.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/media/usb/dvb-usb-v2/anysee.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/anysee.c b/drivers/media/usb/dvb-usb-v2/anysee.c
index d3c5f230e97a..ae917c042a52 100644
--- a/drivers/media/usb/dvb-usb-v2/anysee.c
+++ b/drivers/media/usb/dvb-usb-v2/anysee.c
@@ -630,8 +630,8 @@ error:
 	return ret;
 }
 
-static int anysee_add_i2c_dev(struct dvb_usb_device *d, char *type, u8 addr,
-		void *platform_data)
+static int anysee_add_i2c_dev(struct dvb_usb_device *d, const char *type,
+		u8 addr, void *platform_data)
 {
 	int ret, num;
 	struct anysee_state *state = d_to_priv(d);
@@ -659,7 +659,7 @@ static int anysee_add_i2c_dev(struct dvb_usb_device *d, char *type, u8 addr,
 		goto err;
 	}
 
-	request_module(board_info.type);
+	request_module("%s", board_info.type);
 
 	/* register I2C device */
 	client = i2c_new_device(adapter, &board_info);
-- 
1.9.1


-- 
Kees Cook
Chrome OS Security
