Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124AbaAFPQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:16:35 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:43818 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbaAFPQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:16:34 -0500
Date: Mon, 6 Jan 2014 20:46:29 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        dri-devel@lists.freedesktop.org, josh@joshtriplett.org
Subject: [PATCH 18/85] drivers: gpu: Mark function as static in nv10_fence.c
Message-ID: <8c894ed7fab96e62bd260fea0ded6473b22185c9.1389018324.git.rashika.kheria@gmail.com>
References: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b21c9d47bbb72f2134540b852c908a2080f1ed1d.1389018324.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark function nv10_fence_context_new() as static in
drm/nouveau/nv10_fence.c because it is not used outside this file.

This eliminates the following warning in drm/nouveau/nv10_fence.c:
drivers/gpu/drm/nouveau/nv10_fence.c:69:1: warning: no previous prototype for ‘nv10_fence_context_new’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 drivers/gpu/drm/nouveau/nv10_fence.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nv10_fence.c b/drivers/gpu/drm/nouveau/nv10_fence.c
index 06f434f..b5de158 100644
--- a/drivers/gpu/drm/nouveau/nv10_fence.c
+++ b/drivers/gpu/drm/nouveau/nv10_fence.c
@@ -65,7 +65,7 @@ nv10_fence_context_del(struct nouveau_channel *chan)
 	kfree(fctx);
 }
 
-int
+static int
 nv10_fence_context_new(struct nouveau_channel *chan)
 {
 	struct nv10_fence_chan *fctx;
-- 
1.7.9.5

