Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbaEIH6B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 03:58:01 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:15624 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbaEIH57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 03:57:59 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 09 May 2014 00:53:16 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>
CC: Thierry Reding <thierry.reding@gmail.com>, <nouveau@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] drm/gk20a/fb: fix NULL dereference
Date: Fri, 9 May 2014 16:57:48 +0900
Message-ID: <1399622268-16940-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.2
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gk20a_ram_put() can be called with a NULL nouveau_mem in case of error.
Handle that case the way is it done in other RAM drivers.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c b/drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c
index 403c88f07b99..7effd1a63458 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/fb/ramgk20a.c
@@ -36,6 +36,8 @@ gk20a_ram_put(struct nouveau_fb *pfb, struct nouveau_mem **pmem)
 	int i;
 
 	*pmem = NULL;
+	if (unlikely(mem == NULL))
+		return;
 
 	for (i = 0; i < mem->size; i++) {
 		struct page *page;
-- 
1.9.2

