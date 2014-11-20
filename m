Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413AbaKTJzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 04:55:47 -0500
Received: from mout.web.de ([212.227.17.12]:55892 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757290AbaKTJzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 04:55:45 -0500
Message-ID: <546DBA8E.6080401@users.sourceforge.net>
Date: Thu, 20 Nov 2014 10:55:26 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux-media@vger.kernel.org, linux1394-devel@lists.sourceforge.net
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] [media] firewire: Deletion of an unnecessary check before
 the function call "dvb_unregister_device"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:ql/VlIxjaTLF3IaYHmvZrdYr9MoezCarSfzXWooO14HC6FQF50g
 Yr2AR4QFjxHj/xwBIU0aa688pov+8WjKz4FPgOHcB5CAsPofOxXkyrmrhLQFhLwOtbr0kcb
 Norh5/b7IdPOU+xC/4WpdID3o4GBzpCW0qSpzfXfUzA0ljO7ELGR6nSZH3ysyrI9PmPF1LX
 VvZV0RJnjxPEm3tevrzZQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Thu, 20 Nov 2014 10:49:07 +0100

The dvb_unregister_device() function tests whether its argument is NULL
and then returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/firewire/firedtv-ci.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/firewire/firedtv-ci.c b/drivers/media/firewire/firedtv-ci.c
index e5ebdbf..e63f582 100644
--- a/drivers/media/firewire/firedtv-ci.c
+++ b/drivers/media/firewire/firedtv-ci.c
@@ -253,6 +253,5 @@ int fdtv_ca_register(struct firedtv *fdtv)
 
 void fdtv_ca_release(struct firedtv *fdtv)
 {
-	if (fdtv->cadev)
-		dvb_unregister_device(fdtv->cadev);
+	dvb_unregister_device(fdtv->cadev);
 }
-- 
2.1.3

