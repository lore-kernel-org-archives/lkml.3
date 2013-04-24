Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875Ab3DXCTa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 22:19:30 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:60785 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426Ab3DXCT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 22:19:29 -0400
MIME-Version: 1.0
Date: Wed, 24 Apr 2013 10:19:27 +0800
Message-ID: <CAPgLHd8Nj-K4X8gX4_bMFcYjCBU=XzFnGidhvfF0ZtoCXCv0qg@mail.gmail.com>
Subject: [PATCH -next] gpu: host1x: gr2d drivers/gpu/host1x/drm/gr2d.c: fix
 error return code in gr2d_submit()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: grant.likely@linaro.org, rob.herring@calxeda.com,
        thierry.reding@avionic-design.de, tbergstrom@nvidia.com,
        amerilainen@nvidia.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/gpu/host1x/drm/gr2d.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/host1x/drm/gr2d.c b/drivers/gpu/host1x/drm/gr2d.c
index 6a45ae0..146cd64 100644
--- a/drivers/gpu/host1x/drm/gr2d.c
+++ b/drivers/gpu/host1x/drm/gr2d.c
@@ -135,8 +135,10 @@ static int gr2d_submit(struct host1x_drm_context *context,
 			goto fail;
 
 		bo = host1x_bo_lookup(drm, file, cmdbuf.handle);
-		if (!bo)
+		if (!bo) {
+			err = -EINVAL;
 			goto fail;
+		}
 
 		host1x_job_add_gather(job, bo, cmdbuf.words, cmdbuf.offset);
 		num_cmdbufs--;
@@ -158,8 +160,10 @@ static int gr2d_submit(struct host1x_drm_context *context,
 		reloc->cmdbuf = cmdbuf;
 		reloc->target = target;
 
-		if (!reloc->target || !reloc->cmdbuf)
+		if (!reloc->target || !reloc->cmdbuf) {
+			err = -EINVAL;
 			goto fail;
+		}
 	}
 
 	err = copy_from_user(job->waitchk, waitchks,

