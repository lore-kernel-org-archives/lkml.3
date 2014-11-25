Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbaKYNeG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 08:34:06 -0500
Received: from mout.web.de ([212.227.17.11]:58524 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679AbaKYNeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 08:34:04 -0500
Message-ID: <54748541.4000600@users.sourceforge.net>
Date: Tue, 25 Nov 2014 14:33:53 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] GPU-DRM-MSM: Deletion of unnecessary checks before two
 function calls
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:hz4egsoUb2argFb8JaSS67PzNr7wAhUT9bYWYf4Tf6Xs49F3yln
 m49cfhcyyL47kKXacIF0HdUz3MazIMS3nuSQHiw5j06vRKHiVDMAp1+GwZ3OHPThNsaaZ5a
 8MfLcA0LIHZSNPlZt8MqNdUDXBu6J3iD5pB5cBj7T3xQMvW30yUEDasJLkiIspklAw8anc2
 2g8Io3OL9GK3SnKIqVzhQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 25 Nov 2014 14:30:28 +0100

The functions framebuffer_release() and vunmap() perform also input
parameter validation. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/gpu/drm/msm/msm_fbdev.c | 3 +--
 drivers/gpu/drm/msm/msm_gem.c   | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_fbdev.c b/drivers/gpu/drm/msm/msm_fbdev.c
index ab5bfd2..fd5a6f3 100644
--- a/drivers/gpu/drm/msm/msm_fbdev.c
+++ b/drivers/gpu/drm/msm/msm_fbdev.c
@@ -193,8 +193,7 @@ fail_unlock:
 fail:
 
 	if (ret) {
-		if (fbi)
-			framebuffer_release(fbi);
+		framebuffer_release(fbi);
 		if (fb) {
 			drm_framebuffer_unregister_private(fb);
 			drm_framebuffer_remove(fb);
diff --git a/drivers/gpu/drm/msm/msm_gem.c b/drivers/gpu/drm/msm/msm_gem.c
index 4b1b82a..157cf21 100644
--- a/drivers/gpu/drm/msm/msm_gem.c
+++ b/drivers/gpu/drm/msm/msm_gem.c
@@ -543,8 +543,7 @@ void msm_gem_free_object(struct drm_gem_object *obj)
 			drm_free_large(msm_obj->pages);
 
 	} else {
-		if (msm_obj->vaddr)
-			vunmap(msm_obj->vaddr);
+		vunmap(msm_obj->vaddr);
 		put_pages(obj);
 	}
 
-- 
2.1.3

