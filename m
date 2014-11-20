Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195AbaKTMJK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 07:09:10 -0500
Received: from mout.web.de ([212.227.15.3]:55087 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201AbaKTMJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 07:09:04 -0500
Message-ID: <546DD9CE.60008@users.sourceforge.net>
Date: Thu, 20 Nov 2014 13:08:46 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, linux-media@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] [media] rc: Deletion of unnecessary checks before two
 function calls
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:byZj8WC+eh9+XVwhKwz79m4MteVdYVbkwqf0TDFYlBQFSlAJDvt
 j6f1oaajqbqdhxmk8d6nH2XqM4TGeCYWmNqG4jOxofFnvbKzRa5mb/kRL8TsJH1c16xPfwr
 O/a0GGylW1rurEdZnH+mXrVY/Xw23hakf12mf22sjZBtCtQdOmB2TMUKpvaLFiPKt0irtgE
 qxjPB26iDmHa+BAzdeLuA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 20 Nov 2014 13:01:32 +0100

The functions input_free_device() and rc_close() test whether their argument
is NULL and then return immediately. Thus the test around the call
is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/rc/lirc_dev.c | 3 +--
 drivers/media/rc/rc-main.c  | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
index dc5cbff..5c232e6 100644
--- a/drivers/media/rc/lirc_dev.c
+++ b/drivers/media/rc/lirc_dev.c
@@ -518,8 +518,7 @@ int lirc_dev_fop_close(struct inode *inode, struct file *file)
 
 	WARN_ON(mutex_lock_killable(&lirc_dev_lock));
 
-	if (ir->d.rdev)
-		rc_close(ir->d.rdev);
+	rc_close(ir->d.rdev);
 
 	ir->open--;
 	if (ir->attached) {
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 8d3b74c..66df9fb 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1298,8 +1298,7 @@ void rc_free_device(struct rc_dev *dev)
 	if (!dev)
 		return;
 
-	if (dev->input_dev)
-		input_free_device(dev->input_dev);
+	input_free_device(dev->input_dev);
 
 	put_device(&dev->dev);
 
-- 
2.1.3

