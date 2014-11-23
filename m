Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635AbaKWPdq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 10:33:46 -0500
Received: from mout.web.de ([212.227.17.11]:53675 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbaKWPdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 10:33:44 -0500
Message-ID: <5471FE45.4010802@users.sourceforge.net>
Date: Sun, 23 Nov 2014 16:33:25 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] video: fbdev-VIA: Deletion of an unnecessary check before
 the function call "framebuffer_release"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:IeX3Wg5MCSeI1B1RGuxTGqQBjEBp+WUR3bsatkn7vKOSuQ4N8zt
 Rxx+C0VOUtrz3QISBXqguJsokIbPUEkwTjtpkK4liETw2ABkCwwZHyF1HrnqP2p/O/ZpuPk
 hkIaGdBXrl5taKNiL/LIbhRl7v5crrottlvVPLfIudhl0HU5VA+6sc4oLhfXyH0KXX0DrPe
 Kom4RuKWf1Bcm7vbUctSA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 23 Nov 2014 16:30:05 +0100

The framebuffer_release() function tests whether its argument is NULL
and then returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/video/fbdev/via/viafbdev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/via/viafbdev.c b/drivers/video/fbdev/via/viafbdev.c
index 325c43c..f9718f0 100644
--- a/drivers/video/fbdev/via/viafbdev.c
+++ b/drivers/video/fbdev/via/viafbdev.c
@@ -1937,8 +1937,7 @@ out_fb1_unreg_lcd_cle266:
 out_dealloc_cmap:
 	fb_dealloc_cmap(&viafbinfo->cmap);
 out_fb1_release:
-	if (viafbinfo1)
-		framebuffer_release(viafbinfo1);
+	framebuffer_release(viafbinfo1);
 out_fb_release:
 	i2c_bus_free(viaparinfo->shared);
 	framebuffer_release(viafbinfo);
-- 
2.1.3

