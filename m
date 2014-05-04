Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507AbaEDQa7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:30:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36257 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbaEDPl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Janne=20Kujanp=C3=A4=C3=A4?= <jikuja@iki.fi>,
        Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.14 118/158] media: em28xx: fix PCTV 290e LNA oops
Date: Sun,  4 May 2014 11:40:27 -0400
Message-Id: <20140504154046.034065363@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antti Palosaari <crope@iki.fi>

commit 3ec40dcfb413214b2874aec858870502b61c2202 upstream.

Pointer to device state has been moved to different location during
some change. PCTV 290e LNA function still uses old pointer, carried
over FE priv, and it crash.

Reported-by: Janne Kujanpää <jikuja@iki.fi>
Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/em28xx/em28xx-dvb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -693,7 +693,8 @@ static void pctv_520e_init(struct em28xx
 static int em28xx_pctv_290e_set_lna(struct dvb_frontend *fe)
 {
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
-	struct em28xx *dev = fe->dvb->priv;
+	struct em28xx_i2c_bus *i2c_bus = fe->dvb->priv;
+	struct em28xx *dev = i2c_bus->dev;
 #ifdef CONFIG_GPIOLIB
 	struct em28xx_dvb *dvb = dev->dvb;
 	int ret;


