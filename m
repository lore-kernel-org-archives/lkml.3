Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756021AbaKSQzo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 11:55:44 -0500
Received: from mout.web.de ([212.227.17.11]:55271 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755776AbaKSQzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 11:55:42 -0500
Message-ID: <546CCB7E.3050109@users.sourceforge.net>
Date: Wed, 19 Nov 2014 17:55:26 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] DRM-vmwgfx: Deletion of an unnecessary check before the
 function call "vfree"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:dM2Kshmlo+R1dQFqS0h1ItoATrq+3xPiQpvkbzOAryGylOfrcLp
 GSBksd3UJRLYhMH/oX05eIKSzmrN0MRWJnwe39p3fgym/9n+BdsihhcLuQKcvwZd1R7hrqa
 HrJ4QQmthUn1STcyh0HT/9aRK/VG1Fh3xr01jZ9qonM1j6MPnMuQYSHu2jAjyyaQvZ1Y/Z7
 B0TogeoakRSoEtQeRKzyA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 19 Nov 2014 17:50:19 +0100

The vfree() function performes also input parameter validation. Thus the test
around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
index 14b2f50..f9a67b8 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_drv.c
@@ -889,8 +889,7 @@ static int vmw_driver_unload(struct drm_device *dev)
 
 	if (dev_priv->ctx.res_ht_initialized)
 		drm_ht_remove(&dev_priv->ctx.res_ht);
-	if (dev_priv->ctx.cmd_bounce)
-		vfree(dev_priv->ctx.cmd_bounce);
+	vfree(dev_priv->ctx.cmd_bounce);
 	if (dev_priv->enable_fb) {
 		vmw_fb_close(dev_priv);
 		vmw_kms_restore_vga(dev_priv);
-- 
2.1.3

