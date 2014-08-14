Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbaHNBCF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 21:02:05 -0400
Received: from m12-12.163.com ([220.181.12.12]:39606 "EHLO m12-12.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752422AbaHNBCD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 21:02:03 -0400
X-Coremail-DSSMTP: 49.77.231.131
From: weiyj_lk@163.com
To: David Airlie <airlied@linux.ie>, Hai Li <hali@codeaurora.org>,
        Rob Clark <robdclark@gmail.com>, Thierry Reding <treding@nvidia.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@redhat.com>,
        "Matwey V. Kornilov" <matwey.kornilov@gmail.com>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drm/msm: Fix missing unlock on error in msm_fbdev_create()
Date: Thu, 14 Aug 2014 09:01:40 +0800
Message-Id: <1407978100-15947-1-git-send-email-weiyj_lk@163.com>
X-Mailer: git-send-email 1.9.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: DMCowEA5pT52CuxTFuqAAA--.1988S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7Wr4DCF4xGrWxXF4fWw4xXrb_yoW3uFX_W3
	4ruwn7XwnFyFn8KF1akrWSyr13tF1Y9r4rWr1Fy3yftrnrtr1rXr9Iyr1UXrWUZF4UtF1D
	A3WSqrs8Arn7GjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU5K1vPUUUUU==
X-Originating-IP: [49.77.231.131]
X-CM-SenderInfo: pzhl5yxbonqiywtou0bp/1tbiGRfn1lEANy-imQAAsN
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing unlock before return from function msm_fbdev_create()
in the error handling case.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/gpu/drm/msm/msm_fbdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/msm_fbdev.c b/drivers/gpu/drm/msm/msm_fbdev.c
index 9c5221c..ab5bfd2 100644
--- a/drivers/gpu/drm/msm/msm_fbdev.c
+++ b/drivers/gpu/drm/msm/msm_fbdev.c
@@ -143,7 +143,7 @@ static int msm_fbdev_create(struct drm_fb_helper *helper,
 	ret = msm_gem_get_iova_locked(fbdev->bo, 0, &paddr);
 	if (ret) {
 		dev_err(dev->dev, "failed to get buffer obj iova: %d\n", ret);
-		goto fail;
+		goto fail_unlock;
 	}
 
 	fbi = framebuffer_alloc(0, dev->dev);

