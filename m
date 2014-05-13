Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932915AbaEMJkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:40:37 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60899 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760109AbaEMJ25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:57 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 093/182] media: em28xx: fix PCTV 290e LNA oops
Date: Tue, 13 May 2014 11:27:25 +0200
Message-Id: <fc238de4a00357b52b221386b519a343686b1a06.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Antti Palosaari <crope@iki.fi>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 3ec40dcfb413214b2874aec858870502b61c2202 upstream.

Pointer to device state has been moved to different location during
some change. PCTV 290e LNA function still uses old pointer, carried
over FE priv, and it crash.

Reported-by: Janne Kujanpää <jikuja@iki.fi>
Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/media/usb/em28xx/em28xx-dvb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index bb1e8dca80cd..069b7f0dfb36 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -673,7 +673,8 @@ static void pctv_520e_init(struct em28xx *dev)
 static int em28xx_pctv_290e_set_lna(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	struct em28xx *dev = fe->dvb->priv;
+	struct em28xx_i2c_bus *i2c_bus = fe->dvb->priv;
+	struct em28xx *dev = i2c_bus->dev;
 #ifdef CONFIG_GPIOLIB
 	struct em28xx_dvb *dvb = dev->dvb;
 	int ret;
-- 
1.9.3

