Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757905Ab3FDRAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:00:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48395 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757869Ab3FDRAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:00:39 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Skeggs <bskeggs@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 31/75] drm/nvc0/ce: disable ce1 on a number of chipsets
Date: Tue,  4 Jun 2013 09:55:15 -0700
Message-Id: <1370364959-9475-32-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370364959-9475-1-git-send-email-kamal@canonical.com>
References: <1370364959-9475-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Skeggs <bskeggs@redhat.com>

commit 6d5f83834dc2b064b8c1202ea281820286b675a8 upstream.

The falcon is present, but the rest of the copy engine doesn't appear to
be...  PUNITS doesn't report disabled (maybe the bits for the copy engines
got added later?), so we end up trying to use a non-functional CE1, and
bust all sorts of things.. Most notably, suspend/resume..

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
[ kamal: backport to 3.8 ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/nouveau/core/subdev/device/nvc0.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/core/subdev/device/nvc0.c b/drivers/gpu/drm/nouveau/core/subdev/device/nvc0.c
index f046168..eaa2f1a 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/device/nvc0.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/device/nvc0.c
@@ -134,7 +134,6 @@ nvc0_identify(struct nouveau_device *device)
 		device->oclass[NVDEV_ENGINE_BSP    ] = &nvc0_bsp_oclass;
 		device->oclass[NVDEV_ENGINE_PPP    ] = &nvc0_ppp_oclass;
 		device->oclass[NVDEV_ENGINE_COPY0  ] = &nvc0_copy0_oclass;
-		device->oclass[NVDEV_ENGINE_COPY1  ] = &nvc0_copy1_oclass;
 		device->oclass[NVDEV_ENGINE_DISP   ] = &nva3_disp_oclass;
 		break;
 	case 0xce:
@@ -218,7 +217,6 @@ nvc0_identify(struct nouveau_device *device)
 		device->oclass[NVDEV_ENGINE_BSP    ] = &nvc0_bsp_oclass;
 		device->oclass[NVDEV_ENGINE_PPP    ] = &nvc0_ppp_oclass;
 		device->oclass[NVDEV_ENGINE_COPY0  ] = &nvc0_copy0_oclass;
-		device->oclass[NVDEV_ENGINE_COPY1  ] = &nvc0_copy1_oclass;
 		device->oclass[NVDEV_ENGINE_DISP   ] = &nva3_disp_oclass;
 		break;
 	case 0xc8:
-- 
1.8.1.2

