Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167AbaKVQAm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 11:00:42 -0500
Received: from mout.web.de ([212.227.15.14]:64784 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275AbaKVQAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 11:00:40 -0500
Message-ID: <5470B315.8000507@users.sourceforge.net>
Date: Sat, 22 Nov 2014 17:00:21 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] video: fbdev-LCDC: Deletion of an unnecessary check before
 the function call "vfree"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:wJ79TvcaP5IKrddNb1w3ggZjvcbX1iZfcMHAzns5L8ppVocSVQz
 jvyF2rfg9seetdgARfTPDYaOzv3lUCkMkc0vhvXWlgi/RyOjEfbeCnQVtaJ4diO+JavK2Ec
 j2b57yzG0YlROkEkLFAYulrmd9P6N81XtAUWVEWr+AjE7ffJDLEJivtYtBAznWFPDclRW+l
 /v1MEA17r5XtaFbUWAnZw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 22 Nov 2014 16:51:31 +0100

The vfree() function performs also input parameter validation.
Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/video/fbdev/sh_mobile_lcdcfb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/sh_mobile_lcdcfb.c b/drivers/video/fbdev/sh_mobile_lcdcfb.c
index 2bcc84a..cfde21d 100644
--- a/drivers/video/fbdev/sh_mobile_lcdcfb.c
+++ b/drivers/video/fbdev/sh_mobile_lcdcfb.c
@@ -2181,8 +2181,7 @@ sh_mobile_lcdc_channel_fb_cleanup(struct sh_mobile_lcdc_chan *ch)
 	if (!info || !info->device)
 		return;
 
-	if (ch->sglist)
-		vfree(ch->sglist);
+	vfree(ch->sglist);
 
 	fb_dealloc_cmap(&info->cmap);
 	framebuffer_release(info);
-- 
2.1.3

