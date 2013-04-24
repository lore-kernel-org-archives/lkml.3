Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305Ab3DXLgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 07:36:55 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:43893 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610Ab3DXLgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 07:36:54 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Antti Palosaari <crope@iki.fi>, Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/2] [media] anysee: Initialize ret = 0 in anysee_frontend_attach()
Date: Wed, 24 Apr 2013 13:36:45 +0200
Message-Id: <1366803406-17738-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/media/usb/dvb-usb-v2/anysee.c: In function ‘anysee_frontend_attach’:
drivers/media/usb/dvb-usb-v2/anysee.c:641: warning: ‘ret’ may be used uninitialized in this function

And gcc is right (see the ANYSEE_HW_507T case), so initialize ret to zero
to fix this.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/media/usb/dvb-usb-v2/anysee.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/anysee.c b/drivers/media/usb/dvb-usb-v2/anysee.c
index a20d691..3a1f976 100644
--- a/drivers/media/usb/dvb-usb-v2/anysee.c
+++ b/drivers/media/usb/dvb-usb-v2/anysee.c
@@ -638,7 +638,7 @@ static int anysee_frontend_attach(struct dvb_usb_adapter *adap)
 {
 	struct anysee_state *state = adap_to_priv(adap);
 	struct dvb_usb_device *d = adap_to_d(adap);
-	int ret;
+	int ret = 0;
 	u8 tmp;
 	struct i2c_msg msg[2] = {
 		{
-- 
1.7.0.4

