Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479AbaLOTdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:33:19 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40942 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaLOTdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:33:15 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ilia Mirkin <imirkin@alum.mit.edu>, Ben Skeggs <bskeggs@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 71/96] drm/nouveau/gf116: remove copy1 engine
Date: Mon, 15 Dec 2014 11:26:31 -0800
Message-Id: <1418671616-25482-72-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418671616-25482-1-git-send-email-kamal@canonical.com>
References: <1418671616-25482-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilia Mirkin <imirkin@alum.mit.edu>

commit 226d63a1addea8cbe8fc671978e62dc84927b046 upstream.

Indications are that no GF116's actually have a copy engine there, but
actually have the decompression engine. This engine can be made to do
copies, but that should be done separately.

Unclear why this didn't turn up on all GF116's, but perhaps the
non-mobile ones came with enough VRAM to not trigger ttm migrations in
test scenarios.

Fixes: https://bugs.freedesktop.org/show_bug.cgi?id=85465
Fixes: https://bugs.freedesktop.org/show_bug.cgi?id=59168
Signed-off-by: Ilia Mirkin <imirkin@alum.mit.edu>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/nouveau/core/engine/device/nvc0.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/core/engine/device/nvc0.c b/drivers/gpu/drm/nouveau/core/engine/device/nvc0.c
index dbc5e33..0704a9f 100644
--- a/drivers/gpu/drm/nouveau/core/engine/device/nvc0.c
+++ b/drivers/gpu/drm/nouveau/core/engine/device/nvc0.c
@@ -212,7 +212,6 @@ nvc0_identify(struct nouveau_device *device)
 		device->oclass[NVDEV_ENGINE_BSP    ] = &nvc0_bsp_oclass;
 		device->oclass[NVDEV_ENGINE_PPP    ] = &nvc0_ppp_oclass;
 		device->oclass[NVDEV_ENGINE_COPY0  ] = &nvc0_copy0_oclass;
-		device->oclass[NVDEV_ENGINE_COPY1  ] = &nvc0_copy1_oclass;
 		device->oclass[NVDEV_ENGINE_DISP   ] = &nva3_disp_oclass;
 		device->oclass[NVDEV_ENGINE_PERFMON] = &nvc0_perfmon_oclass;
 		break;
-- 
1.9.1

