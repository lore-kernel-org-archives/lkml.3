Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbaGLQoo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 12:44:44 -0400
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:52155 "EHLO
	qmta01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752417AbaGLQoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 12:44:37 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: m.chehab@samsung.com, dheitmueller@kernellabs.com, olebowle@gmx.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] media: drx39xyj driver change to check fe exit flag from release
Date: Sat, 12 Jul 2014 10:44:14 -0600
Message-Id: <079a2ff6ea88b8918b6144c8c054c6d4bb044347.1405179280.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <cover.1405179280.git.shuah.kh@samsung.com>
References: <cover.1405179280.git.shuah.kh@samsung.com>
In-Reply-To: <cover.1405179280.git.shuah.kh@samsung.com>
References: <cover.1405179280.git.shuah.kh@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change drx39xyj_release() to check fe exit flag to detect the
device disconnect state and avoid accessing the device after
it has been removed.

Signed-off-by: Shuah Khan <shuah.kh@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 9482954..54855a9 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -12238,7 +12238,9 @@ static void drx39xxj_release(struct dvb_frontend *fe)
 	struct drx39xxj_state *state = fe->demodulator_priv;
 	struct drx_demod_instance *demod = state->demod;
 
-	drxj_close(demod);
+	/* if device is removed don't access it */
+	if (fe->exit != DVB_FE_DEVICE_REMOVED)
+		drxj_close(demod);
 
 	kfree(demod->my_ext_attr);
 	kfree(demod->my_common_attr);
-- 
1.7.10.4

