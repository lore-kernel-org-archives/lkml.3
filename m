Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbaKTIeT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 03:34:19 -0500
Received: from mout.web.de ([212.227.15.3]:57882 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbaKTIeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 03:34:17 -0500
Message-ID: <546DA770.5050709@users.sourceforge.net>
Date: Thu, 20 Nov 2014 09:33:52 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/3] [media] DVB-frontends: Deletion of unnecessary checks
 before the function call "release_firmware"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <546DA419.7050405@users.sourceforge.net>
In-Reply-To: <546DA419.7050405@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:LXAf1Fg9d55yroGgOH22sVfHu2f7FvZE6k/fUkdPVfsQDAGnrs+
 uSyt+06+OjIVobMtO6k15XUFnawp+gTGcYtls/JfO+S7bNinkBNe+LSye6/yINhDtXrPVzN
 L8hmWUZS0ibzO5qWd2VhNlCJzxhtHb7H0S8iGtvUsbAZMQjOzaAofWGuCpkUFg+R19gsilv
 JI2D/dGe+E7Mrd+arDOKA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 19 Nov 2014 22:27:24 +0100

The release_firmware() function tests whether its argument is NULL
and then returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 3 +--
 drivers/media/dvb-frontends/drxk_hard.c     | 3 +--
 drivers/media/dvb-frontends/m88ds3103.c     | 3 +--
 drivers/media/dvb-frontends/si2168.c        | 3 +--
 4 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 7ca7a21..08e6ca5 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -12255,8 +12255,7 @@ static void drx39xxj_release(struct dvb_frontend *fe)
 	kfree(demod->my_ext_attr);
 	kfree(demod->my_common_attr);
 	kfree(demod->my_i2c_dev_addr);
-	if (demod->firmware)
-		release_firmware(demod->firmware);
+	release_firmware(demod->firmware);
 	kfree(demod);
 	kfree(state);
 }
diff --git a/drivers/media/dvb-frontends/drxk_hard.c b/drivers/media/dvb-frontends/drxk_hard.c
index cce94a7..f871478 100644
--- a/drivers/media/dvb-frontends/drxk_hard.c
+++ b/drivers/media/dvb-frontends/drxk_hard.c
@@ -6309,8 +6309,7 @@ static void drxk_release(struct dvb_frontend *fe)
 	struct drxk_state *state = fe->demodulator_priv;
 
 	dprintk(1, "\n");
-	if (state->fw)
-		release_firmware(state->fw);
+	release_firmware(state->fw);
 
 	kfree(state);
 }
diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index dfe0c2f..e88f0f6 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -637,8 +637,7 @@ skip_fw_download:
 
 	return 0;
 err:
-	if (fw)
-		release_firmware(fw);
+	release_firmware(fw);
 
 	dev_dbg(&priv->i2c->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
index 8f81d97..6a455f9 100644
--- a/drivers/media/dvb-frontends/si2168.c
+++ b/drivers/media/dvb-frontends/si2168.c
@@ -469,8 +469,7 @@ static int si2168_init(struct dvb_frontend *fe)
 
 	return 0;
 err:
-	if (fw)
-		release_firmware(fw);
+	release_firmware(fw);
 
 	dev_dbg(&s->client->dev, "%s: failed=%d\n", __func__, ret);
 	return ret;
-- 
2.1.3

