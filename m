Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933248AbaLBV4O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 16:56:14 -0500
Received: from mout.web.de ([212.227.15.14]:60194 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751289AbaLBV4N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 16:56:13 -0500
Message-ID: <547E356D.9050609@users.sourceforge.net>
Date: Tue, 02 Dec 2014 22:55:57 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jaroslav Kysela <perex@perex.cz>,
        Johannes Berg <johannes@sipsolutions.net>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] ALSA: i2sbus: Deletion of unnecessary checks before the function
 call "release_and_free_resource"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:V1+5DNS/FUAfj8RizgIx8AUGiVZofcaOReULh1u77jez4+xHoyn
 bAc2x9ky9GSZ2fRlLRZt87rKFcNuuRGGZ/YoJ4Z/+s/TjkckzGBDgtpru98yPlLqo9607D4
 9aHeVlAUuWadJ9dhLn3AWVFCJ2d7Q4HhRJUUxCtL7n7LWDcPVTZAH2PAE3TilygMCyoJ1wz
 YRlKKXWu2x2tj4h2rVnUQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 2 Dec 2014 22:50:24 +0100

The release_and_free_resource() function tests whether its argument is NULL
and then returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 sound/aoa/soundbus/i2sbus/core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/sound/aoa/soundbus/i2sbus/core.c b/sound/aoa/soundbus/i2sbus/core.c
index a80d5ea..4e2b4fb 100644
--- a/sound/aoa/soundbus/i2sbus/core.c
+++ b/sound/aoa/soundbus/i2sbus/core.c
@@ -79,8 +79,7 @@ static void i2sbus_release_dev(struct device *dev)
  	if (i2sdev->out.dbdma) iounmap(i2sdev->out.dbdma);
  	if (i2sdev->in.dbdma) iounmap(i2sdev->in.dbdma);
 	for (i = aoa_resource_i2smmio; i <= aoa_resource_rxdbdma; i++)
-		if (i2sdev->allocated_resource[i])
-			release_and_free_resource(i2sdev->allocated_resource[i]);
+		release_and_free_resource(i2sdev->allocated_resource[i]);
 	free_dbdma_descriptor_ring(i2sdev, &i2sdev->out.dbdma_ring);
 	free_dbdma_descriptor_ring(i2sdev, &i2sdev->in.dbdma_ring);
 	for (i = aoa_resource_i2smmio; i <= aoa_resource_rxdbdma; i++)
@@ -323,8 +322,7 @@ static int i2sbus_add_dev(struct macio_dev *macio,
 	if (dev->out.dbdma) iounmap(dev->out.dbdma);
 	if (dev->in.dbdma) iounmap(dev->in.dbdma);
 	for (i=0;i<3;i++)
-		if (dev->allocated_resource[i])
-			release_and_free_resource(dev->allocated_resource[i]);
+		release_and_free_resource(dev->allocated_resource[i]);
 	mutex_destroy(&dev->lock);
 	kfree(dev);
 	return 0;
-- 
2.1.3

