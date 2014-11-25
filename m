Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbaKYMul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:50:41 -0500
Received: from mout.web.de ([212.227.15.3]:54911 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494AbaKYMuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 07:50:39 -0500
Message-ID: <54747B11.9070104@users.sourceforge.net>
Date: Tue, 25 Nov 2014 13:50:25 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH 1/1] GPU-DRM-MSM-Adreno: Deletion of unnecessary checks before
 the function call "release_firmware"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:B3wjjb3AkgN4DXOINQowV6GHrl0znxVM9w10G/f82SeK+/nMRPp
 uolvL5M3E6HiiViZgUe5kHqqZ9jSxemDbaO4HDSjANHxkNEK+L+XWK93kjZFnVZZCSuPNjE
 SrReeP7vr3AbW9BToXdXvLXD8h3jPXF72CmJeDFhCmh2ixV2ABAmDHidxxDNB/QNt3hMqNU
 LQo6GrOAKOX24gk09dJyQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Tue, 25 Nov 2014 13:44:20 +0100

The release_firmware() function tests whether its argument is NULL
and then returns immediately. Thus the test around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/gpu/drm/msm/adreno/adreno_gpu.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/adreno_gpu.c b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
index 655ce5b..757052c 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
@@ -404,9 +404,7 @@ void adreno_gpu_cleanup(struct adreno_gpu *gpu)
 			msm_gem_put_iova(gpu->memptrs_bo, gpu->base.id);
 		drm_gem_object_unreference(gpu->memptrs_bo);
 	}
-	if (gpu->pm4)
-		release_firmware(gpu->pm4);
-	if (gpu->pfp)
-		release_firmware(gpu->pfp);
+	release_firmware(gpu->pm4);
+	release_firmware(gpu->pfp);
 	msm_gpu_cleanup(&gpu->base);
 }
-- 
2.1.3

