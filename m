Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbaEBPqn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:46:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44348 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbaEBPqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:46:39 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 106/151] [media] em28xx: fix PCTV 290e LNA oops
Date: Fri,  2 May 2014 08:38:14 -0700
Message-Id: <1399045139-4531-107-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antti Palosaari <crope@iki.fi>

commit 3ec40dcfb413214b2874aec858870502b61c2202 upstream.

Pointer to device state has been moved to different location during
some change. PCTV 290e LNA function still uses old pointer, carried
over FE priv, and it crash.

Reported-by: Janne Kujanpää <jikuja@iki.fi>
Signed-off-by: Antti Palosaari <crope@iki.fi>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/media/usb/em28xx/em28xx-dvb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 344042b..d3b68fd 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -693,7 +693,8 @@ static void pctv_520e_init(struct em28xx *dev)
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
1.9.1

