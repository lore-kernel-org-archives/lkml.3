Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751034AbaKWMAx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 07:00:53 -0500
Received: from mout.web.de ([212.227.17.11]:58615 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbaKWMAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 07:00:51 -0500
Message-ID: <5471CC57.8040603@users.sourceforge.net>
Date: Sun, 23 Nov 2014 13:00:23 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Thomas Winischhofer <thomas@winischhofer.net>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] video: fbdev-SIS: Deletion of unnecessary checks before
 the function call "pci_dev_put"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:XdTKo7tN2TAep6XEI36W90/9sCBZvHnlhhXIwLKmzqJ8OLR6NrB
 IAKd7AswajYUoUWGTpfl/COdZJgKIzwwyp0hfUmY1iK6GhHzo6VaiF4boqnjrYArcivopTL
 ZJOK06u7Wuyx1rRZ5ef1GSmQrJNd1ao6Vom0VASZEbv5RhiJGMYqEi+6w66xE9Qi7DVNCLg
 RRbNP6gQyhTZQMQjQRlXw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 23 Nov 2014 12:55:25 +0100

The pci_dev_put() function tests whether its argument is NULL
and then returns immediately. Thus the test around the call
is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/video/fbdev/sis/sis_main.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/video/fbdev/sis/sis_main.c b/drivers/video/fbdev/sis/sis_main.c
index 3f12a2d..6548a3e 100644
--- a/drivers/video/fbdev/sis/sis_main.c
+++ b/drivers/video/fbdev/sis/sis_main.c
@@ -5989,7 +5989,7 @@ static int sisfb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	if(!ivideo->sisvga_enabled) {
 		if(pci_enable_device(pdev)) {
-			if(ivideo->nbridge) pci_dev_put(ivideo->nbridge);
+			pci_dev_put(ivideo->nbridge);
 			framebuffer_release(sis_fb_info);
 			return -EIO;
 		}
@@ -6202,10 +6202,8 @@ error_0:	iounmap(ivideo->video_vbase);
 error_1:	release_mem_region(ivideo->video_base, ivideo->video_size);
 error_2:	release_mem_region(ivideo->mmio_base, ivideo->mmio_size);
 error_3:	vfree(ivideo->bios_abase);
-		if(ivideo->lpcdev)
-			pci_dev_put(ivideo->lpcdev);
-		if(ivideo->nbridge)
-			pci_dev_put(ivideo->nbridge);
+		pci_dev_put(ivideo->lpcdev);
+		pci_dev_put(ivideo->nbridge);
 		if(!ivideo->sisvga_enabled)
 			pci_disable_device(pdev);
 		framebuffer_release(sis_fb_info);
@@ -6505,11 +6503,9 @@ static void sisfb_remove(struct pci_dev *pdev)
 
 	vfree(ivideo->bios_abase);
 
-	if(ivideo->lpcdev)
-		pci_dev_put(ivideo->lpcdev);
+	pci_dev_put(ivideo->lpcdev);
 
-	if(ivideo->nbridge)
-		pci_dev_put(ivideo->nbridge);
+	pci_dev_put(ivideo->nbridge);
 
 #ifdef CONFIG_MTRR
 	/* Release MTRR region */
-- 
2.1.3

