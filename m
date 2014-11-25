Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951AbaKYKk6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:40:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58224 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbaKYKk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:40:56 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Skeggs <bskeggs@redhat.com>, Sven Joachim <svenjoac@gmx.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 052/254] drm/nvc0-/fb/ram: fix use of non-existant ram if partitions aren't uniform
Date: Tue, 25 Nov 2014 10:36:42 +0000
Message-Id: <1416912004-5928-53-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Skeggs <bskeggs@redhat.com>

commit 3d9e3921f4d77bcaeea913c48b894d1208f0cb06 upstream.

Likely a large part of the GK106 woes..

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Cc: Sven Joachim <svenjoac@gmx.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnvc0.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/core/subdev/fb/ramnvc0.c b/drivers/gpu/drm/nouveau/core/subdev/fb/ramnvc0.c
index 5a6a5027f749..cd9920591a21 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/fb/ramnvc0.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/fb/ramnvc0.c
@@ -554,13 +554,13 @@ nvc0_ram_create_(struct nouveau_object *parent, struct nouveau_object *engine,
 	} else {
 		/* otherwise, address lowest common amount from 0GiB */
 		ret = nouveau_mm_init(&pfb->vram, rsvd_head,
-				      (bsize << 8) * parts, 1);
+				      (bsize << 8) * parts - rsvd_head, 1);
 		if (ret)
 			return ret;
 
 		/* and the rest starting from (8GiB + common_size) */
 		offset = (0x0200000000ULL >> 12) + (bsize << 8);
-		length = (ram->size >> 12) - (bsize << 8) - rsvd_tail;
+		length = (ram->size >> 12) - ((bsize * parts) << 8) - rsvd_tail;
 
 		ret = nouveau_mm_init(&pfb->vram, offset, length, 0);
 		if (ret)
-- 
2.1.0

