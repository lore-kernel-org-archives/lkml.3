Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab3IJW4P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 18:56:15 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64188 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab3IJW4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 18:56:14 -0400
MIME-Version: 1.0
Date: Wed, 11 Sep 2013 06:56:12 +0800
Message-ID: <CAPgLHd-Qzopm8EmcFOAnHk_UAks9FTFKnaS_4Xd3jnzPOtLChQ@mail.gmail.com>
Subject: [PATCH] drm/msm: fix return value check in ERR_PTR()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: airlied@linux.ie, robdclark@gmail.com
Cc: yongjun_wei@trendmicro.com.cn, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function drm_prime_pages_to_sg() returns ERR_PTR()
and never returns NULL. The NULL test in the return value check should
be replaced with IS_ERR().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/gpu/drm/msm/msm_gem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_gem.c b/drivers/gpu/drm/msm/msm_gem.c
index 6b5a6c8..3462def 100644
--- a/drivers/gpu/drm/msm/msm_gem.c
+++ b/drivers/gpu/drm/msm/msm_gem.c
@@ -40,9 +40,9 @@ static struct page **get_pages(struct drm_gem_object *obj)
 		}
 
 		msm_obj->sgt = drm_prime_pages_to_sg(p, npages);
-		if (!msm_obj->sgt) {
+		if (IS_ERR(msm_obj->sgt)) {
 			dev_err(dev->dev, "failed to allocate sgt\n");
-			return ERR_PTR(-ENOMEM);
+			return ERR_CAST(msm_obj->sgt);
 		}
 
 		msm_obj->pages = p;

