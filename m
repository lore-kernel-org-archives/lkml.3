Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbaK3UZ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 15:25:59 -0500
Received: from mout.web.de ([212.227.17.11]:56324 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650AbaK3UZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 15:25:57 -0500
Message-ID: <547B7D48.1010507@users.sourceforge.net>
Date: Sun, 30 Nov 2014 21:25:44 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        linux-media@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/2] [media] tuners: Deletion of unnecessary checks before
 the function call "release_firmware"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <547B7C36.1070600@users.sourceforge.net>
In-Reply-To: <547B7C36.1070600@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:+EvlZ6BDN/R23h33ezRWRSWbyIynqGUVHjt7NqhCPzxBrrs8K6H
 1XuOyVxhHE6bPDAIq2IWxqKL8m9gWXnL0ySzB9UCR0Rt+Ac85waj29yFSKYwP1KH+S+3mzi
 K3J82xAvq+Dgkf/ixQf8YnxFAXN2xDXj9c44z8rbgu0vgEwNWGvmIOvwSW4RxDC6budXWW/
 syx8ybWgQmEHf4Zo/Gw6g==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 30 Nov 2014 19:05:48 +0100

The release_firmware() function tests whether its argument is NULL
and then returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/tuners/si2157.c | 3 +--
 drivers/media/tuners/xc5000.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index 8e57696..e17ab1f 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -196,8 +196,7 @@ warm:
 	return 0;
 
 err:
-	if (fw)
-		release_firmware(fw);
+	release_firmware(fw);
 
 	dev_dbg(&s->client->dev, "failed=%d\n", ret);
 	return ret;
diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
index 705c258..2a039de 100644
--- a/drivers/media/tuners/xc5000.c
+++ b/drivers/media/tuners/xc5000.c
@@ -1336,8 +1336,7 @@ static int xc5000_release(struct dvb_frontend *fe)
 
 	if (priv) {
 		cancel_delayed_work(&priv->timer_sleep);
-		if (priv->firmware)
-			release_firmware(priv->firmware);
+		release_firmware(priv->firmware);
 		hybrid_tuner_release_state(priv);
 	}
 
-- 
2.1.3

