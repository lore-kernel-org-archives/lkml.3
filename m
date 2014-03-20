Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759965AbaCTWF5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 18:05:57 -0400
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:49145
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759160AbaCTWFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 18:05:55 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: mkrufky@linuxtv.org, m.chehab@samsung.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuah.kh@samusung.com,
        shuahkhan@gmail.com
Subject: [PATCH] media: lgdt3305 - add lgdt3304_ops: sleep
Date: Thu, 20 Mar 2014 16:05:50 -0600
Message-Id: <1395353150-6133-1-git-send-email-shuah.kh@samsung.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add sleep ops to lgdt3304_ops to invoke lgdt3305_sleep() to be called
from dvb_frontend_suspend(). lgdt3305_soft_reset() is called for both
3304 and 3305 devices. soft_reset and sleep touch LGDT3305_GEN_CTRL_3
on 3304 and 3305 devices. Hence, adding sleep to lgdt3304_ops will help
suspend 3304 properly from dvb_frontend_suspend().

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/media/dvb-frontends/lgdt3305.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/dvb-frontends/lgdt3305.c b/drivers/media/dvb-frontends/lgdt3305.c
index 1d2c473..92c891a 100644
--- a/drivers/media/dvb-frontends/lgdt3305.c
+++ b/drivers/media/dvb-frontends/lgdt3305.c
@@ -1176,6 +1176,7 @@ static struct dvb_frontend_ops lgdt3304_ops = {
 	},
 	.i2c_gate_ctrl        = lgdt3305_i2c_gate_ctrl,
 	.init                 = lgdt3305_init,
+	.sleep                = lgdt3305_sleep,
 	.set_frontend         = lgdt3304_set_parameters,
 	.get_frontend         = lgdt3305_get_frontend,
 	.get_tune_settings    = lgdt3305_get_tune_settings,
-- 
1.7.10.4

